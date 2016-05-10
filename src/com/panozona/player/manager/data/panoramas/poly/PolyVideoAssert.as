package com.panozona.player.manager.data.panoramas.poly
{
	import com.panozona.player.manager.Manager;
	import com.panozona.player.manager.data.panoramas.poly.data.StreamData;
	import com.panozona.player.manager.data.panoramas.poly.data.VideoSettingsData;
	import com.panozona.player.manager.data.panoramas.poly.data.VideoStreamData;
	import com.panozona.player.manager.data.panoramas.poly.events.StreamEvent;
	import com.panozona.player.manager.events.PanoSoundEvent;
	import com.panozona.player.manager.events.PanoramaEvent;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.events.TimerEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Timer;
	
	public class PolyVideoAssert extends Sprite
	{
		private var settingsdata:VideoSettingsData;
		
		private var netConnection:NetConnection;
		private var netStream:NetStream;
		private var _soundTransform:SoundTransform;
		private var dataPropagationTimer:Timer;
		private var videoStreamData:VideoStreamData;
		private var isPaused:Boolean=false;
		private var isPlayed:Boolean=false;
		private var isPrePlayed:Boolean=false; //上一次播放状态
		
		private var _playerViewsplash:Sprite;
		private var _playerVideo:Video;
		private var _path:String = "";
		private var _w:Number = 0;
		private var _h:Number = 0;
		private var _sw:Number = 0;
		private var _sh:Number = 0;
		private var _offsetx:Number = 0;
		private var _offsety:Number = 0;
		private var _manager:Manager;
		
		private var _textsprite:TextField;
		
		public function PolyVideoAssert(manager:Manager,path:String,extra:String)
		{
			this._path = path;
			
			settingsdata = new VideoSettingsData(extra);
			this.rotation =  settingsdata.rotation;
			
			_w = 500;
			_h  = 375;
			_sw = _w;
			_sh = _h;
			
			_manager = manager;
			_manager.addEventListener(PanoramaEvent.PANORAMA_STARTED_LOADING, onPanoramaStartedLoading, false, 0 , true);
			this.addEventListener(PanoSoundEvent.SOUNDCHANGE, PanoSoundEventSoundChangeHandler, false, 0 , true);
			this.initvideo();
			
			
			
			
			
		}
		
		public function get  sw():Number
		{
			return _sw;
		}
		public function get sh():Number
		{
			return _sh;
		}
		
		
		private function onPanoramaStartedLoading(e:Event):void
		{
			
			if(videoStreamData != null)
			{
				videoStreamData.streamState = StreamData.STATE_STOP;
				netStream.close();
				while (numChildren) removeChildAt(0);
			}
		}
		
		private function PanoSoundEventSoundChangeHandler(e:PanoSoundEvent):void {
			if(e.targetsource == "polyvideoassert")
			{
				return;
			}
			
			if(e.state == "play")
			{
				isPrePlayed = this.isPlayed;
				videoStreamData.streamState = StreamData.STATE_STOP;
			}
			else if(e.state == "stop")
			{
				//如果上一次播放是播放状态
				if(isPrePlayed == true)
				{
					videoStreamData.streamState = StreamData.STATE_PLAY;
				}
			}
		}
		
		
		
		
		private function initvideo():void
		{
			
			
			
			videoStreamData = new VideoStreamData();
			_soundTransform = new SoundTransform();
			_soundTransform.volume = settingsdata.volume;
			
			netConnection= new NetConnection();
			netConnection.connect(null);
			netStream = new NetStream(netConnection);
			netStream.bufferTime = 5; //seconds of video buffered before start playing
			netStream.soundTransform = _soundTransform;
			netStream.addEventListener(IOErrorEvent.IO_ERROR,errorHandler);
			netStream.addEventListener(NetStatusEvent.NET_STATUS, handleStatusChange);
			netStream.play(null);
			
			var client:Object = new Object();
			var metaDO:Object = function(metaData:Object):void {
				videoStreamData.streamInitiation(metaData.duration, netStream.bytesTotal, metaData.width, metaData.height);
			}
			client.onMetaData = metaDO;
			netStream.client = client;
			
		
			videoStreamData.addEventListener(StreamEvent.CHANGED_STREAM_STATE, handleStreamStateChange, false, 0, true);
		
			
			
			this.addEventListener(MouseEvent.CLICK,playviewMouseClickHandler);
			
			
			_playerVideo = new Video(_w, _h);
			_playerVideo.smoothing = true;
			_playerVideo.attachNetStream(netStream);
			
			
			this.addChild(_playerVideo);
			
			videostartplay();
			isPlayed = true;
			if (settingsdata.autoPlay == false)
			{	
				this.initsplash();
				videoStreamData.streamState = StreamData.STATE_PAUSE;
				isPlayed = false;
				
			}
			
			_manager.dispatchEvent(new Event(Event.RENDER));
			
		}
		private function errorHandler(e:IOError):void{
			trace(e.message+":"+e.errorID);
		}
		private function initsplash():void
		{
			if (settingsdata.splashPath != "")
			{
				var spashLoader:Loader = new Loader();
				spashLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, spashLost);
				spashLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, spashLoaded);
				spashLoader.load(new URLRequest(settingsdata.splashPath),new LoaderContext(true));
			}
		}
		
		
		private function spashLost(e:IOErrorEvent):void {
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, spashLost);
			e.target.removeEventListener(Event.COMPLETE, spashLoaded);
			
		}
		
		private function spashLoaded(e:Event):void {
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, spashLost);
			e.target.removeEventListener(Event.COMPLETE, spashLoaded);
			
			_playerViewsplash = new Sprite();
			_playerViewsplash.addChild( new Bitmap(e.target.content.bitmapData));
			_playerViewsplash.width = _sw;
			_playerViewsplash.height = _sh;
			this.addChild(_playerViewsplash);
		
		}
		
		
		
		
		
		private function videostartplay():void
		{
			trace("videostartplay"+_path);
			netStream.play(_path);
		}
		
		
		private function playviewMouseClickHandler(e:MouseEvent):void
		{
			
			if(_playerViewsplash != null && this.contains(_playerViewsplash))
			{
				this.removeChild(_playerViewsplash);
			}
			
			if( isPlayed == true)
			{
				videoStreamData.streamState = StreamData.STATE_PAUSE;
				
				if(this.settingsdata.pause_clickaction != ""){
					_manager.runActionCode(this.settingsdata.pause_clickaction);
				}
				if(this.settingsdata.pause_actionid != ""){
					_manager.runAction(this.settingsdata.pause_actionid);
				}
			}
			else
			{
				videoStreamData.streamState = StreamData.STATE_PLAY;
				if(this.settingsdata.play_clickaction != ""){
					_manager.runActionCode(this.settingsdata.play_clickaction);
				}
				if(this.settingsdata.play_actionid != ""){
					_manager.runAction(this.settingsdata.play_actionid);
				}
			}
		}
		
		
		private function handleStatusChange(e:NetStatusEvent):void {
			trace("e.info.code"+e.info.code);
			switch(e.info.code){
				case "NetStream.Play.Start" :
			
					break;
				case "NetStream.Buffer.Empty" :
				
					
					break;
				case "NetStream.Buffer.Full" :
				
					break;
				case "NetStream.Play.Stop" : // finished playing
					
					videoStreamData.streamState = StreamData.STATE_STOP;
					
					break;
			}
		}
		

		
		private function handleStreamStateChange(e:Event):void {
			trace("handleStreamStateChange"+videoStreamData.streamState);
			switch(videoStreamData.streamState) {
				case StreamData.STATE_PLAY:
					this.dispatchEvent(new PanoSoundEvent(PanoSoundEvent.SOUNDCHANGE,"play","polyvideoassert"));
					if (isPaused) {
						isPaused = false;
						isPlayed = true;
						netStream.resume();
					}else {
						isPlayed = true;
						videostartplay();
					}
					
					break;
				case StreamData.STATE_PAUSE:
					this.dispatchEvent(new PanoSoundEvent(PanoSoundEvent.SOUNDCHANGE,"stop","polyvideoassert"));
					isPaused = true;
					isPlayed = false;
					netStream.pause();
					break;
				case StreamData.STATE_STOP:
					//重来
					isPlayed = true;
					videostartplay();
					
					
					//this._manager.dispatchEvent(new PanoSoundEvent(PanoSoundEvent.SOUNDCHANGE,"stop","polyvideoassert"));
					//isPaused = false;
					//isPlayed = false;
					//dataPropagationTimer.stop();
					//netStream.close();
					break
			}
			
			
			//状态变化
			switch(videoStreamData.streamState) {
				case StreamData.STATE_PLAY:
					_playerVideo.visible = true;
					if (_playerViewsplash != null) {
						_playerViewsplash.visible = false;
					}
					break;
				case StreamData.STATE_PAUSE:
					_playerVideo.visible = true;
					break;
				case StreamData.STATE_STOP:
					_playerVideo.visible = true;
					if (_playerViewsplash != null) {
						_playerVideo.visible = false;
						_playerViewsplash.visible = true;
					}
					break;
			}
		}
		
	
		
		
	}
}
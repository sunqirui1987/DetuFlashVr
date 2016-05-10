package com.panozona.player.manager.data.panoramas.poly
{

	import com.panozona.player.QjPlayer;
	import com.panozona.player.manager.Manager;
	import com.panozona.player.manager.data.panoramas.HotspotPolygonal;
	import com.panozona.player.manager.data.panoramas.poly.data.ImageSettingsData;
	import com.panozona.player.manager.data.panoramas.poly.data.StreamData;
	import com.panozona.player.manager.data.panoramas.poly.data.VideoSettingsData;
	import com.panozona.player.manager.data.panoramas.poly.data.VideoStreamData;
	import com.panozona.player.manager.events.PanoSoundEvent;
	import com.panozona.player.manager.events.PanoramaEvent;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
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
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.Timer;
	
	public class PolyImageAssert extends Sprite
	{
		private var settingsdata:ImageSettingsData;
		
		private var netStream:NetStream;
		private var _soundTransform:SoundTransform;
		private var dataPropagationTimer:Timer;
		private var videoStreamData:VideoStreamData;
		private var isPaused:Boolean=false;
		private var isPlayed:Boolean=false;
		
		private var _playerViewsplash:Sprite;
		private var _playerVideo:Video;
		private var _playermovieclip:MovieClip=null;
		
		
		private var _path:String = "";
		private var _sw:Number = 0;
		private var _sh:Number = 0;
		private var _manager:Manager;
		private var spashLoader:Loader;

		public function PolyImageAssert(manager:Manager,path:String,extra:String)
		{
			this._manager = manager;
			this._path = path;
			settingsdata = new ImageSettingsData(extra);
			this.initsplash();
			_manager.addEventListener(PanoramaEvent.PANORAMA_STARTED_LOADING, onPanoramaStartedLoading, false, 0 , true);
			this.addEventListener(MouseEvent.CLICK,playviewMouseClickHandler);
		}
		
		private function onPanoramaStartedLoading(e:Event):void
		{
			
				
			try{
				if(spashLoader != null){
					spashLoader.unloadAndStop(true);
				}
				_playermovieclip.flvstop();
			}catch(e:Error){}
			
			while (numChildren) {removeChildAt(0)};
			
		}
		private function playviewMouseClickHandler(e:MouseEvent):void
		{
			try{
				trace("fun");
				
				_playermovieclip.toggleplay();
			}catch(e:Error){}
			
			if(this.settingsdata.clickaction != ""){
				_manager.runActionCode(this.settingsdata.clickaction);
			}
			if(this.settingsdata.actionid != ""){
				_manager.runAction(this.settingsdata.actionid);
			}
			
		
		}
		public function get  sw():Number
		{
			return _sw;
		}
		public function get sh():Number
		{
			return _sh;
		}
		
		private function initsplash():void
		{
			if (_path != "")
			{
				spashLoader = new Loader();
				spashLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, spashLost);
				spashLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, spashLoaded);
				spashLoader.load(new URLRequest(_path),new LoaderContext(true));
			}
		}
		
		
		private function spashLost(e:IOErrorEvent):void {
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, spashLost);
			e.target.removeEventListener(Event.COMPLETE, spashLoaded);
		}
		
		private function spashLoaded(e:Event):void {
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, spashLost);
			e.target.removeEventListener(Event.COMPLETE, spashLoaded);
			
			var displayobj:DisplayObject = (e.target as LoaderInfo).content;
			try{
				_playermovieclip = displayobj as MovieClip;
				_playermovieclip.fplay();
				_playermovieclip.qjPlayer = QjPlayer(_manager.parent);
			}catch(e:Error){}
			
			_playerViewsplash = new Sprite();
			_playerViewsplash.addChild( displayobj);
			if(_playerViewsplash.width == 0)
			{
				_playerViewsplash.width = 500;
			}
			if(_playerViewsplash.height == 0)
			{
				_playerViewsplash.height = 375;
			}
			_sw = _playerViewsplash.width;
			_sh = _playerViewsplash.height;
			
			
			this.addChildAt(_playerViewsplash,0);
			
			_manager.dispatchEvent(new Event(Event.RENDER));
		
		}
		
		
		
	}
}



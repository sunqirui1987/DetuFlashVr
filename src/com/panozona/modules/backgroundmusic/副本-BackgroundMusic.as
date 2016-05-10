/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.backgroundmusic{
	
	import com.panozona.modules.backgroundmusic.data.BackgroundMusicData;
	import com.panozona.modules.backgroundmusic.data.structure.Track;
	import com.panozona.player.manager.events.PanoSoundEvent;
	import com.panozona.player.module.Module;
	import com.panozona.player.module.data.ModuleData;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	public class BackgroundMusic extends Module {
		

		public var backgroundMusicData:BackgroundMusicData;
		
		
		public var currentTrack:Track = new Track();
		public var preTrack:Track = new Track();
		
		
		public var isPlaying:Boolean;
		
		public var soundChannel:SoundChannel;
		public var sound:Sound;
		public var _soundTransform:SoundTransform;
		public var _isoncetime:Boolean = true;
		public var _timer:Timer; 
		public var pausePosition:Number = 0;

		public var isCurrentPlay:Boolean = false;

		
		public var isPrePlayed:Boolean=false; //上一次播放状态
		
		public var currettrackpath:String = "";
		
		public var soundarr:Dictionary = new Dictionary();
		
		public function BackgroundMusic() {
			super("BackgroundMusic", "1.1", "http://ouwei.cn/wiki/Module:BackgroundMusic");
			
			moduleDescription.addFunctionDescription("setTrack", String);
			moduleDescription.addFunctionDescription("setPlay", Boolean);
			moduleDescription.addFunctionDescription("togglePlay");
			moduleDescription.addFunctionDescription("toggleBgMusic");
			moduleDescription.addFunctionDescription("toggleTrackPlay",String);
			moduleDescription.addFunctionDescription("closeNoBgTrack");
			
		}
		
		override protected function moduleReady(moduleData:ModuleData):void {
			backgroundMusicData = new BackgroundMusicData(moduleData, qjPlayer);
			_soundTransform = new SoundTransform();
	
			if (backgroundMusicData.settings.play) {
				var panoramaEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.events.PanoramaEvent") as Class;
				qjPlayer.manager.addEventListener(panoramaEventClass.PANORAMA_STARTED_LOADING, onFirstPanoramaStartedLoading, false, 0, true);
			}
			
			qjPlayer.manager.addEventListener(PanoSoundEvent.SOUNDCHANGE, PanoSoundEventSoundChangeHandler, false, 0 , true);
		}
		
		private function PanoSoundEventSoundChangeHandler(e:PanoSoundEvent):void {
			if(e.targetsource == "backgroundmusic")
			{
				return;
			}
			
			if(e.state == "play")
			{
				isPrePlayed = this.isCurrentPlay;
				pause();
			}
			else if(e.state == "stop")
			{
				//如果上一次播放是播放状态
				if(isPrePlayed == true)
				{
					play();
				}
			}
		}
		
		
		
		private function onFirstPanoramaStartedLoading(panoramaEvent:Object):void {
		//	var panoramaEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.events.PanoramaEvent") as Class;
		//	qjPlayer.manager.removeEventListener(panoramaEventClass.PANORAMA_STARTED_LOADING, onFirstPanoramaStartedLoading);
			
			var playerTrack:Track = null;
		
			//优先查找 已设置过音乐的场景
			for each(var track:Track in backgroundMusicData.tracks.getChildrenOfGivenClass(Track)) {
					if( track.path != "" && track.isbg == true){


							var panoarr:Array = track.panoid.split(",");
							for(var i:Number = 0;  i<panoarr.length;  i++){
								var panoid:String = panoarr[i];
								if ( qjPlayer.manager.currentPanoramaData.id == panoid ){
									playerTrack  = track;
									break;
								}
						  }
							
							
					}
			}
			
		//所有场景
			if( playerTrack  ==  null) {
				for each(var ttrack:Track in backgroundMusicData.tracks.getChildrenOfGivenClass(Track)) {
					if( ttrack.path != "" && ttrack.isbg == true && ttrack.panoid == ""){
						playerTrack  = ttrack;
						break;
					}
				}
				
			}
		
			
			if(playerTrack != null ){
			
			
				this.printInfo(">> "+qjPlayer.manager.currentPanoramaData.id+" >> currentTrack.id "+ currentTrack.id + ": playerTrackId "+ playerTrack.id +":end")
				
				if(  playerTrack.id != currentTrack.id ){
					
					CurrentTrack =  playerTrack;
					delete soundarr[playerTrack.id];
					
					
					stopCurrentTrack();
					playCurrentTrack();
				}
				
			}
			
		
			
		}
		
	
		
		public function playCurrentTrack():void {
			
			//保存
			for each(var track:Track in backgroundMusicData.tracks.getChildrenOfGivenClass(Track)) {
				if (track.id == currentTrack.id){
					
					
					stopCurrentTrack();
					
					currettrackpath = track.path;
				
					this.printInfo("---开启当前声音----");
					var soundobj:Object =  soundarr[track.id];
					if(soundobj == null)
					{
						soundobj = new Object();
					}
					var soundposition:Number= 0;
					if( soundobj.soundposition != null &&　track.isbg == true)
					{
						soundposition = soundobj.soundposition;
						
						this.printInfo("==========soundChannel.position  :"+ soundposition + " " +track.id );
			
					}
					sound = new Sound();
					sound.addEventListener(IOErrorEvent.IO_ERROR, soundLost, false, 0, true);
					sound.load(new URLRequest(track.path),new SoundLoaderContext(1000,true));
					_soundTransform.volume = track.volume;
					soundChannel = sound.play(soundposition, (track.loop ? int.MAX_VALUE : 1), _soundTransform);
					soundChannel.addEventListener(Event.SOUND_COMPLETE, soundComplete, false, 0, true);
					
					
					soundobj.soundposition = soundChannel.position;
					soundobj.isbg = track.isbg;
					soundobj.soundChannel = soundChannel;
					soundarr[track.id] = soundobj;
					
					
					qjPlayer.manager.runAction(backgroundMusicData.settings.onPlay);
					backgroundMusicData.settings.play = true;
					isCurrentPlay = true;
					
					
					qjPlayer.manager.dispatchEvent(new PanoSoundEvent(PanoSoundEvent.SOUNDCHANGE,"play","backgroundmusic"));
					
					
				}
			}
		}
		
		public function soundLost(e:IOErrorEvent):void {
			stopCurrentTrack();
			printWarning("File not found in track: " + currentTrack.id +":"+currettrackpath+":"+e.text);
		}
		
		public function stopCurrentTrack():void {
			
			qjPlayer.manager.dispatchEvent(new PanoSoundEvent(PanoSoundEvent.SOUNDCHANGE,"stop","backgroundmusic"));
			
			
			this.printInfo("=====================================================================");
		
			
			
			this.printInfo("---暂停并保存其他背景声音----");
			for (var trackid:String in soundarr)
			{
				
				soundarr[trackid].soundposition = soundarr[trackid].soundChannel.position;
				this.printInfo("----> 保存起来  " + trackid +"----"+soundarr[trackid].soundposition );
				
			}
			
			
			this.printInfo("---关闭前一个声音----");
			
			if(soundChannel != null){
				soundChannel.stop();
			}
			if(sound != null){
				sound.removeEventListener(IOErrorEvent.IO_ERROR, soundLost);
				sound = null;
				qjPlayer.manager.runAction(backgroundMusicData.settings.onStop);
			}
			backgroundMusicData.settings.play = false;
			isCurrentPlay = false;
		}
		
		public function soundComplete(e:Event):void {
			var tracksArray:Array = backgroundMusicData.tracks.getChildrenOfGivenClass(Track);
			for (var i:int = 0; i < tracksArray.length; i++) {
				if (tracksArray[i].id == currentTrack.id) {
					if (tracksArray[i].next != null) {
						currentTrack.id = tracksArray[i].next;
						playCurrentTrack();
					}else {
						stopCurrentTrack();
					}
					return;
				}
			}
		}
		
		
		public function set CurrentTrack(val:Track):void {
			this.preTrack = this.currentTrack;
			this.currentTrack = val;
		}
		
///////////////////////////////////////////////////////////////////////////////
//  Exposed functions 
///////////////////////////////////////////////////////////////////////////////
		public function closeNoBgTrack():void {
			var isfind:Boolean = false;
			for each(var track:Track in backgroundMusicData.tracks.getChildrenOfGivenClass(Track)) {
				if (track.id == this.currentTrack.id && track.isbg ==true) {
					isfind = true;
					break;

				}
			}
			if(isfind == false)
			{
				stopCurrentTrack();
			}
			
		}
		public function setTrack(trackId:String):void {
			for each(var track:Track in backgroundMusicData.tracks.getChildrenOfGivenClass(Track)) {
				if (track.id == trackId) {
					CurrentTrack = track;
					playCurrentTrack();
					return;
				}
			}
			printWarning("Track does not exist: " + trackId);
		}
		
		public function toggleBgMusic():void {
		
			if(sound == null){
				if( this.currentTrack.isbg == false){
					this.currentTrack = this.preTrack 
				}
				playCurrentTrack();
			}else {
				stopCurrentTrack();
			}
		}
		public function togglePlay():void {
			if(sound == null){
				playCurrentTrack();
			}else {
				stopCurrentTrack();
			}
		}
		public function toggleTrackPlay(trackId:String):void {
			
			if(trackId == currentTrack.id)
			{
				togglePlay();
				return;
			}
			setTrack(trackId);
		}
		
		//暂停
		public function pause():void
		{
			if(soundChannel != null  && soundChannel != null){
				pausePosition = soundChannel.position; 
				soundChannel.stop();
			//	isPrePlayed = isCurrentPlay = false;
				isCurrentPlay = false;
				qjPlayer.manager.dispatchEvent(new PanoSoundEvent(PanoSoundEvent.SOUNDCHANGE,"stop","backgroundmusic"));
			}
			
		}
		//播放
		public function play():void
		{
			if(sound != null && soundChannel != null){
				soundChannel.stop();
				soundChannel =  sound.play(pausePosition);
				isPrePlayed = isCurrentPlay = true;
				qjPlayer.manager.dispatchEvent(new PanoSoundEvent(PanoSoundEvent.SOUNDCHANGE,"play","backgroundmusic"));
			}
		}
		
		public function setPlay(value:Boolean):void {

			if(sound == null && value){
				playCurrentTrack();
				return;
			}
			if(sound != null && !value){
				stopCurrentTrack();
				return;
			}
		}
	}
}
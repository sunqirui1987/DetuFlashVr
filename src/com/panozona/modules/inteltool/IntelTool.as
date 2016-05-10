package com.panozona.modules.inteltool
{

	import com.panosalado.utils.Animation;
	import com.panozona.common.BitMapAnimation;
	import com.panozona.common.Ranger;
	import com.panozona.modules.compass.model.structure.Close;
	import com.panozona.modules.inteltool.controller.SpeakViewController;
	import com.panozona.modules.inteltool.data.DySetting;
	import com.panozona.modules.inteltool.data.InterToolData;
	import com.panozona.modules.inteltool.data.PanoSetting;
	import com.panozona.modules.inteltool.view.SpeakView;
	import com.panozona.modules.openMovie.controller.OpenMovieController;
	import com.panozona.modules.openMovie.view.OpenMovieView;
	import com.panozona.modules.openhd.data.OpenHDData;
	import com.panozona.modules.openhd.data.StyleContent;
	import com.panozona.modules.swfload.data.SwfLoadData;
	import com.panozona.player.module.Module;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.data.property.Align;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;

	public class IntelTool extends Module
	{
		private var interToolData:InterToolData;
		private var panoramaEventClass:Class;
		private var soundChannel:SoundChannel;
		private var sound:Sound;
		private var _soundTransform:SoundTransform;
		private var _isplay:Boolean=false;
		
		private var sound_position:Number=0;
		public function IntelTool()
		{
			super("IntelTool", "1.0", "http://ouwei.cn/wiki/Module:IntelTool");
					
			moduleDescription.addFunctionDescription("setPosition",Number);
			moduleDescription.addFunctionDescription("toggleStartPlay");
			
		}
		
		
	
		override protected function moduleReady(moduleData:ModuleData):void {
			
			interToolData = new InterToolData(moduleData, qjPlayer); // allways read data first 
	
			panoramaEventClass = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.events.PanoramaEvent") as Class;
			qjPlayer.manager.addEventListener(panoramaEventClass.TRANSITION_ENDED, onTransitionEnded, false, 0 , true);
			qjPlayer.manager.addEventListener(panoramaEventClass.PANORAMA_STARTED_LOADING, onPanoramaStartedLoading, false, 0 , true);
			qjPlayer.manager.addEventListener(panoramaEventClass.PANORAMA_LOADED, onPanoramaLoaded, false, 0 , true);
			

			
			this.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
			
			if(interToolData.dysettings.enable == true)
			{
				_soundTransform = new SoundTransform();
				
			}
			
			speakView = new SpeakView(interToolData);
			addChild(speakView);
			speakViewController = new SpeakViewController(speakView,this);
		}
		
		private var speakView:SpeakView;
		
		private var speakViewController:SpeakViewController;
		
		private function playsoundChannel():void
		{
			stopsoundChannel();

			//开启音乐
			sound  =  new Sound();
			sound.load(new URLRequest(interToolData.dysettings.mp3url),new SoundLoaderContext(1000,true));
			
			_soundTransform.volume = 1;
			soundChannel = sound.play(sound_position,0, _soundTransform);
			sound.addEventListener(IOErrorEvent.IO_ERROR,ioerrorHandler);
			soundChannel.addEventListener(Event.SOUND_COMPLETE,sounddCompleteHandler);
		
			_isplay=true;
			interToolData._isPlay = _isplay;
			
			printInfo("playsoundChannel");
		}
		private function sounddCompleteHandler(e:Event):void
		{
			sound_position=0;
			qjPlayer.managerData.controlData.autorotationCameraData.isAutorotating = false;
			qjPlayer.managerData.controlData.arcBallCameraData.enabled=true;
			qjPlayer.managerData.controlData.scrollCameraData.enabled=true;
			
			interToolData.dysettings.playenable =false;
			
		}
		private function ioerrorHandler(e:IOErrorEvent):void
		{
			printInfo(e.text.toString());
		}
		
		private function stopsoundChannel():void
		{
			if(soundChannel != null)
			{
				soundChannel.stop();
			}	
			_isplay=false;
			interToolData._isPlay = _isplay;

		
		}
		
		
		
		private function enableInterTool():void
		{
			
			
			
			if(interToolData.dysettings.enable == true)// && interToolData.dysettings.isenable==true)
			{
				
				if(_isplay == true)
				{
					qjPlayer.managerData.controlData.arcBallCameraData.enabled=false;
					qjPlayer.managerData.controlData.scrollCameraData.enabled=false;
				}
				else
				{
					qjPlayer.managerData.controlData.arcBallCameraData.enabled=true;
					qjPlayer.managerData.controlData.scrollCameraData.enabled=true;
				}
				
				if(interToolData.dysettings.playenable ==true)
				{
					if(_isplay == false)
					{
						playsoundChannel();
					}
					
					if(interToolData.dysettings.isenableauto == true)
					{
						qjPlayer.managerData.controlData.autorotationCameraData.isAutorotating = true;
						
						//qjPlayer.managerData.controlData.arcBallCameraData.enabled=false;
					//	qjPlayer.managerData.controlData.scrollCameraData.enabled=false;

					}
					
					if(soundChannel != null)
					{
						sound_position = soundChannel.position;
					}
					
					for each(var dy:DySetting in interToolData.dysettings.getChildrenOfGivenClass(DySetting))
					{
						if(Math.abs(dy.actiontime - sound_position) <= dy.actionchazi && dy.id == qjPlayer.manager.currentPanoramaData.id )
						{
							if(interToolData.dysettings.isenableauto == true)
							{
								qjPlayer.manager.runAction(dy.action);
							}
						}
					}
				}
				else
				{
					stopsoundChannel();
				}
				
			}
			
			if(interToolData.zzzsettings.enable == true && interToolData.zzzsettings.isenable==true)
			{
				for each(var pa:PanoSetting in interToolData.zzzsettings.getChildrenOfGivenClass(PanoSetting)) {
					
					if (pa.id == qjPlayer.manager.currentPanoramaData.id) 
					{
						//启用照中照功能
						var span:Number = qjPlayer.manager._pan;
						var stilt:Number = qjPlayer.manager._tilt;
						var sfov:Number = qjPlayer.manager._fieldOfView;
						
						var tpan:Number = pa.pan;
						var maxtpan:Number = pa.maxpan;
						
						var ttilt:Number = pa.tilt;
						var maxttilt:Number = pa.maxtilt;
						
						var tfov:Number = pa.fov;
						var maxtfov:Number = pa.maxfov;
						
					
						
						
						if( 
							( tpan <= span && maxtpan >= span)
							&&
							( ttilt <= stilt && maxttilt >= stilt)
							&&
							( tfov <= sfov && maxtfov >= sfov)
						)
						{
							
							//加载下一个场景
							printInfo("load next");
							
							qjPlayer.manager.runAction(pa.action);
							
							return;
							
						}
						
					}
				}
				
			}
			
		}
		
		private function onPanoramaStartedLoading(e:Event):void {
			interToolData.zzzsettings.isenable=false;
			interToolData.dysettings.isenable=false;
		}
		
	
		private function onPanoramaLoaded(e:Event):void {
			printInfo("Done loading: " + qjPlayer.manager.currentPanoramaData.id);
			interToolData.zzzsettings.isenable=true;
			interToolData.dysettings.isenable=true;
			
			
			if(interToolData.dysettings.enable == true)// && interToolData.dysettings.isenable==true)
			{
				var pos:Number = 0;
				for each(var dy:DySetting in interToolData.dysettings.getChildrenOfGivenClass(DySetting))
				{
					if(dy.id == qjPlayer.manager.currentPanoramaData.id )
					{
						if(pos < dy.starttime )
						{
							pos = dy.starttime;
						}
					}
				}
				if(pos != 0)
				{
					sound_position = pos;
				}
				
				
				if(interToolData.dysettings.playenable ==true)
				{
					playsoundChannel();
				}

			}
			
		}
		
		private function onTransitionEnded(e:Event):void 
		{
			
			printInfo("Transition ended: " + qjPlayer.manager.currentPanoramaData.id);
		
			interToolData.zzzsettings.isenable=true;
			interToolData.dysettings.isenable = true;
		}

		
		private function onEnterFrame(e:Event):void
		{
		
			enableInterTool();
		}
		
		
		
		///////////////////////////////////////////////////////////////////////////////
		//  Exposed functions 
		///////////////////////////////////////////////////////////////////////////////
		
		public function setPosition(p:Number):void {
			
			
			if(interToolData.dysettings.enable == true && interToolData.dysettings.isenable==true)
			{
				this.sound_position = p;
				this.playsoundChannel();
			}
		}
		
		public function toggleStartPlay():void {
			interToolData.dysettings.playenable = !interToolData.dysettings.playenable;
			interToolData.isPlay = !interToolData.isPlay;
		}
		
	}
}
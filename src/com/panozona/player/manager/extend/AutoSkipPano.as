package com.panozona.player.manager.extend
{
	import com.panozona.player.manager.Manager;
	import com.panozona.player.module.global;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class AutoSkipPano
	{
		private var _manager:Manager;
	
		public function AutoSkipPano(manager:Manager)
		{
			this._manager = manager;
		
			if(global.ISAUTOROTATIONGONEXT == true)
			{
				
				this._manager.addEventListener(Event.ENTER_FRAME, enterframeHandler, false, 0, true);
				
				var timer:Timer = new Timer(18000);
				timer.addEventListener(TimerEvent.TIMER,timereventHandler);
				timer.start();
			}
			
		
		}
		private function enterframeHandler(e:Event):void
		{
			_manager.managerData.controlData.arcBallCameraData.enabled=false;
			_manager.managerData.controlData.scrollCameraData.enabled=false;
			_manager.managerData.controlData.autorotationCameraData.isAutorotating=true;
		}
		
		private function timereventHandler(e:TimerEvent):void
		{
			this._manager.LoadNextPano("default");
		}
		
	}
}
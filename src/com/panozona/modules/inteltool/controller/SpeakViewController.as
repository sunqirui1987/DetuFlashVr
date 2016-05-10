package com.panozona.modules.inteltool.controller
{
	import com.panozona.modules.inteltool.IntelTool;
	import com.panozona.modules.inteltool.event.IntertoolEvent;
	import com.panozona.modules.inteltool.view.SpeakView;
	import com.panozona.player.module.Module;
	import com.panozona.player.module.data.property.Align;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.ApplicationDomain;

	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-5-9 下午8:39:46
	 * 功能描述:
	 */
	public class SpeakViewController
	{
		private var speakview:SpeakView;
		private var _module:Module;
		public function SpeakViewController(speakview:SpeakView,module:Module)
		{
			this.speakview = speakview;
			this._module = module;
			
			if(speakview.bitMapAnimation){
				speakview.bitMapAnimation.addEventListener(IntertoolEvent.SOURCE_LOADED,showAlign,false,0,true);
			}
			
			speakview.addEventListener(MouseEvent.ROLL_OVER,onRollOver);
			speakview.addEventListener(MouseEvent.ROLL_OUT,onRollOut);
			
			speakview.interTooldata.addEventListener(IntertoolEvent.PLAY_STATE_CHANGE,onChangeState,false,0,true);
			speakview.buttonMode = true;
			speakview.addEventListener(MouseEvent.CLICK,onClick);
			
			var ViewEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panosalado.events.ViewEvent") as Class;
			_module.qjPlayer.manager.addEventListener(ViewEventClass.BOUNDS_CHANGED, showAlign, false, 0, true);
			showAlign();
		}
		
		private function showAlign(e:Event=null):void{
			speakview.x = getWindowOpenX();
			speakview.y = getWindowOpenY();
		}
		
		protected function onClick(event:MouseEvent):void
		{
			(_module as IntelTool).toggleStartPlay();		
		}
		
		protected function onChangeState(event:Event):void
		{
			if(speakview.interTooldata.isPlay){
				speakview.setState(SpeakView.PLAYING);
			}else{
				speakview.setState(SpeakView.PLAY);
			}
		}
		
		protected function onRollOut(event:MouseEvent):void
		{
			if(speakview.interTooldata.isPlay){
				speakview.setState(SpeakView.PLAYING);
			}else{
				speakview.setState(SpeakView.PLAY);
			}	
		}
		
		private var lastRollOverState:String;
		protected function onRollOver(event:MouseEvent):void
		{
			if(speakview.interTooldata.isPlay){
				speakview.setState(SpeakView.PAUSE);
			}else{
				
			}		
		}
		
		private function getWindowOpenX():Number {
			var result:Number = 0;
			switch(speakview.interTooldata.speaker.align.horizontal) {
				case Align.RIGHT:
					result += _module.qjPlayer.manager.boundsWidth 
					- speakview.width 
					+ speakview.interTooldata.speaker.move.horizontal;
					break;
				case Align.LEFT:
					result += speakview.interTooldata.speaker.move.horizontal;
					break;
				default: // CENTER
					result += (_module.qjPlayer.manager.boundsWidth 
						- speakview.width) * 0.5 
					+ speakview.interTooldata.speaker.move.horizontal;
			}
			return result;
		}
		
		private function getWindowOpenY():Number{
			var result:Number = 0;
			switch(speakview.interTooldata.speaker.align.vertical) {
				case Align.TOP:
					result += speakview.interTooldata.speaker.move.vertical;
					break;
				case Align.BOTTOM:
					result += _module.qjPlayer.manager.boundsHeight 
					- speakview.height
					+ speakview.interTooldata.speaker.move.vertical;
					break;
				default: // MIDDLE
					result += (_module.qjPlayer.manager.boundsHeight 
						- speakview.height) * 0.5
					+ speakview.interTooldata.speaker.move.vertical;
			}
			return result;
		}
	}
}
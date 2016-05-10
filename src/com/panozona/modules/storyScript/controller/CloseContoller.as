package com.panozona.modules.storyScript.controller
{
	import com.panozona.modules.storyScript.StoryScript;
	import com.panozona.modules.storyScript.event.StoryScriptEvent;
	import com.panozona.player.module.utils.ZLoader;
	import com.panozona.modules.storyScript.view.CloseView;
	import com.panozona.player.module.Module;
	import com.panozona.player.module.data.property.Align;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.system.ApplicationDomain;

	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-8-14 下午2:04:46
	 * 功能描述:
	 */
	public class CloseContoller
	{
		
		private var closeView:CloseView;
		private var module:Module;
		
		public function CloseContoller(closeView:CloseView,module:Module)
		{
			this.closeView = closeView;
			this.module = module;
			
			var ViewEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panosalado.events.ViewEvent") as Class;
			module.qjPlayer.manager.addEventListener(ViewEventClass.BOUNDS_CHANGED, handleResize, false, 0, true);
		
			closeView.data.addEventListener(StoryScriptEvent.IS_SHOW_CLOSE_BTN_CHANGED,onChangeBtnVisible);
			
			new ZLoader().load(closeView.close.path,onErr,onCmp);
		}
		
		protected function onChangeBtnVisible(event:Event):void
		{
			closeView.visible = closeView.data.isShowCloseBtn;
		}
		
		private function onErr(event:IOErrorEvent):void
		{
			module.printError(event.text);			
		}
		
		private function onCmp(event:Event):void
		{
			closeView.addChild(event.target.content as DisplayObject);
			placeWindow();
			closeView.buttonMode = true;
			closeView.addEventListener(MouseEvent.CLICK,onClose);
		}
		
		protected function onClose(event:MouseEvent):void
		{
			closeView.data.isShowCloseBtn = false;	
			(module as StoryScript).stopScript();
		}
		
		private function handleResize(event:Event = null):void {
			placeWindow();
		}
		
		private function placeWindow():void
		{
			// TODO Auto Generated method stub
			closeView.x = getWindowOpenX();
			closeView.y = getWindowOpenY();
		}
		
		private function getWindowOpenX():Number {
			var result:Number = 0;
			switch(closeView.close.align.horizontal) {
				case Align.RIGHT:
					result += module.qjPlayer.manager.boundsWidth 
					- closeView.width 
					+ closeView.close.move.horizontal;
					break;
				case Align.LEFT:
					result += closeView.close.move.horizontal;
					break;
				default: // CENTER
					result += (module.qjPlayer.manager.boundsWidth 
						- closeView.width) * 0.5 
					+ closeView.close.move.horizontal;
			}
			return result;
		}
		
		private function getWindowOpenY():Number{
			var result:Number = 0;
			switch(closeView.close.align.vertical) {
				case Align.TOP:
					result += closeView.close.move.vertical;
					break;
				case Align.BOTTOM:
					result += module.qjPlayer.manager.boundsHeight 
					- closeView.height
					+ closeView.close.move.vertical;
					break;
				default: // MIDDLE
					result += (module.qjPlayer.manager.boundsHeight 
						- closeView.height) * 0.5
					+ closeView.close.move.vertical;
			}
			return result;
		}
	}
}
package com.panozona.modules.guestBook.controller
{
	import com.panozona.modules.guestBook.events.WindowEvent;
	import com.panozona.modules.guestBook.view.GuestBookView;
	import com.panozona.player.module.Module;
	import com.panozona.player.module.data.property.Transition;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.ApplicationDomain;
	
	import caurina.transitions.Tweener;

	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-2-20
	 * 功能描述:
	 */
	public class GuestBookController
	{
		private var windowController:WindowController;
		
		private var guestBookView:GuestBookView;
		
		private var module:Module
		
		public function GuestBookController(guestBookView:GuestBookView, module:Module)
		{
			this.guestBookView = guestBookView;
			this.module = module;
			
			windowController = new WindowController(guestBookView,module);
			
			if(guestBookView.guestBookData.setting.needBackShadow)
				guestBookView.windowView.windowData.addEventListener(WindowEvent.CHANGED_OPEN, onOpenChange, false, 0, true);
			
			var ViewEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panosalado.events.ViewEvent") as Class;
			module.qjPlayer.manager.addEventListener(ViewEventClass.BOUNDS_CHANGED, handleResize, false, 0, true);
			handleResize();
		
		}
		
		/**
		 * 舞台大小变化 
		 * @param event
		 * 
		 */		
		private function handleResize(event:Event = null):void {
			if(guestBookView.windowView.windowData.open)
				guestBookView.shadowView.drawBg(module.qjPlayer.manager.boundsWidth,module.qjPlayer.manager.boundsHeight);
		}
		
		/**
		 * 窗口状态指改变
		 * @param event
		 * 
		 */		
		protected function onOpenChange(event:Event):void
		{
			if(guestBookView.guestBookData.windowData.open){
				guestBookView.shadowView.drawBg(module.qjPlayer.manager.boundsWidth,module.qjPlayer.manager.boundsHeight);
				guestBookView.shadowView.alpha = 0;
				var tweenObj:Object = new Object();
				tweenObj["time"] = 1;
				tweenObj["alpha"] = 1;
				Tweener.addTween(guestBookView.shadowView, tweenObj);
			}else{
				guestBookView.shadowView.alpha = 1;
				tweenObj = new Object();
				tweenObj["time"] = 1;
				tweenObj["alpha"] = 0;
				tweenObj["onComplete"] = function():void{guestBookView.shadowView.clear();};
				Tweener.addTween(guestBookView.shadowView, tweenObj);
			}
			
		}
		
		/**
		 * 显示窗口 
		 * @param event
		 * 
		 */		
		protected function showWindow(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			guestBookView.guestBookData.windowData.open = true;
		}
	}
}
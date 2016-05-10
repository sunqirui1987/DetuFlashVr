package com.panozona.modules.openMovie.controller
{
	import com.panozona.modules.openMovie.controller.WindowController;
	import com.panozona.modules.openMovie.events.WindowEvent;
	import com.panozona.modules.openMovie.view.OpenMovieView;
	import com.panozona.player.module.Module;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.ApplicationDomain;
	
	import caurina.transitions.Tweener;

	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-3-3 上午9:45:54
	 * 功能描述:留言板模块
	 */
	public class OpenMovieController
	{
		private var openMovieView:OpenMovieView;
		
		private var windowController:WindowController;
		
		private var module:Module
		
		public function OpenMovieController(openMovieView:OpenMovieView, module:Module)
		{
			this.openMovieView = openMovieView;
			this.module = module;
			
			windowController = new WindowController(openMovieView,module);
			
			if(openMovieView.openMovieData.setting.needBackShadow)
				openMovieView.windowView.windowData.addEventListener(WindowEvent.CHANGED_OPEN, onOpenChange, false, 0, true);
			
			var ViewEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panosalado.events.ViewEvent") as Class;
			module.qjPlayer.manager.addEventListener(ViewEventClass.BOUNDS_CHANGED, handleResize, false, 0, true);
			handleResize();
		}
		
		private function handleResize(event:Event = null):void {
			if(openMovieView.windowView.windowData.open)
				openMovieView.shadowView.drawBg(module.qjPlayer.manager.boundsWidth,module.qjPlayer.manager.boundsHeight);
		}
		
		/**
		 * 窗口状态指改变
		 * @param event
		 * 
		 */		
		protected function onOpenChange(event:Event):void
		{
			if(openMovieView.windowView.windowData.open){
				openMovieView.shadowView.drawBg(module.qjPlayer.manager.boundsWidth,module.qjPlayer.manager.boundsHeight);
				openMovieView.shadowView.alpha = 0;
				var tweenObj:Object = new Object();
				tweenObj["time"] = 1;
				tweenObj["alpha"] = 1;
				Tweener.addTween(openMovieView.shadowView, tweenObj);
			}else{
				openMovieView.shadowView.alpha = 1;
				tweenObj = new Object();
				tweenObj["time"] = 1;
				tweenObj["alpha"] = 0;
				tweenObj["onComplete"] = function():void{openMovieView.shadowView.clear();};
				Tweener.addTween(openMovieView.shadowView, tweenObj);
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
			openMovieView.openMovieData.windowData.open = true;
		}
	}
}
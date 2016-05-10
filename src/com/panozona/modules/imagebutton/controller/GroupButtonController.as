package com.panozona.modules.imagebutton.controller
{
	import com.panozona.modules.imagebutton.events.WindowEvent;
	import com.panozona.modules.imagebutton.model.WindowData;
	import com.panozona.modules.imagebutton.model.structure.Button;
	import com.panozona.modules.imagebutton.view.GroupButtonView;
	import com.panozona.modules.imagebutton.view.WindowView;
	import com.panozona.player.module.Module;
	import com.panozona.player.module.data.property.Align;
	import com.panozona.player.module.data.property.Transition;
	
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	
	import caurina.transitions.Tweener;

	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-4-15 下午7:34:57
	 * 功能描述:
	 */
	public class GroupButtonController
	{
		private var groupButtonView:GroupButtonView;
		
		private var module:Module;
		
		private var bgController:BgController;
		
		private var buttonControllers:Vector.<WindowController>;
		
		public function GroupButtonController(groupButtonView:GroupButtonView,module:Module)
		{
			this.groupButtonView = groupButtonView;
			this.module = module;
			
			bgController = new BgController(groupButtonView.bgView,module);
			
			groupButtonView.groupButtonData.addEventListener(WindowEvent.CHANGED_OPEN, onOpenChange, false, 0, true);
			groupButtonView.groupButtonData.addEventListener(WindowEvent.CHANGED_SIZE, handleResize, false, 0, true);
			
			var ViewEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panosalado.events.ViewEvent") as Class;
			module.qjPlayer.manager.addEventListener(ViewEventClass.BOUNDS_CHANGED, handleResize, false, 0, true);
			handleResize();
			
			var panoramaEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.events.PanoramaEvent") as Class;
			module.qjPlayer.manager.addEventListener(panoramaEventClass.PANORAMA_STARTED_LOADING, onPanoramaStartedLoading, false, 0, true);
			
			module.qjPlayer.manager.addEventListener(panoramaEventClass.PANORAMA_STARTED_LOADING, onPanoramaStartedLoadingByPanoid, false, 0, true);
			
			buttonControllers = new Vector.<WindowController>();
			var arr:Array = groupButtonView.groupButtonData.groupButton.getChildrenOfGivenClass(Button);
			for (var i:int = arr.length - 1; i >= 0; i--){
				var windowView:WindowView = new WindowView(new WindowData(arr[i],groupButtonView.imageButtonData.styles));
				groupButtonView.addChild(windowView);
				var windowController:WindowController = new WindowController(windowView, module,groupButtonView);
				buttonControllers.push(windowController);
			}
		
		}
		
		private function onPanoramaStartedLoadingByPanoid(loadPanoramaEvent:Object):void {
			
			//fix 
			//如果属于paonid
			if(groupButtonView.groupButtonData.groupButton.panoid != "")
			{
				if(groupButtonView.groupButtonData.groupButton.panoid ==  module.qjPlayer.manager.currentPanoramaData.id)
				{
					groupButtonView.groupButtonData.open = true;
					groupButtonView.visible = true;
				}
				else
				{
					groupButtonView.groupButtonData.open = false;
					groupButtonView.visible = false;
				}
				
				module.printWarning("windowView.buttonView.windowData.button.panoid"+groupButtonView.groupButtonData.groupButton.panoid +":"+ module.qjPlayer.manager.currentPanoramaData.id);
				
			}
		}
		
		private function onPanoramaStartedLoading(loadPanoramaEvent:Object):void {
			var panoramaEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.events.PanoramaEvent") as Class;
			module.qjPlayer.manager.removeEventListener(panoramaEventClass.PANORAMA_STARTED_LOADING, onPanoramaStartedLoading);
			
			
			if (groupButtonView.groupButtonData.open){
				module.qjPlayer.manager.runAction(groupButtonView.groupButtonData.groupButton.window.onOpen);
			}else {
				module.qjPlayer.manager.runAction(groupButtonView.groupButtonData.groupButton.window.onClose);
			}
		}
		
		protected function onOpenChange(event:Event):void
		{
			if (groupButtonView.groupButtonData.open) {
				module.qjPlayer.manager.runAction(groupButtonView.groupButtonData.groupButton.window.onOpen);
				openWindow();
			}else {
				module.qjPlayer.manager.runAction(groupButtonView.groupButtonData.groupButton.window.onClose);
				closeWindow();
			}
		}	
		
		private function openWindow():void {
			groupButtonView.visible = true;
			groupButtonView.mouseEnabled = true;
			groupButtonView.mouseChildren = true;
			var tweenObj:Object = new Object();
			tweenObj["time"] = groupButtonView.groupButtonData.groupButton.window.openTween.time;
			tweenObj["transition"] = groupButtonView.groupButtonData.groupButton.window.openTween.transition;
			if (groupButtonView.groupButtonData.groupButton.window.transition.type == Transition.FADE) {
				tweenObj["alpha"] = groupButtonView.groupButtonData.groupButton.window.alpha;
			}else{
				tweenObj["x"] = getWindowOpenX();
				tweenObj["y"] = getWindowOpenY();
			}
			Tweener.addTween(groupButtonView, tweenObj);
		}
		
		private function closeWindow():void {
			var tweenObj:Object = new Object();
			tweenObj["time"] = groupButtonView.groupButtonData.groupButton.window.closeTween.time;
			tweenObj["transition"] = groupButtonView.groupButtonData.groupButton.window.closeTween.transition;
			tweenObj["onComplete"] = closeWindowOnComplete;
			if (groupButtonView.groupButtonData.groupButton.window.transition.type == Transition.FADE) {
				tweenObj["alpha"] = 0;
			}else{
				tweenObj["x"] = getWindowCloseX();
				tweenObj["y"] = getWindowCloseY();
			}
			groupButtonView.mouseEnabled = false;
			groupButtonView.mouseChildren = false;
			Tweener.addTween(groupButtonView, tweenObj);
		}
		
		private function closeWindowOnComplete():void {
			groupButtonView.visible = false;
		}
		
		private function placeWindow(e:Event = null):void {
			
			if (groupButtonView.groupButtonData.open) {
				Tweener.addTween(groupButtonView, {x:getWindowOpenX(), y:getWindowOpenY()});  // no time parameter
				groupButtonView.alpha = groupButtonView.groupButtonData.groupButton.window.alpha;
				groupButtonView.visible = true;
			}else {
				Tweener.addTween(groupButtonView, {x:getWindowCloseX(), y:getWindowCloseY()}); // no time parameter
				if(groupButtonView.groupButtonData.groupButton.window.transition.type == Transition.FADE){
					groupButtonView.alpha = 0;
				}
				groupButtonView.visible = false;
			}
		}
		
		private function getWindowOpenX():Number {
			var mh:Number = groupButtonView.groupButtonData.groupButton.window.move.horizontal;
			if(groupButtonView.groupButtonData.groupButton.window.isPercent == true)
			{
				mh = module.qjPlayer.manager.boundsWidth  *  groupButtonView.groupButtonData.groupButton.window.move.horizontal / 100;
				mh = mh - groupButtonView.groupButtonData.groupButton.bg.size.width / 2;
			}
			var result:Number = 0;
			switch(groupButtonView.groupButtonData.groupButton.window.align.horizontal) {
				case Align.RIGHT:
					result += module.qjPlayer.manager.boundsWidth 
					- groupButtonView.groupButtonData.groupButton.bg.size.width
					+ mh;
					break;
				case Align.LEFT:
					result += mh;
					break;
				default: // CENTER
					result += (module.qjPlayer.manager.boundsWidth 
						- groupButtonView.groupButtonData.groupButton.bg.size.width) * 0.5 
					+ mh;
			}
			return result;
		}
		
		private function getWindowOpenY():Number{
			var mv:Number = groupButtonView.groupButtonData.groupButton.window.move.vertical;
			if(groupButtonView.groupButtonData.groupButton.window.isPercent == true)
			{
				mv = module.qjPlayer.manager.boundsHeight  *  groupButtonView.groupButtonData.groupButton.window.move.vertical / 100;
				mv = mv - groupButtonView.groupButtonData.groupButton.bg.size.height / 2;
			}
			var result:Number = 0;
			switch(groupButtonView.groupButtonData.groupButton.window.align.vertical) {
				case Align.TOP:
					result += mv;
					break;
				case Align.BOTTOM:
					result += module.qjPlayer.manager.boundsHeight 
					- groupButtonView.groupButtonData.groupButton.bg.size.height
					+ mv;
					break;
				default: // MIDDLE
					result += (module.qjPlayer.manager.boundsHeight 
						- groupButtonView.groupButtonData.groupButton.bg.size.height) * 0.5
					+ mv;
			}
			return result;
		}
		
		private function getWindowCloseX():Number {
			var result:Number = 0;
			switch(groupButtonView.groupButtonData.groupButton.window.transition.type){
				case Transition.SLIDE_RIGHT:
					result = module.qjPlayer.manager.boundsWidth;
					break;
				case Transition.SLIDE_LEFT:
					result = -groupButtonView.groupButtonData.groupButton.bg.size.width;
					break;
				default: //SLIDE_UP, SLIDE_DOWN
					result = getWindowOpenX();
			}
			return result;
		}
		
		private function getWindowCloseY():Number{
			var result:Number = 0;
			switch(groupButtonView.groupButtonData.groupButton.window.transition.type){
				case Transition.SLIDE_UP:
					result = -groupButtonView.groupButtonData.groupButton.bg.size.height;
					break;
				case Transition.SLIDE_DOWN:
					result = module.qjPlayer.manager.boundsHeight;
					break;
				default: //SLIDE_LEFT, SLIDE_RIGHT
					result = getWindowOpenY();
			}
			return result;
		}
		
		private function handleResize(e:Event=null):void
		{
			placeWindow();		
		}
	}
}
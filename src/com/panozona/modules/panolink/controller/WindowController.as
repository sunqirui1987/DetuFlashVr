/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.panolink.controller {
	
	import caurina.transitions.Tweener;
	import com.panozona.modules.panolink.events.WindowEvent;
	import com.panozona.modules.panolink.view.WindowView;
	import com.panozona.player.module.data.property.Align;
	import com.panozona.player.module.data.property.Transition;
	import com.panozona.player.module.Module;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.ApplicationDomain;
	
	public class WindowController {
		
		private var _module:Module;
		private var _windowView:WindowView;
		
		private var _linkController:LinkController;
		private var _closeController:CloseController;
		
		public function WindowController(windowView:WindowView, module:Module) {
			
			_module = module;
			_windowView = windowView;
			
			_windowView.windowData.addEventListener(WindowEvent.CHANGED_OPEN, onOpenChange, false, 0, true);
			_windowView.windowData.addEventListener(WindowEvent.CHANGED_SIZE, handleResize, false, 0, true);
			
			_linkController = new LinkController(windowView.linkView, _module);
			_closeController = new CloseController(windowView.closeView, _module);
			
			var ViewEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panosalado.events.ViewEvent") as Class;
			_module.qjPlayer.manager.addEventListener(ViewEventClass.BOUNDS_CHANGED, handleResize, false, 0, true);
			handleResize();
			
			var panoramaEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.events.PanoramaEvent") as Class;
			_module.qjPlayer.manager.addEventListener(panoramaEventClass.PANORAMA_STARTED_LOADING, onPanoramaStartedLoading, false, 0, true);
		}
		
		private function onPanoramaStartedLoading(loadPanoramaEvent:Object):void {
			var panoramaEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.events.PanoramaEvent") as Class;
			_module.qjPlayer.manager.removeEventListener(panoramaEventClass.PANORAMA_STARTED_LOADING, onPanoramaStartedLoading);
			if (_windowView.windowData.open){
				_module.qjPlayer.manager.runAction(_windowView.panoLinkData.windowData.window.onOpen);
			}else {
				_module.qjPlayer.manager.runAction(_windowView.panoLinkData.windowData.window.onClose);
			}
			_module.qjPlayer.manager.addEventListener(panoramaEventClass.PANORAMA_STARTED_LOADING, handlePlayerClick, false, 0, true);
		}
		
		private function handleResize(event:Event = null):void {
			placeWindow();
		}
		
		private function handlePlayerClick(event:Event = null):void {
			_windowView.panoLinkData.windowData.open = false;
		}
		
		private function onOpenChange(e:Event):void {
			if (_windowView.windowData.open) {
				_module.qjPlayer.managerData.controlData.autorotationCameraData.isAutorotating = false;
				_module.qjPlayer.manager.runAction(_windowView.panoLinkData.windowData.window.onOpen);
				openWindow();
			}else {
				_module.qjPlayer.manager.runAction(_windowView.panoLinkData.windowData.window.onClose);
				closeWindow();
			}
		}
		
		private function onEnterFrame(e:Event):void {
			if (Math.abs(_module.qjPlayer.manager.pan - initPan) > 1 ||
				Math.abs(_module.qjPlayer.manager.tilt - initTilt) > 1 ||
				Math.abs(_module.qjPlayer.manager.fieldOfView - initFov) > 1) {
					_windowView.panoLinkData.windowData.open = false;
					_module.stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
		}
		
		private function openWindow():void {
			_windowView.visible = true;
			_windowView.mouseEnabled = true;
			_windowView.mouseChildren = true;
			var tweenObj:Object = new Object();
			tweenObj["time"] = _windowView.panoLinkData.windowData.window.openTween.time;
			tweenObj["transition"] = _windowView.panoLinkData.windowData.window.openTween.transition;
			tweenObj["onComplete"] = openWindowOnComplete;
			if (_windowView.panoLinkData.windowData.window.transition.type == Transition.FADE){
				tweenObj["alpha"] = 1;
			}else{
				tweenObj["x"] = getWindowOpenX();
				tweenObj["y"] = getWindowOpenY();
			}
			Tweener.addTween(_windowView, tweenObj);
		}
		
		private var initPan:Number;
		private var initTilt:Number;
		private var initFov:Number;
		private function openWindowOnComplete():void {
			_module.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
			initPan = _module.qjPlayer.manager.pan;
			initTilt = _module.qjPlayer.manager.tilt;
			initFov = _module.qjPlayer.manager.fieldOfView;
		}
		
		private function closeWindow():void {
			var tweenObj:Object = new Object();
			tweenObj["time"] = _windowView.panoLinkData.windowData.window.closeTween.time;
			tweenObj["transition"] = _windowView.panoLinkData.windowData.window.closeTween.transition;
			tweenObj["onComplete"] = closeWindowOnComplete;
			if (_windowView.panoLinkData.windowData.window.transition.type == Transition.FADE) {
				tweenObj["alpha"] = 0;
			}else{
				tweenObj["x"] = getWindowCloseX();
				tweenObj["y"] = getWindowCloseY();
			}
			_windowView.mouseEnabled = false;
			_windowView.mouseChildren = false;
			Tweener.addTween(_windowView, tweenObj);
		}
		
		private function closeWindowOnComplete():void {
			_windowView.visible = false;
			_module.stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function placeWindow(e:Event = null):void {
			if (_windowView.windowData.open) {
				Tweener.addTween(_windowView, {x:getWindowOpenX(), y:getWindowOpenY()});  // no time parameter
				_windowView.alpha = 1;
				_windowView.visible = true;
			}else {
				Tweener.addTween(_windowView, {x:getWindowCloseX(), y:getWindowCloseY()}); // no time parameter
				if(_windowView.panoLinkData.windowData.window.transition.type == Transition.FADE){
					_windowView.alpha = 0;
				}
				_windowView.visible = false;
			}
		}
		
		private function getWindowOpenX():Number {
			var result:Number = 0;
			switch(_windowView.panoLinkData.windowData.window.align.horizontal) {
				case Align.RIGHT:
					result += _module.qjPlayer.manager.boundsWidth
						- _windowView.panoLinkData.windowData.size.width
						+ _windowView.panoLinkData.windowData.window.move.horizontal;
				break;
				case Align.LEFT:
					result += _windowView.panoLinkData.windowData.window.move.horizontal;
				break;
				default: // CENTER
					result += (_module.qjPlayer.manager.boundsWidth
						- _windowView.panoLinkData.windowData.size.width) * 0.5
						+ _windowView.panoLinkData.windowData.window.move.horizontal;
			}
			return result;
		}
		
		private function getWindowOpenY():Number{
			var result:Number = 0;
			switch(_windowView.panoLinkData.windowData.window.align.vertical) {
				case Align.TOP:
					result += _windowView.panoLinkData.windowData.window.move.vertical;
				break;
				case Align.BOTTOM:
					result += _module.qjPlayer.manager.boundsHeight
						- _windowView.panoLinkData.windowData.size.height
						+ _windowView.panoLinkData.windowData.window.move.vertical;
				break;
				default: // MIDDLE
					result += (_module.qjPlayer.manager.boundsHeight 
						- _windowView.panoLinkData.windowData.size.height) * 0.5
						+ _windowView.panoLinkData.windowData.window.move.vertical;
			}
			return result;
		}
		
		private function getWindowCloseX():Number {
			var result:Number = 0;
			switch(_windowView.panoLinkData.windowData.window.transition.type){
				case Transition.SLIDE_RIGHT:
					result = _module.qjPlayer.manager.boundsWidth;
				break;
				case Transition.SLIDE_LEFT:
					result = -_windowView.panoLinkData.windowData.size.width;
				break;
				default: //SLIDE_UP, SLIDE_DOWN
					result = getWindowOpenX();
			}
			return result;
		}
		
		private function getWindowCloseY():Number{
			var result:Number = 0;
			switch(_windowView.panoLinkData.windowData.window.transition.type){
				case Transition.SLIDE_UP:
					result = -_windowView.panoLinkData.windowData.size.height;
				break;
				case Transition.SLIDE_DOWN:
					result = _module.qjPlayer.manager.boundsHeight;
				break;
				default: //SLIDE_LEFT, SLIDE_RIGHT
					result = getWindowOpenY();
			}
			return result;
		}
	}
}
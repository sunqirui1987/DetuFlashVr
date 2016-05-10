/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.imagebutton.controller{
	
	import com.panozona.modules.imagebutton.events.WindowEvent;
	import com.panozona.modules.imagebutton.view.GroupButtonView;
	import com.panozona.modules.imagebutton.view.WindowView;
	import com.panozona.player.module.Module;
	import com.panozona.player.module.data.property.Align;
	import com.panozona.player.module.data.property.Transition;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.system.ApplicationDomain;
	import flash.utils.Timer;
	
	import caurina.transitions.Tweener;
	
	public class WindowController{
		
		private var buttonController:ButtonController;
		
		private var _windowView:WindowView;
		private var _module:Module;
		
		private var _timer:Timer;
		
		private var groupButtonView:GroupButtonView;
		
		public function WindowController(windowView:WindowView, module:Module,groupButtonView:GroupButtonView=null) {
			
			_module = module;
			_windowView = windowView;
			this.groupButtonView = groupButtonView;
			
			_windowView.windowData.addEventListener(WindowEvent.CHANGED_OPEN, onOpenChange, false, 0, true);
			_windowView.windowData.addEventListener(WindowEvent.CHANGED_SIZE, handleResize, false, 0, true);
			
			buttonController = new ButtonController(windowView.buttonView, _module);
			
			var ViewEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panosalado.events.ViewEvent") as Class;
			_module.qjPlayer.manager.addEventListener(ViewEventClass.BOUNDS_CHANGED, handleResize, false, 0, true);
			handleResize();
			
			var panoramaEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.events.PanoramaEvent") as Class;
			_module.qjPlayer.manager.addEventListener(panoramaEventClass.PANORAMA_STARTED_LOADING, onPanoramaStartedLoading, false, 0, true);
			
			_module.qjPlayer.manager.addEventListener(panoramaEventClass.PANORAMA_STARTED_LOADING, onPanoramaStartedLoadingByPanoid, false, 0, true);
			

		}
		

		
		private function onPanoramaStartedLoadingByPanoid(loadPanoramaEvent:Object):void {
	
			//fix 
			var panoidstr:String = _windowView.buttonView.windowData.button.panoid;
			if( panoidstr != "")
			{
				panoidstr = panoidstr.replace(" ","");// 去掉空格
				var isfind:Boolean = false;
				//存在数组panoidstr列表
				var panoid_arr:Array = panoidstr.split(",");
				for(var i:Number = 0; i<panoid_arr.length;i++)
				{
					if(panoid_arr[i] ==  _module.qjPlayer.manager.currentPanoramaData.id)
					{
						isfind = true;
						break;
					}
				}
				
				if(isfind == true)
				{
					_windowView.buttonView.windowData.open = true;
					_windowView.visible = true;
				}
				else
				{
					_windowView.buttonView.windowData.open = false;
					_windowView.visible = false;
				}
				

			}
		}
		
		private function onPanoramaStartedLoading(loadPanoramaEvent:Object):void {
			var panoramaEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.events.PanoramaEvent") as Class;
			_module.qjPlayer.manager.removeEventListener(panoramaEventClass.PANORAMA_STARTED_LOADING, onPanoramaStartedLoading);
			
			
			if (_windowView.windowData.open){
				_module.qjPlayer.manager.runAction(_windowView.windowData.window.onOpen);
			}else {
				_module.qjPlayer.manager.runAction(_windowView.windowData.window.onClose);
			}
		}
		
		private function handleResize(event:Event = null):void {
			placeWindow();
		}
		
		private function onOpenChange(e:Event):void {
			if (_windowView.windowData.open) {
				_module.qjPlayer.manager.runAction(_windowView.windowData.window.onOpen);
				openWindow();
			}else {
				_module.qjPlayer.manager.runAction(_windowView.windowData.window.onClose);
				closeWindow();
			}
		
		}
		
		private function openWindow():void {
			_windowView.visible = true;
			_windowView.mouseEnabled = true;
			_windowView.mouseChildren = true;
			var tweenObj:Object = new Object();
			tweenObj["time"] = _windowView.windowData.window.openTween.time;
			tweenObj["transition"] = _windowView.windowData.window.openTween.transition;
			if (_windowView.windowData.window.transition.type == Transition.FADE) {
				tweenObj["alpha"] = _windowView.windowData.window.alpha;
			}else{
				tweenObj["x"] = getWindowOpenX();
				tweenObj["y"] = getWindowOpenY();
			}
			Tweener.addTween(_windowView, tweenObj);
		}
		
		private function closeWindow():void {
			var tweenObj:Object = new Object();
			tweenObj["time"] = _windowView.windowData.window.closeTween.time;
			tweenObj["transition"] = _windowView.windowData.window.closeTween.transition;
			tweenObj["onComplete"] = closeWindowOnComplete;
			if (_windowView.windowData.window.transition.type == Transition.FADE) {
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
		}
		
		private function placeWindow(e:Event = null):void {
			
			if (_windowView.windowData.open) {
				Tweener.addTween(_windowView, {x:getWindowOpenX(), y:getWindowOpenY()});  // no time parameter
				_windowView.alpha = _windowView.windowData.window.alpha;
				_windowView.visible = true;
			}else {
				Tweener.addTween(_windowView, {x:getWindowCloseX(), y:getWindowCloseY()}); // no time parameter
				if(_windowView.windowData.window.transition.type == Transition.FADE){
					_windowView.alpha = 0;
				}
				_windowView.visible = false;
			}
		}
		
		private function getWindowOpenX():Number {
			var mh:Number = _windowView.windowData.window.move.horizontal;
			if(_windowView.windowData.window.isPercent == true)
			{
				mh = _module.qjPlayer.manager.boundsWidth  *  _windowView.windowData.window.move.horizontal / 100;
				mh = mh - _windowView.windowData.size.width / 2;
			}
			var result:Number = 0;
			switch(_windowView.windowData.window.align.horizontal) {
				case Align.RIGHT:
					if(groupButtonView){
						result += groupButtonView.groupButtonData.groupButton.bg.size.width
							- _windowView.windowData.size.width 
							+ mh;
					}else{
						result += _module.qjPlayer.manager.boundsWidth 
							- _windowView.windowData.size.width 
							+ mh;
					}
				break;
				case Align.LEFT:
					result += mh;
				break;
				default: // CENTER
					if(groupButtonView){
						result += (groupButtonView.groupButtonData.groupButton.bg.size.width
							- _windowView.windowData.size.width) * 0.5
							+ mh;
					}else{
						result += (_module.qjPlayer.manager.boundsWidth 
							- _windowView.windowData.size.width) * 0.5 
							+ mh;
					}
					
			}
			return result;
		}
		
		private function getWindowOpenY():Number{
			var mv:Number = _windowView.windowData.window.move.vertical;
			if(_windowView.windowData.window.isPercent == true)
			{
				mv = _module.qjPlayer.manager.boundsHeight  *  _windowView.windowData.window.move.vertical / 100;
				mv = mv - _windowView.windowData.size.height / 2;
			}
			var result:Number = 0;
			switch(_windowView.windowData.window.align.vertical) {
				case Align.TOP:
					result += mv;
				break;
				case Align.BOTTOM:
					if(groupButtonView){
						result += groupButtonView.groupButtonData.groupButton.bg.size.height
							- _windowView.windowData.size.height
							+ mv;
					}else{
						result += _module.qjPlayer.manager.boundsHeight 
							- _windowView.windowData.size.height
							+ mv;
					}
				break;
				default: // MIDDLE
					if(groupButtonView){
						result += (groupButtonView.groupButtonData.groupButton.bg.size.height
							- _windowView.windowData.size.height)*0.5
							+ mv;
					}else{
						result += (_module.qjPlayer.manager.boundsHeight 
							- _windowView.windowData.size.height) * 0.5
							+ mv;
					}
					
			}
			return result;
		}
		
		private function getWindowCloseX():Number {
			var result:Number = 0;
			switch(_windowView.windowData.window.transition.type){
				case Transition.SLIDE_RIGHT:
					result = _module.qjPlayer.manager.boundsWidth;
				break;
				case Transition.SLIDE_LEFT:
					result = -_windowView.windowData.size.width;
				break;
				default: //SLIDE_UP, SLIDE_DOWN
					result = getWindowOpenX();
			}
			return result;
		}
		
		private function getWindowCloseY():Number{
			var result:Number = 0;
			switch(_windowView.windowData.window.transition.type){
				case Transition.SLIDE_UP:
					result = -_windowView.windowData.size.height;
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
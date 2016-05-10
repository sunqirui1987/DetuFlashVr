/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.buttonbar.controller{
	
	import com.panozona.modules.buttonbar.events.ButtonBarEvent;
	import com.panozona.modules.buttonbar.model.ButtonData;
	import com.panozona.modules.buttonbar.model.structure.Button;
	import com.panozona.modules.buttonbar.model.structure.ExtraButton;
	import com.panozona.modules.buttonbar.view.BarView;
	import com.panozona.modules.buttonbar.view.ButtonView;
	import com.panozona.player.module.Module;
	import com.panozona.player.module.data.property.Size;
	
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	public class BarController {
		
		private var _barView:BarView;
		private var _module:Module;
		
		private var cameraKeyBindingsClass:Class;
		private var autorotationEventClass:Class;
		private var cameraEventClass:Class;
		
		private var buttonsBitmapData:BitmapData;
		private var buttonSize:Size;
		
		private var buttonsController:Vector.<ButtonController>;
		
		public function BarController(barView:BarView, module:Module){
			_barView = barView;
			_module = module;
			
			buttonsController = new Vector.<ButtonController>();
			buttonSize = new Size(30,30);
			buildButtonsBar();
			
			autorotationEventClass = ApplicationDomain.currentDomain.getDefinition("com.panosalado.events.AutorotationEvent") as Class;
			cameraKeyBindingsClass = ApplicationDomain.currentDomain.getDefinition("com.panosalado.model.CameraKeyBindings") as Class;
			cameraEventClass = ApplicationDomain.currentDomain.getDefinition("com.panosalado.events.CameraEvent") as Class;
			
			_module.qjPlayer.managerData.controlData.arcBallCameraData.addEventListener(cameraEventClass.ENABLED_CHANGE, onDragEnabledChange, false, 0, true);
			_module.qjPlayer.managerData.controlData.autorotationCameraData.addEventListener(autorotationEventClass.AUTOROTATION_CHANGE, onIsAutorotatingChange, false, 0, true);
			
			_module.qjPlayer.addEventListener(Event.ENTER_FRAME, onEnterFrameHandler, false, 0, true);
			_module.stage.addEventListener(Event.FULLSCREEN, onFullScreenChange, false, 0, true);
			
			if (_barView.buttonBarData.buttons.listenKeys) {
				_module.qjPlayer.stage.addEventListener( KeyboardEvent.KEY_DOWN, keyDownEvent, false, 0, true);
				_module.qjPlayer.stage.addEventListener( KeyboardEvent.KEY_UP, keyUpEvent, false, 0, true);
			}
			
			
			var lc:LoaderContext = new LoaderContext();
			lc.checkPolicyFile = true;
			
			var buttonsLoader:Loader = new Loader();
			buttonsLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, buttonsImageLost, false, 0, true);
			buttonsLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, buttonsImageLoaded, false, 0, true);
			buttonsLoader.load(new URLRequest(_barView.buttonBarData.buttons.path),lc);
		}
		
		public function setButtonActive(name:String, active:Boolean):void {

			var buttonView:ButtonView;
			for (var i:int = 0; i < _barView.buttonsContainer.numChildren; i++) {
				buttonView = _barView.buttonsContainer.getChildAt(i) as ButtonView;
				if (buttonView && buttonView.buttonData.button.name == name) {
					buttonView.buttonData.isActive = active;
					return;
				}
			}
		}
		
		private function buttonsImageLost(e:IOErrorEvent):void {
			(e.target as LoaderInfo).removeEventListener(IOErrorEvent.IO_ERROR, buttonsImageLost);
			(e.target as LoaderInfo).removeEventListener(Event.COMPLETE, buttonsImageLoaded);
			_module.printError(e.text);
		}
		
		private function buttonsImageLoaded(e:Event):void {
			(e.target as LoaderInfo).removeEventListener(IOErrorEvent.IO_ERROR, buttonsImageLost);
			(e.target as LoaderInfo).removeEventListener(Event.COMPLETE, buttonsImageLoaded);
			buttonsBitmapData = new BitmapData((e.target as LoaderInfo).width, (e.target as LoaderInfo).height, true, 0);
			buttonsBitmapData.draw((e.target as LoaderInfo).content);
			buttonSize.width = Math.ceil((buttonsBitmapData.width - 8) / 9);
			buttonSize.height = Math.ceil((buttonsBitmapData.height - 3) / 4);
			updateButtonsBar();
			onIsAutorotatingChange();
			onDragEnabledChange();
			
			_barView.buttonBarData.windowData.size = new Size(_barView.buttonsContainer.width, _barView.buttonsContainer.height);
		}
		
		private function buildButtonsBar():void {
			var buttonView:ButtonView;
			for each(var button:Button in _barView.buttonBarData.buttons.getAllChildren()) {
				buttonView = new ButtonView(new ButtonData(button), _barView.buttonBarData);
				if (button.name == "left") {
					buttonView.buttonData.onPress = leftPress;
					buttonView.buttonData.onRelease = leftRelease;
				}else if (button.name == "right") {
					buttonView.buttonData.onPress = rightPress;
					buttonView.buttonData.onRelease = rightRelease;
				}else if (button.name == "up") {
					buttonView.buttonData.onPress = upPress;
					buttonView.buttonData.onRelease = upRelease;
				}else if (button.name == "down") {
					buttonView.buttonData.onPress = downPress;
					buttonView.buttonData.onRelease = downRelease;
				}else if (button.name == "in") {
					buttonView.buttonData.onPress = inPress;
					buttonView.buttonData.onRelease = inRelease;
				}else if (button.name == "out") {
					buttonView.buttonData.onPress = outPress;
					buttonView.buttonData.onRelease = outRelease;
				}else if (button.name == "drag") {
					buttonView.buttonData.onPress = dragToggle;
				}else if (button.name == "autorotation") {
					buttonView.buttonData.onPress = autorotateToggle;
				}else if (button.name == "fullscreen") {
					buttonView.buttonData.onRelease = fullscreenToggle;
				}else if(button.name == "a" || button.name == "b" || button.name == "c" || button.name == "d" || button.name == "e" ||
						 button.name == "f" || button.name == "g" || button.name == "h" || button.name == "i") {
					if (button is ExtraButton) {
						buttonView.buttonData.onPress = extraButtonFunction(button as ExtraButton);
					}else {
						_module.printError("Invalid extraButton name: " + button.name);
						continue;
					}
				}else {
					_module.printError("Invalid button name: " + button.name);
					continue;
				}
				
				buttonsController.push(new ButtonController(buttonView, _module));
				_barView.buttonsContainer.addChild(buttonView);
			}
		}
		
		private function extraButtonFunction(extraButton:ExtraButton):Function {
			return function():void {
				_module.qjPlayer.manager.runAction(extraButton.action);
			}
		}
		
		private function updateButtonsBar():void {
			var buttonView:ButtonView;
			var lastX:Number = 0;
			for ( var i:int = 0; i < _barView.buttonsContainer.numChildren; i++) {
				buttonView = _barView.buttonsContainer.getChildAt(i) as ButtonView;
				if (buttonView.buttonData.button.name == "left") {
					buttonView.bitmapDataPlain = getButtonBitmap(0);
					buttonView.bitmapDataActive = getButtonBitmap(9);
				}else if (buttonView.buttonData.button.name == "right") {
					buttonView.bitmapDataPlain = getButtonBitmap(1);
					buttonView.bitmapDataActive = getButtonBitmap(10);
				}else if (buttonView.buttonData.button.name == "up") {
					buttonView.bitmapDataPlain = getButtonBitmap(2);
					buttonView.bitmapDataActive = getButtonBitmap(11);
				}else if (buttonView.buttonData.button.name == "down") {
					buttonView.bitmapDataPlain = getButtonBitmap(3);
					buttonView.bitmapDataActive = getButtonBitmap(12);
				}else if (buttonView.buttonData.button.name == "out") {
					buttonView.bitmapDataPlain = getButtonBitmap(4);
					buttonView.bitmapDataActive = getButtonBitmap(13);
				}else if (buttonView.buttonData.button.name == "in") {
					buttonView.bitmapDataPlain = getButtonBitmap(5);
					buttonView.bitmapDataActive = getButtonBitmap(14);
				}else if (buttonView.buttonData.button.name == "drag") {
					buttonView.bitmapDataPlain = getButtonBitmap(6);
					buttonView.bitmapDataActive = getButtonBitmap(15);
				}else if (buttonView.buttonData.button.name == "autorotation") {
					buttonView.bitmapDataPlain = getButtonBitmap(7);
					buttonView.bitmapDataActive = getButtonBitmap(16);
				}else if (buttonView.buttonData.button.name == "fullscreen") {
					buttonView.bitmapDataPlain = getButtonBitmap(8);
					buttonView.bitmapDataActive = getButtonBitmap(17);
					
					//  第二排开始用数字表示
				}else if (buttonView.buttonData.button.name == "a") {
					buttonView.bitmapDataPlain = getButtonBitmap(18);
					buttonView.bitmapDataActive = getButtonBitmap(27);
				}else if (buttonView.buttonData.button.name == "b") {
					buttonView.bitmapDataPlain = getButtonBitmap(19);
					buttonView.bitmapDataActive = getButtonBitmap(28);
				}else if (buttonView.buttonData.button.name == "c") {
					buttonView.bitmapDataPlain = getButtonBitmap(20);
					buttonView.bitmapDataActive = getButtonBitmap(29);
				}else if (buttonView.buttonData.button.name == "d") {
					buttonView.bitmapDataPlain = getButtonBitmap(21);
					buttonView.bitmapDataActive = getButtonBitmap(30);
				}else if (buttonView.buttonData.button.name == "e") {
					buttonView.bitmapDataPlain = getButtonBitmap(22);
					buttonView.bitmapDataActive = getButtonBitmap(31);
				}else if (buttonView.buttonData.button.name == "f") {
					buttonView.bitmapDataPlain = getButtonBitmap(23);
					buttonView.bitmapDataActive = getButtonBitmap(32);
				}else if (buttonView.buttonData.button.name == "g") {
					buttonView.bitmapDataPlain = getButtonBitmap(24);
					buttonView.bitmapDataActive = getButtonBitmap(33);
				}else if (buttonView.buttonData.button.name == "h") {
					buttonView.bitmapDataPlain = getButtonBitmap(25);
					buttonView.bitmapDataActive = getButtonBitmap(34);
				}else if (buttonView.buttonData.button.name == "i") {
					buttonView.bitmapDataPlain = getButtonBitmap(26);
					buttonView.bitmapDataActive = getButtonBitmap(35);
				}
				
				if (isNaN(buttonView.buttonData.button.move.horizontal) && isNaN(buttonView.buttonData.button.move.vertical)) {
					buttonView.x = lastX;
					lastX += buttonView.width + _barView.buttonBarData.buttons.spacing;
				}else {
					buttonView.x = buttonView.buttonData.button.move.horizontal;
					buttonView.y = buttonView.buttonData.button.move.vertical;
				}
				
				buttonView.x += _barView.buttonBarData.bg.hspace;
				buttonView.y += _barView.buttonBarData.bg.vspace;
				
				if (buttonView.buttonData.button.mouse.onOver != null) {
					buttonView.addEventListener(MouseEvent.ROLL_OVER, getMouseEventHandler(buttonView.buttonData.button.mouse.onOver));
				}
				if (buttonView.buttonData.button.mouse.onOut != null) {
					buttonView.addEventListener(MouseEvent.ROLL_OUT, getMouseEventHandler(buttonView.buttonData.button.mouse.onOut));
				}
			}
			_barView.buttonBarData.windowData.barWidth = _barView.width+_barView.buttonBarData.bg.hspace*2;
			_barView.buttonBarData.windowData.barHeight = _barView.height+_barView.buttonBarData.bg.vspace*2;
		}
		
		private function getMouseEventHandler(actionId:String):Function{
			return function(e:MouseEvent):void {
				_module.qjPlayer.manager.runAction(actionId);
			}
		}
		
		// ids hardcoded 
		// button id as in:
		// [ 0][ 1][ 2][ 3][ 4][ 5][ 6][ 7][ 8]
		// [ 9][10][11][12][13][14][15][16][17]
		// [18][19][20][21][22][23][24][25][26]
		// [27][28][29][30][31][32][33][34][35]
		private function getButtonBitmap(buttonId:int):BitmapData {
			var bmd:BitmapData = new BitmapData(buttonSize.width, buttonSize.height, true, 0);
			bmd.copyPixels(
				buttonsBitmapData,
				new Rectangle(
					(buttonId % 9) * buttonSize.width + 1 * (buttonId % 9),
					Math.floor(buttonId / 9) * buttonSize.height + 1 * Math.floor(buttonId / 9),
					buttonSize.width,
					buttonSize.height),
				new Point(0, 0),
				null,
				null,
				true);
			return bmd;
		}
		
		private function onEnterFrameHandler(event:Event):void{
			
			//背景音乐连动
			var obj:Object = _module.qjPlayer.getModuleByName("BackgroundMusic") as Object;
			if(obj != null )
			{
				if(obj.isCurrentPlay == true)
				{
					setButtonActive("d",true);
				}
				else
				{
					setButtonActive("d",false);
				}
			}
			if(_barView != null && _barView.stage)
			{
				setButtonActive("fullscreen", _barView.stage.displayState != StageDisplayState.NORMAL);
			}
			
		}
		
		private function onFullScreenChange(event:Event):void {
			if(_barView != null && _barView.stage)
				setButtonActive("fullscreen", _barView.stage.displayState != StageDisplayState.NORMAL);
		}
		
		private function onIsAutorotatingChange(autorotationEvent:Object = null):void {
			if (_module.qjPlayer.managerData.controlData.autorotationCameraData.enabled){
				setButtonActive("autorotation", _module.qjPlayer.managerData.controlData.autorotationCameraData.isAutorotating);
			}
		}
		
		private function onDragEnabledChange(event:Object = null):void {
			setButtonActive("drag", _module.qjPlayer.managerData.controlData.arcBallCameraData.enabled);
		}
		
		private function leftPress(e:Event):void {
			_module.stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, false, true, 0, cameraKeyBindingsClass.LEFT));
		}
		private function leftRelease(e:Event):void {
			_module.stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP, false, true, 0, cameraKeyBindingsClass.LEFT));
		}
		private function rightPress(e:Event):void {
			_module.stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, false, true, 0, cameraKeyBindingsClass.RIGHT));
		}
		private function rightRelease(e:Event):void {
			_module.stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP, false, true, 0, cameraKeyBindingsClass.RIGHT));
		}
		private function upPress(e:Event):void {
			_module.stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, false, true, 0, cameraKeyBindingsClass.UP));
		}
		private function upRelease(e:Event):void {
			_module.stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP, false, true, 0, cameraKeyBindingsClass.UP));
		}
		private function downPress(e:Event):void {
			_module.stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, false, true, 0, cameraKeyBindingsClass.DOWN));
		}
		private function downRelease(e:Event):void {
			_module.stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP, false, true, 0, cameraKeyBindingsClass.DOWN));
		}
		private function inPress(e:Event):void {
			_module.stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, false, true, 0, cameraKeyBindingsClass.IN));
		}
		private function inRelease(e:Event):void {
			_module.stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP, false, true, 0, cameraKeyBindingsClass.IN));
		}
		private function outPress(e:Event):void {
			_module.stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, false, true, 0, cameraKeyBindingsClass.OUT));
		}
		private function outRelease(e:Event):void {
			_module.stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP, false, true, 0, cameraKeyBindingsClass.OUT));
		}
		
		private function dragToggle(e:Event = null):void {
			if (_module.qjPlayer.managerData.controlData.inertialMouseCameraData.enabled ||
				!_module.qjPlayer.managerData.controlData.arcBallCameraData.enabled) {
				_module.qjPlayer.managerData.controlData.inertialMouseCameraData.enabled = false;
				_module.qjPlayer.managerData.controlData.arcBallCameraData.enabled = true;
			}else {
				_module.qjPlayer.managerData.controlData.inertialMouseCameraData.enabled = true;
				_module.qjPlayer.managerData.controlData.arcBallCameraData.enabled = false;
			}
		}
		
		private function autorotateToggle(e:Event = null):void {
			_module.qjPlayer.managerData.controlData.autorotationCameraData.isAutorotating = !_module.qjPlayer.managerData.controlData.autorotationCameraData.isAutorotating;
		}
		
		private function fullscreenToggle(e:Event = null):void {
			_module.qjPlayer.stage.displayState = (_module.qjPlayer.stage.displayState == StageDisplayState.NORMAL) ?
				StageDisplayState.FULL_SCREEN :
				StageDisplayState.NORMAL;
		}
		
		private function displayFullscreen():void {
			setButtonActive("fullscreen", _module.qjPlayer.stage.displayState == StageDisplayState.FULL_SCREEN);
		}
		
		private function keyDownEvent(e:KeyboardEvent):void {
			switch( e.keyCode ){
				case cameraKeyBindingsClass.UP:
					setButtonActive("up", true);
				break;
				case cameraKeyBindingsClass.DOWN:
					setButtonActive("down", true);
				break;
				case cameraKeyBindingsClass.LEFT:
					setButtonActive("left", true);
				break;
				case cameraKeyBindingsClass.RIGHT:
					setButtonActive("right", true);
				break;
				case cameraKeyBindingsClass.IN:
					setButtonActive("in", true);
				break;
				case cameraKeyBindingsClass.OUT:
					setButtonActive("out", true);
				break;
			}
		}
		
		private function keyUpEvent(e:KeyboardEvent):void {
			switch( e.keyCode ){
				case cameraKeyBindingsClass.UP:
					setButtonActive("up", false);
				break;
				case cameraKeyBindingsClass.DOWN:
					setButtonActive("down", false);
				break;
				case cameraKeyBindingsClass.LEFT:
					setButtonActive("left", false);
				break;
				case cameraKeyBindingsClass.RIGHT:
					setButtonActive("right", false);
				break;
				case cameraKeyBindingsClass.IN:
					setButtonActive("in", false);
				break;
				case cameraKeyBindingsClass.OUT:
					setButtonActive("out", false);
				break;
			}
		}
	}
}
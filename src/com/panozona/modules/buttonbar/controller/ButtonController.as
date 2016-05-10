/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.buttonbar.controller{
	
	import com.panozona.modules.buttonbar.events.ButtonEvent;
	import com.panozona.modules.buttonbar.model.ButtonData;
	import com.panozona.modules.buttonbar.view.ButtonView;
	import com.panozona.player.module.Module;
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	
	public class ButtonController {
		
		private var _module:Module;
		private var _buttonView:ButtonView;
		
		public function ButtonController(buttonView:ButtonView, module:Module){
			_buttonView = buttonView;
			_module = module;
			
			if (buttonView.buttonData.onPress != null) {
				_buttonView.addEventListener(MouseEvent.MOUSE_DOWN, buttonView.buttonData.onPress, false, 0, true);
			}
			
			if (buttonView.buttonData.onRelease != null) {
				_buttonView.addEventListener(MouseEvent.MOUSE_UP, buttonView.buttonData.onRelease, false, 0, true);
		     	if(buttonView.buttonData.button.name != "fullscreen"){ // bug when switching to fullscreen
					_buttonView.addEventListener(MouseEvent.ROLL_OUT, buttonView.buttonData.onRelease, false, 0, true);
				}
			}
			_buttonView.buttonData.addEventListener(ButtonEvent.CHANGED_MOUSE_PRESS, handleButtonMousePressChange, false, 0, true);
			_buttonView.buttonData.addEventListener(ButtonEvent.CHANGED_IS_ACTIVE, handleButtonIsActiveChange, false, 0, true);
		}
		
		private function handleButtonMousePressChange(e:ButtonEvent):void {
			if (_buttonView.buttonData.mousePress) {
				_buttonView.setActive();
			}else if (!_buttonView.buttonData.isActive) {
				_buttonView.setPlain();
			}
		}
		
		private function handleButtonIsActiveChange(e:ButtonEvent):void {
			if (!_buttonView.buttonData.isActive) {
				_buttonView.setPlain();
			}else {
				_buttonView.setActive();
			}
		}
	}
}
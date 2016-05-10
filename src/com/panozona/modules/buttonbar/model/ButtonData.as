/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.buttonbar.model {
	
	import com.panozona.modules.buttonbar.events.ButtonEvent;
	import com.panozona.modules.buttonbar.model.structure.Button;
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	
	public class ButtonData extends EventDispatcher {
		
		public var name:String;
		public var onPress:Function;
		public var onRelease:Function;
		
		private var _isActive:Boolean;
		private var _mousePress:Boolean;
		
		private var _button:Button;
		
		public function ButtonData(button:Button):void {
			_button = button;
		}
		
		public function get button():Button {
			return _button;
		}
		
		public function get isActive():Boolean { return _isActive; }
		public function set isActive(value:Boolean):void {
			if (value == _isActive) return;
			_isActive= value;
			dispatchEvent(new ButtonEvent(ButtonEvent.CHANGED_IS_ACTIVE));
		}
		
		public function get mousePress():Boolean { return _mousePress}
		public function set mousePress(value:Boolean):void {
			if (value == mousePress) return;
			_mousePress = value;
			dispatchEvent(new ButtonEvent(ButtonEvent.CHANGED_MOUSE_PRESS));
		}
	}
}
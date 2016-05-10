/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.imagebutton.model {
	
	import com.panozona.modules.imagebutton.events.SubButtonEvent;
	import com.panozona.modules.imagebutton.model.structure.SubButton;
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	
	public class SubButtonData extends EventDispatcher{
		
		private var _isActive:Boolean;
		private var _mousePress:Boolean;
		
		private var _subButton:SubButton;
		
		public function SubButtonData(subButton:SubButton):void {
			_subButton = subButton;
		}
		
		public function get subButton():SubButton {
			return _subButton;
		}
		
		public function get isActive():Boolean { return _isActive; }
		public function set isActive(value:Boolean):void {
			if (value == _isActive) return;
			_isActive= value;
			dispatchEvent(new SubButtonEvent(SubButtonEvent.CHANGED_IS_ACTIVE));
		}
		
		public function get mousePress():Boolean { return _mousePress}
		public function set mousePress(value:Boolean):void {
			if (value == mousePress) return;
			_mousePress = value;
			dispatchEvent(new SubButtonEvent(SubButtonEvent.CHANGED_MOUSE_PRESS));
		}
	}
}
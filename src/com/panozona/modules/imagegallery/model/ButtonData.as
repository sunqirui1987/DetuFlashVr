/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.imagegallery.model {
	
	import com.panozona.modules.imagegallery.events.ButtonEvent;
	import flash.events.EventDispatcher;
	
	public class ButtonData extends EventDispatcher {
		
		public var onPress:Function;
		public var onRelease:Function;
		
		private var _imageIndex:Number;
		private var _isActive:Boolean;
		private var _mousePress:Boolean;
		
		public function ButtonData(imageIndex:Number):void {
			_imageIndex = imageIndex;
		}
		
		public function get imageIndex():Number { return _imageIndex; }
		
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
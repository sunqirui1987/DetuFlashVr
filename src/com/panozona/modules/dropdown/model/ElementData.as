/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.dropdown.model {
	
	import com.panozona.modules.dropdown.events.ElementEvent;
	import com.panozona.modules.dropdown.model.structure.Element;
	import com.panozona.modules.dropdown.model.structure.RawElement;
	import flash.events.EventDispatcher;
	
	public class ElementData extends EventDispatcher{
		
		private var _isActive:Boolean;
		private var _mouseOver:Boolean;
		
		private var _rawElement:RawElement;
		
		private var _width:Number;
		
		public function ElementData(rawElement:RawElement) {
			_rawElement = rawElement;
		}
		
		public function get rawElement():RawElement { return _rawElement;}
		
		public function get width():Number { return _width;}
		public function set width(value:Number):void {
			if (value == _width) return;
			_width = value;
			dispatchEvent(new ElementEvent(ElementEvent.CHANGED_WIDTH));
		}
		
		public function get isActive():Boolean { return _isActive;}
		public function set isActive(value:Boolean):void {
			if (value == _isActive) return;
			_isActive = value;
			dispatchEvent(new ElementEvent(ElementEvent.CHANGED_IS_ACTIVE));
		}
		
		public function get mouseOver():Boolean { return _mouseOver;}
		public function set mouseOver(value:Boolean):void {
			if (value == _mouseOver) return;
			_mouseOver = value;
			dispatchEvent(new ElementEvent(ElementEvent.CHANGED_MOUSE_OVER));
		}
	}
}
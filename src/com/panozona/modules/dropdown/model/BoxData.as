/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.dropdown.model{
	
	import com.panozona.modules.dropdown.events.BoxEvent;
	import com.panozona.modules.dropdown.model.structure.Box;
	import com.panozona.modules.dropdown.model.structure.Elements;
	import flash.events.EventDispatcher;
	
	public class BoxData extends EventDispatcher {
		
		public const box:Box = new Box();
		
		public const elements:Elements = new Elements();
		
		private var _open:Boolean;
		private var _mouseOver:Boolean;
		
		public function get open():Boolean { return _open;}
		public function set open(value:Boolean):void {
			if (value == _open) return;
			_open = value;
			dispatchEvent(new BoxEvent(BoxEvent.CHANGED_OPEN));
		}
		
		public function get mouseOver():Boolean { return _mouseOver;}
		public function set mouseOver(value:Boolean):void {
			if (value == _mouseOver) return;
			_mouseOver = value;
			dispatchEvent(new BoxEvent(BoxEvent.CHANGED_MOUSE_OVER));
		}
	}
}
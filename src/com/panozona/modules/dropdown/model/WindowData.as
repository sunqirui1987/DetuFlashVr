/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.dropdown.model {
	
	import com.panozona.modules.dropdown.events.WindowEvent;
	import com.panozona.modules.dropdown.model.structure.Window;
	import com.panozona.player.module.data.property.Size;
	import flash.events.EventDispatcher;
	
	public class WindowData extends EventDispatcher{
		
		public const window:Window = new Window();
		
		private var _open:Boolean;
		private var _finalSize:Size;
		
		public function get open():Boolean{return _open}
		public function set open(value:Boolean):void {
			if (value == _open) return;
			_open = value;
			dispatchEvent(new WindowEvent(WindowEvent.CHANGED_OPEN));
		}
		
		public function get finalSize():Size{return _finalSize}
		public function set finalSize(value:Size):void {
			if (_finalSize != null) return;
			_finalSize = value;
			dispatchEvent(new WindowEvent(WindowEvent.CHANGED_FINAL_SIZE));
		}
	}
}
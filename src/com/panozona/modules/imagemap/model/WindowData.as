/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.imagemap.model {
	
	import com.panozona.modules.imagemap.events.WindowEvent;
	import com.panozona.modules.imagemap.model.structure.Window;
	import flash.events.EventDispatcher;
	
	public class WindowData extends EventDispatcher{
		
		public const window:Window = new Window();
		private var _open:Boolean;
		
		public function get open():Boolean{return _open}
		public function set open(value:Boolean):void {
			if (value == _open) return;
			_open = value;
			dispatchEvent(new WindowEvent(WindowEvent.CHANGED_OPEN));
		}
	}
}
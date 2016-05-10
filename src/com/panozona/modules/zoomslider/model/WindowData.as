/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.zoomslider.model {
	
	import com.panozona.modules.zoomslider.events.WindowEvent;
	import com.panozona.modules.zoomslider.model.structure.Window;
	import com.panozona.player.module.data.property.Size;
	import flash.events.EventDispatcher;
	
	public class WindowData extends EventDispatcher{
		
		public const window:Window = new Window();
		
		private var _open:Boolean;
		private var _size:Size; // size is determined after bitmaps grid is loaded
		
		public function get open():Boolean {return _open;}
		public function set open(value:Boolean):void {
			if (value == _open) return;
			_open = value;
			dispatchEvent(new WindowEvent(WindowEvent.CHANGED_OPEN));
		}
		
		public function get size():Size {return _size;}
		public function set size(size:Size):void {
			if (_size != null) return;
			_size = size;
			dispatchEvent(new WindowEvent(WindowEvent.CHANGED_SIZE));
		}
	}
}
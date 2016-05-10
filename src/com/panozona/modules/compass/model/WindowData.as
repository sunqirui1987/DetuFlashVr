/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.compass.model {
	
	import com.panozona.modules.compass.events.WindowEvent;
	import com.panozona.modules.compass.model.structure.Window;
	import com.panozona.player.module.data.property.Size;
	import flash.events.EventDispatcher;
	
	public class WindowData extends EventDispatcher{
		
		private var _open:Boolean;
		private var _size:Size;
		
		public const window:Window = new Window();
		
		public function WindowData ():void {
			_size = new Size(1, 1);
		}
		
		public function get open():Boolean{return _open}
		public function set open(value:Boolean):void {
			if (value == _open) return;
			_open = value;
			dispatchEvent(new WindowEvent(WindowEvent.CHANGED_OPEN));
		}
		
		public function get size():Size { return _size;}
		public function set size(value:Size):void {
			if (value.width > _size.width) {
				_size.width = value.width;
			}
			if (value.height > _size.height) {
				_size.height = value.height;
			}
			dispatchEvent(new WindowEvent(WindowEvent.CHANGED_SIZE));
		}
	}
}
/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.imagegallery.model {
	
	import com.panozona.modules.imagegallery.events.WindowEvent;
	import com.panozona.modules.imagegallery.model.structure.Window;
	import com.panozona.player.module.data.property.Size;
	import com.panozona.player.module.data.property.Move;
	import flash.events.EventDispatcher;
	 
	public class WindowData extends EventDispatcher {
		
		public const window:Window = new Window();
		
		private var _open:Boolean;
		private var _currentSize:Size;
		private var _currentMove:Move;
		
		public function WindowData() {
			_currentSize = new Size(0, 0);
			_currentMove = new Move(0, 0);
		}
		
		public function get open():Boolean { return _open };
		public function set open(value:Boolean):void {
			if (value == _open) return;
			_open = value;
			dispatchEvent(new WindowEvent(WindowEvent.CHANGED_OPEN));
		}
		
		public function get currentSize():Size { return _currentSize };
		public function set currentSize(value:Size):void {
			if (value == null 
				|| _currentSize.width == value.width 
				&& _currentSize.height == value.height) {
				return;
			}
			_currentSize = value;
			dispatchEvent(new WindowEvent(WindowEvent.CHANGED_CURRENT_SIZE));
		}
		
		public function get currentMove():Move { return _currentMove };
		public function set currentMove(value:Move):void {
			if (value == null 
				|| _currentMove.horizontal == value.horizontal 
				&& _currentMove.vertical == value.vertical) {
				return;
			}
			_currentMove = value;
			dispatchEvent(new WindowEvent(WindowEvent.CHANGED_CURRENT_MOVE));
		}
	}
}
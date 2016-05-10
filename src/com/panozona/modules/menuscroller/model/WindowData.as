/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.menuscroller.model {
	
	import com.panozona.modules.menuscroller.events.WindowEvent;
	import com.panozona.modules.menuscroller.model.structure.Window;
	import flash.events.EventDispatcher;
	
	public class WindowData extends EventDispatcher{
		
		private var _open:Boolean;
		
		private var _elasticWidth:Number;
		private var _elasticHeight:Number;
		
		public const window:Window = new Window();
		
		public function get open():Boolean { return _open;}
		public function set open(value:Boolean):void {
			if (value == _open) return;
			_open = value;
			dispatchEvent(new WindowEvent(WindowEvent.CHANGED_OPEN));
		}
		
		public function get elasticWidth():Number { return _elasticWidth;}
		public function set elasticWidth(value:Number):void {
			if (value == _elasticWidth) return;
			_elasticWidth = value;
			dispatchEvent(new WindowEvent(WindowEvent.CHANGED_ELASTIC_WIDTH));
		}
		
		public function get elasticHeight():Number { return _elasticHeight;}
		public function set elasticHeight(value:Number):void {
			if (value == _elasticHeight) return;
			_elasticHeight = value;
			dispatchEvent(new WindowEvent(WindowEvent.CHANGED_ELASTIC_HEIGHT));
		}
	}
}
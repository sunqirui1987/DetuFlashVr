/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.buttonbar.model {
	
	import com.panozona.modules.buttonbar.events.ButtonBarEvent;
	import com.panozona.modules.buttonbar.events.WindowEvent;
	import com.panozona.modules.buttonbar.model.structure.Window;
	import com.panozona.player.module.data.property.Size;
	
	import flash.events.EventDispatcher;
	
	public class WindowData extends EventDispatcher{
		
		public const window:Window = new Window();
		
		private var _open:Boolean;
		private var _size:Size;
		
		private var _barWidth:Number = 0;
		private var _barHeight:Number = 0;
		
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
			_size = value;
			dispatchEvent(new WindowEvent(WindowEvent.CHANGED_SIZE));
		}
		
		public function get barWidth():Number { return _barWidth;}
		public function set barWidth(_barWidth:Number):void {
			if(this._barWidth == _barWidth)
				return;
			this._barWidth = _barWidth;
			dispatchEvent(new ButtonBarEvent(ButtonBarEvent.UPDATE_BUTTON));
		}
		
		public function get barHeight():Number { return _barHeight;}
		public function set barHeight(_barHeight:Number):void {
			if(this._barHeight == _barHeight)
				return;
			this._barHeight = _barHeight;
			dispatchEvent(new ButtonBarEvent(ButtonBarEvent.UPDATE_BUTTON));
		}
	}
}
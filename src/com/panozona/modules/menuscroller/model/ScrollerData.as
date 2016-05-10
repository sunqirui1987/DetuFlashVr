/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.menuscroller.model{
	
	import com.panozona.modules.menuscroller.events.ScrollerEvent;
	import com.panozona.modules.menuscroller.model.structure.Scroller;
	
	import flash.events.EventDispatcher;
	
	public class ScrollerData extends EventDispatcher{
		
		public const scroller:Scroller = new Scroller();
		
		private var _scrollValue:Number = 0;
		private var _totalSize:Number = 0;
		private var _mouseOver:Boolean;
		
		private var _scrollVal:Number = 0;//滚动值
		
		public function get scrollValue():Number { return _scrollValue; }
		public function set scrollValue(value:Number):void {
			if (value == _scrollValue) return;
			_scrollValue = value;
			dispatchEvent(new ScrollerEvent(ScrollerEvent.CHANGED_SCROLL));
		}
		
		public function get totalSize():Number { return _totalSize; }
		public function set totalSize(value:Number):void {
			if (value == _totalSize) return;
			_totalSize = value;
			dispatchEvent(new ScrollerEvent(ScrollerEvent.CHANGED_TOTAL_SIZE));
		}
		
		public function get mouseOver():Boolean { return _mouseOver; }
		public function set mouseOver(value:Boolean):void {
			if (value == _mouseOver) return;
			_mouseOver = value;
			dispatchEvent(new ScrollerEvent(ScrollerEvent.CHANGED_MOUSE_OVER));
		}
		
		public function get scrollVal():Number { return _scrollVal; }
		public function set scrollVal(value:Number):void {
	//		if (value == _scrollVal) return;
			_scrollVal = value;
			dispatchEvent(new ScrollerEvent(ScrollerEvent.CHANGED_SCROLL_VALUE));
		}
	}
}
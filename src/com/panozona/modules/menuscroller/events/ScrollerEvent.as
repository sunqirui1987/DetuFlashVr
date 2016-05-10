/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.menuscroller.events{
	
	import flash.events.Event;
	
	public class ScrollerEvent extends Event{
		
		public static const CHANGED_SCROLL:String = "changedScroll";
		public static const CHANGED_TOTAL_SIZE:String = "changedTotalSize";
		public static const CHANGED_MOUSE_OVER:String = "changedMouseOver";
		
		public static const CHANGED_SCROLL_VALUE:String = "changedScrollValue";
		
		public function ScrollerEvent(type:String){
			super(type);
		}
	}
}
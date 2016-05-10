/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.imagemap.events {
	
	import flash.events.Event;
	
	public class ViewerEvent extends Event{
		
		public static const CHANGED_MOVE:String = "changedMove";
		public static const CHANGED_ZOOM:String = "changedZoom";
		
		public static const CHANGED_MOUSE_OVER:String = "changedmOver";
		public static const CHANGED_MOUSE_DRAG:String = "changedmDrag";
		
		public static const CHANGED_FOCUS_POINT:String = "changedfPoint";
		
		public static const CHANGED_SIZE:String = "changedSize";
		
		public static const FOCUS_LOST:String = "focusLost";
		
		public function ViewerEvent(type:String){
			super(type);
		}
	}
}
/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.zoomslider.events{
	
	import flash.events.Event;
	
	public class SliderEvent extends Event{
		
		public static const CHANGED_FOV_LIMIT:String = "changedFovLimit";
		public static const CHANGED_MOUSE_DRAG:String = "changedMouseDrag";
		public static const CHANGED_ZOOM:String = "changedZoom";
		
		public function SliderEvent(type:String){
			super(type);
		}
	}
}
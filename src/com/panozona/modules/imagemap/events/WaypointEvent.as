/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.imagemap.events{
	
	import flash.events.Event;
	
	public class WaypointEvent extends Event{
		
		public static const CHANGED_SHOW_RADAR:String  = "changedShowRadar";
		public static const CHANGED_MOUSE_OVER:String  = "changedMouseOver";
		
		public function WaypointEvent(type:String){
			super(type);
		}
	}
}
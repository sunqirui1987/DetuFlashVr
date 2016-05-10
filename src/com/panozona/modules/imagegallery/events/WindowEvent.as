/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.imagegallery.events {
	
	import flash.events.Event;
	
	public class WindowEvent extends Event {
		
		public static const CHANGED_OPEN:String = "changedOpen";
		public static const CHANGED_CURRENT_SIZE:String = "changedCurrentSize";
		public static const CHANGED_CURRENT_MOVE:String = "changedCurrentMove";
		
		public function WindowEvent(type:String){
			super(type);
		}
	}
}
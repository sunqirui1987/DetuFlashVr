/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.dropdown.events {
	
	import flash.events.Event;
	
	public class WindowEvent extends Event{
		
		public static const CHANGED_OPEN:String = "changedOpen";
		public static const CHANGED_FINAL_SIZE:String = "changedFinalSize";
		
		public function WindowEvent(type:String){
			super(type);
		}
	}
}
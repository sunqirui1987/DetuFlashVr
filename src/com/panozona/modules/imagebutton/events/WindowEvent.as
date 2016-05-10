/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.imagebutton.events {
	
	import flash.events.Event;
	
	public class WindowEvent extends Event {
		
		public static const CHANGED_OPEN:String = "changedOpen";
		public static const CHANGED_SIZE:String = "changedSize";
		
		public function WindowEvent(type:String){
			super(type);
		}
	}
}
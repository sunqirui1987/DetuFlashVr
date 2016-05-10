/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.imagemap.events {
	
	import flash.events.Event;
	
	public class WindowEvent extends Event{
		
		public static const CHANGED_OPEN:String = "changedOpen";
		
		public function WindowEvent(type:String){
			super(type);
		}
	}
}
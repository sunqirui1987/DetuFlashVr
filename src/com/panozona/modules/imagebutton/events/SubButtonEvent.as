/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.imagebutton.events {
	
	import flash.events.Event;
	
	public class SubButtonEvent extends Event {
		
		public static const CHANGED_IS_ACTIVE:String = "chngdIsActive";
		public static const CHANGED_MOUSE_PRESS:String = "chngdMousePress";
		
		public function SubButtonEvent(type:String){
			super(type);
		}
	}
}
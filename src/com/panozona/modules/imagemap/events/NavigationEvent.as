/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.imagemap.events {
	
	import flash.events.Event;
	
	public class NavigationEvent extends Event {
		
		public static const CHANGED_IS_ACTIVE:String = "chngdIsActive";
		
		public function NavigationEvent(type:String) {
			super(type);
		}
	}
}
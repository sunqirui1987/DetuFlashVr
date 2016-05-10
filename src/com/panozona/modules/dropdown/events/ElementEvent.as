/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.dropdown.events {
	
	import flash.events.Event;
	
	public class ElementEvent extends Event{
		
		public static const CHANGED_WIDTH:String = "changedWidth";
		public static const CHANGED_IS_ACTIVE:String = "changedIsActive";
		public static const CHANGED_MOUSE_OVER:String = "changedMouseOver";
		
		public function ElementEvent( type:String){
			super(type);
		}
	}
}
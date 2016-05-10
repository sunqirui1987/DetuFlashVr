/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.menuscroller.events {
	
	import flash.events.Event;
	
	public class ElementEvent extends Event{
		
		public static const CHANGED_IS_SHOWING:String = "changedIsShowing";
		public static const CHANGED_SIZE:String = "changedSize";
		public static const CHANGED_IS_ACTIVE:String = "changedIsActive";
		public static const CHANGED_MOUSE_OVER:String = "changedMouseOver";
		
		public function ElementEvent(type:String){
			super(type);
		}
	}
}
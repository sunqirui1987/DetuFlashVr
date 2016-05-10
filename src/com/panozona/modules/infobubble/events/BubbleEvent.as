/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.infobubble.events{
	
	import flash.events.Event;
	
	public class BubbleEvent extends Event {
		
		public static const CHANGED_CURRENT_ID:String = "changedCurrentId";
		public static const CHANGED_IS_SHOWING:String = "changedIsShowing";
		public static const CHANGED_ENABLED:String = "changedEnabled";
		
		public function BubbleEvent( type:String) {
			super(type);
		}
	}
}
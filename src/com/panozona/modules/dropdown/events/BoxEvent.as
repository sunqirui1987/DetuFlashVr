/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.dropdown.events{
	
	import flash.events.Event;
	
	public class BoxEvent extends Event{
		
		public static const CHANGED_OPEN:String = "changedOpen";
		public static const CHANGED_MOUSE_OVER:String = "changedMouseOver";
		
		public function BoxEvent( type:String){
			super(type);
		}
	}
}
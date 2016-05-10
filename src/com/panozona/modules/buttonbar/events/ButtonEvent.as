/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.buttonbar.events{
	
	import flash.events.Event;
	
	public class ButtonEvent extends Event{
		
		public static const CHANGED_IS_ACTIVE:String = "chngdIsActive";
		public static const CHANGED_MOUSE_PRESS:String = "chngdMousePress";
		
		public function ButtonEvent( type:String){
			super(type);
		}
	}
}
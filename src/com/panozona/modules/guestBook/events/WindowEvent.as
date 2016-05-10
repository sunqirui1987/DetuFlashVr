/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.guestBook.events {
	
	import flash.events.Event;
	
	public class WindowEvent extends Event{
		
		public static const CHANGED_OPEN:String = "changedOpen";
		public static const ADD_NEW_MESSAGE:String = "ADD_NEW_MESSAGE";
		
		public static const COMMIT_NEW_MESSAGE:String = "COMMIT_NEW_MESSAGE";
		
		public function WindowEvent(type:String){
			super(type);
		}
	}
}
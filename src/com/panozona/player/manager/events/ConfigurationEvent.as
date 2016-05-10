/*
 OuWei Flash3DHDView 
*/
package com.panozona.player.manager.events{
	
	import flash.events.Event;
	
	public class ConfigurationEvent extends Event{
		
		public static const ERROR:String = "error";
		public static const WARNING:String = "warning";
		public static const INFO:String = "info";
		
		private var _message:String;
		
		public function ConfigurationEvent(type:String, message:String){
			super(type);
			_message = message;
		}
		
		public function get message():String {
			return _message;
		}
	}
}
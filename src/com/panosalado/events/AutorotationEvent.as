/*
 OuWei Flash3DHDView 
*/
package com.panosalado.events {
	
	import flash.events.Event;
	
	/**
	 * ...
	 * @author mstandio
	 */
	public class AutorotationEvent extends Event{
		
		public static const AUTOROTATION_CHANGE:String = "AutorotationChange";
		
		public function AutorotationEvent(type:String) {
			super(type);
		}		
	}
}
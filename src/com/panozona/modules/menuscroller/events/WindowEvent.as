/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.menuscroller.events {
	
	import flash.events.Event;
	
	public class WindowEvent extends Event{
		
		public static const CHANGED_OPEN:String = "changedOpen";
		public static const CHANGED_ELASTIC_WIDTH:String = "changedElasticWidth";
		public static const CHANGED_ELASTIC_HEIGHT:String = "changedElasticHeight";
		
		public function WindowEvent(type:String){
			super(type);
		}
	}
}
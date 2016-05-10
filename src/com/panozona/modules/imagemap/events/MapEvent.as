/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.imagemap.events{
	
	import flash.events.Event;
	
	public class MapEvent extends Event {
		
		public static const CHANGED_CURRENT_MAP_ID:String = "changedCurrMapId";
		public static const CHANGED_RADAR_FIRST:String = "changedRadarFirst";
		
		public function MapEvent( type:String) {
			super(type);
		}
	}
}
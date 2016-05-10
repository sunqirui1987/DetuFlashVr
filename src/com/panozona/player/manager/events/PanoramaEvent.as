/*
 OuWei Flash3DHDView 
*/
package com.panozona.player.manager.events {
	
	import flash.events.*;
	
	public class PanoramaEvent extends Event{
		
		public static const PANORAMA_STARTED_LOADING:String = "panoramaStartedLoading";
		public static const PANORAMA_LOADED:String = "panoramaLoaded";
		public static const TRANSITION_ENDED:String = "transitionEnded";
		public static const HOTSPOTS_LOADED:String = "hotspotsLoaded";
		
		public function PanoramaEvent(type:String) {
			super(type);
		}
	}
}
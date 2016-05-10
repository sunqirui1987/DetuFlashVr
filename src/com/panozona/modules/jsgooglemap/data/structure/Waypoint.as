/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.jsgooglemap.data.structure {
	
	import com.panozona.player.module.data.property.Geolocation;
	
	public class Waypoint{
		
		public var target:String = null;
		public var label:String = "";
		public var geolocation:Geolocation = new Geolocation();
	}
}
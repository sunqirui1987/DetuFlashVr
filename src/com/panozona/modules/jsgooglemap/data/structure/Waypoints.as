/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.jsgooglemap.data.structure{
	
	import com.panozona.player.module.data.structure.DataParent;
	
	public class Waypoints extends DataParent{
		
		override public function getChildrenTypes():Vector.<Class>{
			var result:Vector.<Class> = new Vector.<Class>();
			result.push(Waypoint);
			return result;
		}
		
		/**
		 * path to image file shown when marker
		 * is set at currently displayed panorama
		 */
		public var markerOn:String = null;
		
		/**
		 * path to image file shown when marker
		 * is not set at currently displayed panorama
		 */
		public var markerOff:String = null;
	}
}
/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.imagemap.model.structure {
	
	import com.panozona.player.module.data.property.Position;
	import com.panozona.player.module.data.property.MouseOverOut;
	
	public class Waypoint {
		
		public var target:String = null;
		public const position:Position = new Position(0,0);
		public const mouse:MouseOverOut = new MouseOverOut();
	}
}
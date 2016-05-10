/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.imagemap.model.structure{
	
	import com.panozona.player.module.data.structure.DataParent;
	
	public class Map extends DataParent{
		
		override public function getChildrenTypes():Vector.<Class>{
			var result:Vector.<Class> = new Vector.<Class>();
			result.push(Waypoints);
			return result;
		}
		
		public var id:String = null;
		public var path:String = null;
		
		public const zoom:Zoom = new Zoom();
		
		public var panShift:Number = 0;
		
		public var onSet:String = null; // action id
		public var onUnset:String = null; // action id
		
		public var xx:Number=0;
		public var yy:Number=0;
	}
}
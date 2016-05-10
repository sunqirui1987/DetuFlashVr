/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.imagemap.model.structure {
	
	import com.panozona.player.manager.utils.loading.ILoadable;
	import com.panozona.player.module.data.property.Move;
	import com.panozona.player.module.data.structure.DataParent;
	
	public class Waypoints extends DataParent implements ILoadable{
		
		override public function getChildrenTypes():Vector.<Class>{
			var result:Vector.<Class> = new Vector.<Class>();
			result.push(Waypoint);
			return result;
		}
		
		private var _path:String = null;
		
		public function get path():String {return _path;}
		public function set path(value:String):void {
			_path = value;
		}
		
		private var _type:Number = 0;
		public function get type():Number {return _type;}
		public function set type(value:Number):void {
			_type = value;
		}
		
		public const move:Move = new Move(0, 0);
		public const radar:Radar = new Radar();
	}
}
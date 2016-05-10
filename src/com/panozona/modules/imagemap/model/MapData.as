/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.imagemap.model{
	
	import com.panozona.modules.imagemap.events.MapEvent;
	import com.panozona.modules.imagemap.model.structure.Map;
	import com.panozona.modules.imagemap.model.structure.Maps;
	import flash.events.EventDispatcher;
	
	public class MapData extends EventDispatcher{
		
		public const maps:Maps = new Maps();
		private var _currentMapId:String = null;
		private var _radarFirst:Boolean = false;
		
		public function getMapById(mapId:String):Map {
			for each(var map:Map in maps.getChildrenOfGivenClass(Map)) {
				if (map.id == mapId) return map;
			}
			return null;
		}
		
		public function get currentMapId():String {return _currentMapId;}
		public function set currentMapId(value:String):void {
			if (value == null || value == _currentMapId) return;
			_currentMapId = value;
			dispatchEvent(new MapEvent(MapEvent.CHANGED_CURRENT_MAP_ID));
		}
		
		public function get radarFirst():Boolean {return _radarFirst;}
		public function set radarFirst(value:Boolean):void {
			_radarFirst = value;
			dispatchEvent(new MapEvent(MapEvent.CHANGED_RADAR_FIRST));
		}
	}
}
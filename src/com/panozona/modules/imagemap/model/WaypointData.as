/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.imagemap.model{
	
	import com.panozona.modules.imagemap.events.WaypointEvent;
	import com.panozona.modules.imagemap.model.structure.Radar;
	import com.panozona.modules.imagemap.model.structure.Waypoint;
	import com.panozona.player.module.data.property.Move;
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	
	public class WaypointData extends EventDispatcher{
		
		public var waypoint:Waypoint;
		public var radar:Radar;
		public var panShift:Number;
		
		private var _showRadar:Boolean;
		private var _mouseOver:Boolean;
		
		public var move:Move;
		
		public var bitmapDataPlain:BitmapData;
		public var bitmapDataHover:BitmapData;
		public var bitmapDataActive:BitmapData;
		
		public function WaypointData(waypoint:Waypoint, radar:Radar, panShift:Number, move:Move,
			bitmapDataPlain:BitmapData, bitmapDataHover:BitmapData, bitmapDataActive:BitmapData ){
			this.waypoint = waypoint;
			this.radar = radar;
			this.panShift = panShift;
			this.move = move;
			this.bitmapDataPlain = bitmapDataPlain;
			this.bitmapDataHover = bitmapDataHover;
			this.bitmapDataActive = bitmapDataActive;
		}
		
		public function get showRadar():Boolean {return _showRadar;}
		public function set showRadar(value:Boolean):void {
			if (value == _showRadar) return;
			_showRadar = value;
			dispatchEvent(new WaypointEvent(WaypointEvent.CHANGED_SHOW_RADAR));
		}
		
		public function get mouseOver():Boolean {return _mouseOver;}
		public function set mouseOver(value:Boolean):void {
			if (value == _mouseOver) return;
			_mouseOver = value;
			dispatchEvent(new WaypointEvent(WaypointEvent.CHANGED_MOUSE_OVER));
		}
	}
}
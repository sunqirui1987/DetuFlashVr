package com.panozona.player.manager.data.streetview
{
	import com.panozona.player.manager.data.panoramas.HotspotDataImage;
	import com.panozona.player.module.data.property.Geolocation;
	
	
	public class StreetviewHotspotData extends HotspotDataImage{
		
		public const gps:Geolocation = new Geolocation();
		public var _direction:Number = 0;
		private var _targetFile:String;
		
		public function StreetviewHotspotData(id:String, path:String, targetFile:String,direction:Number) {
			super(id, path);
			_targetFile = targetFile;
			_direction = direction; 
		}
		
		public function get direction():Number {
			return _direction;
		}
		
		public function get targetFile():String {
			return _targetFile;
		}
	}
}
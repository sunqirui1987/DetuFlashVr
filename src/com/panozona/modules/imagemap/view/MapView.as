/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.imagemap.view {
	
	import com.panozona.modules.imagemap.model.ImageMapData;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	public class MapView extends Sprite {
		
		public const waypointsContainer:Sprite = new Sprite();
		public const radarContainer:Sprite = new Sprite();

		
		private var _content:DisplayObject;
		private var _imageMapData:ImageMapData;
		
		public function MapView(imageMapData:ImageMapData) {
			_imageMapData = imageMapData;
			
			placeContainers();
		}
		
		public function get imageMapData():ImageMapData {
			return _imageMapData;
		}
		
		public function get content():DisplayObject {
			return _content;
		}
		
		public function set content(value:DisplayObject):void {
			if (value == null) return;
			while(numChildren) removeChildAt(0);
			_content = value;
			addChild(_content);
			placeContainers();
		}

		
		public function placeContainers():void {
			if(_imageMapData.mapData.radarFirst){
				addChild(waypointsContainer);
				addChild(radarContainer);
			}else {
				addChild(radarContainer);
				addChild(waypointsContainer);
			}

		}
	}
}
/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.imagemap.view{
	
	import com.panozona.modules.imagemap.model.ImageMapData;
	
	import flash.display.Sprite;
	
	public class CloseView extends Sprite{
		
		private var _imageMapData:ImageMapData;
		
		public function CloseView(imageMapData:ImageMapData):void{
			_imageMapData = imageMapData;
			alpha = 1 / _imageMapData.windowData.window.alpha;
			buttonMode = true;
		}
		
		public function get imageMapData():ImageMapData {
			return _imageMapData;
		}
	}
}
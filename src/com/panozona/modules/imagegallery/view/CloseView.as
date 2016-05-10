/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.imagegallery.view {
	
	import com.panozona.modules.imagegallery.model.ImageGalleryData
	import flash.display.Sprite;
	
	public class CloseView extends Sprite {
		
		private var _imageGalleryData:ImageGalleryData;
		
		public function CloseView(imageGalleryData:ImageGalleryData):void {
			_imageGalleryData = imageGalleryData;
			alpha = 1 / _imageGalleryData.windowData.window.alpha;
			buttonMode = true;
		}
		
		public function get imageGalleryData():ImageGalleryData {
			return _imageGalleryData;
		}
	}
}
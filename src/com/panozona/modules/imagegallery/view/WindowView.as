/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.imagegallery.view {
	
	import com.panozona.modules.imagegallery.model.ImageGalleryData;
	import com.panozona.modules.imagegallery.model.WindowData;
	import flash.display.Sprite;
	
	public class WindowView extends Sprite{
		
		private var _closeView:CloseView;
		private var _viewerView:ViewerView;
		
		private var _imagegalleryData:ImageGalleryData;
		
		public function WindowView(imagegalleryData:ImageGalleryData) {
			_imagegalleryData = imagegalleryData;
			
			_viewerView = new ViewerView(_imagegalleryData);
			addChild(_viewerView);
			
			_closeView = new CloseView(_imagegalleryData);
			addChild(_closeView);
		}
		
		public function get windowData():WindowData {
			return _imagegalleryData.windowData;
		}
		
		public function get viewerView():ViewerView {
			return _viewerView;
		}
		
		public function get closeView():CloseView {
			return _closeView;
		}
	}
}
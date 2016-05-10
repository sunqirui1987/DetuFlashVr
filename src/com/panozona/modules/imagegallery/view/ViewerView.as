/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.imagegallery.view {
	
	import com.panozona.modules.imagegallery.model.ImageGalleryData;
	import com.panozona.modules.imagegallery.model.ButtonData;
	import com.panozona.modules.imagegallery.view.ButtonView;
	import flash.display.Sprite;
	
	public class ViewerView extends Sprite {
		
		private var _imagegalleryData:ImageGalleryData;
		
		private var _buttonBar:Sprite;
		private var _buttonPrev:ButtonView;
		private var _buttonNext:ButtonView;
		
		public function ViewerView(imagegalleryData:ImageGalleryData) {
			_imagegalleryData = imagegalleryData;
			_buttonBar = new Sprite();
			addChild(_buttonBar);
			_buttonPrev = new ButtonView(new ButtonData(NaN), _imagegalleryData)
			addChild(_buttonPrev);
			_buttonNext = new ButtonView(new ButtonData(NaN), _imagegalleryData);
			addChild(_buttonNext);
		}
		
		public function get imagegalleryData():ImageGalleryData  {
			return _imagegalleryData;
		}
		
		public function get buttonBar():Sprite {
			return _buttonBar
		}
		
		public function get buttonPrev():ButtonView {
			return _buttonPrev;
		}
		
		public function get buttonNext():ButtonView {
			return _buttonNext;
		}
	}
}
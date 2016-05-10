/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.zoomslider.view {
	
	import com.panozona.modules.zoomslider.model.ZoomSliderData;
	import com.panozona.modules.zoomslider.model.WindowData;
	import flash.display.Sprite;
	
	public class WindowView extends Sprite {
		
		private var _sliderView:SliderView;
		private var _zoomSliderData:ZoomSliderData;
		
		public function WindowView(zoomSliderData:ZoomSliderData) {
			_zoomSliderData = zoomSliderData;
			
			_sliderView = new SliderView(zoomSliderData);
			addChild(sliderView);
		}
		
		public function get sliderView():SliderView {
			return _sliderView;
		}
		
		public function get zoomSliderData():ZoomSliderData {
			return _zoomSliderData;
		}
		
		public function get windowData():WindowData {
			return _zoomSliderData.windowData;
		}
	}
}
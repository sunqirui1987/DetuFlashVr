/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.panoramaTitleAndDes.view{
	
	import com.panozona.modules.panoramaTitleAndDes.model.PanoramaTitleAndDesData;
	import com.panozona.modules.panoramaTitleAndDes.model.WindowData;
	
	import flash.display.Sprite;
	
	public class WindowView extends Sprite{
		
		private var window:Sprite;
		
		private var _panoramaTitleAndDesData:PanoramaTitleAndDesData;
		
		private var _titleAndDesView:TitleAndDesView;
		
		public function WindowView(_panoramaTitleAndDesData:PanoramaTitleAndDesData) {
			
			this._panoramaTitleAndDesData = _panoramaTitleAndDesData;
			
			this.alpha = _panoramaTitleAndDesData.windowData.window.alpha;
			
			// draw map window
			window = new Sprite();
			window.graphics.beginFill(0xFFFFFF,0);
			window.graphics.drawRect(0, 0, _panoramaTitleAndDesData.windowData.window.size.width, _panoramaTitleAndDesData.windowData.window.size.height);
			window.graphics.endFill();
			addChild(window);
			
			visible = _panoramaTitleAndDesData.windowData.open;
			
			_titleAndDesView = new TitleAndDesView(_panoramaTitleAndDesData);
			addChild(_titleAndDesView);
		}
		
		public function get titleAndDesView():TitleAndDesView {
			return this._titleAndDesView;
		}
		
		public function get windowData():WindowData {
			return _panoramaTitleAndDesData.windowData;
		}
		
		public function get panoramaTitleAndDesData():PanoramaTitleAndDesData {
			return _panoramaTitleAndDesData;
		}
		public function get container():Sprite {
			return window;
		}
		
	}
}
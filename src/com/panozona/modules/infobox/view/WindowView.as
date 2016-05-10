/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.infobox.view{
	
	import com.panozona.modules.infobox.model.InfoBoxData;
	import com.panozona.modules.infobox.model.WindowData;
	import flash.display.Bitmap;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class WindowView extends Sprite{
		
		private var _closeView:CloseView;
		private var _viewerView:ViewerView;
		
		private var window:Sprite;
		private var windowCloseButton:SimpleButton;
		
		private var _infoBoxData:InfoBoxData;
		
		public function WindowView(infoBoxData:InfoBoxData) {
			
			_InfoBoxData= InfoBoxData;
			
			this.alpha = _infoBoxData.windowData.window.alpha;
			
			// draw map window
			window = new Sprite();
			window.graphics.beginFill(0xFFFFFF,0);
			window.graphics.drawRect(0, 0, infoBoxData.windowData.window.size.width, _infoBoxData.windowData.window.size.height);
			window.graphics.endFill();
			addChild(window);
			
			_viewerView = new ViewerView(_infoBoxData);
			window.addChild(_viewerView);
			
			_closeView = new CloseView(_infoBoxData);
			window.addChild(_closeView);
			
			visible = _imageMapData.windowData.open;
		}
		
		public function get windowData():WindowData {
			return _infoBoxData.windowData;
		}
		
		public function get closeView():CloseView {
			return _closeView;
		}
		
		public function get viewerView():ViewerView {
			return _viewerView;
		}
	}
}
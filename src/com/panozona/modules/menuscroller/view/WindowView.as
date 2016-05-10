/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.menuscroller.view{
	
	import com.panozona.modules.menuscroller.model.MenuScrollerData;
	import com.panozona.modules.menuscroller.model.WindowData;
	import flash.display.Bitmap;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class WindowView extends Sprite{
		
		private var _closeView:CloseView;
		private var _scrollerView:ScrollerView;
		
		public var window:Sprite;
		
		private var _menuScrollerData:MenuScrollerData;
		
		public function WindowView(menuScrollerData:MenuScrollerData) {
			
			_menuScrollerData = menuScrollerData;
			
			// draw map window
			window = new Sprite();
			addChild(window);
			visible = _menuScrollerData.windowData.open;
			
			_closeView = new CloseView(_menuScrollerData);
			window.addChild(_closeView);
			
			_scrollerView = new ScrollerView(_menuScrollerData);
			window.addChild(_scrollerView);
		}
		
		public function get windowData():WindowData {
			return _menuScrollerData.windowData;
		}
		
		public function get scrollerView():ScrollerView {
			return _scrollerView;
		}
		
		public function get closeView():CloseView {
			return _closeView;
		}
		
		public function drawBackground():void {
			window.graphics.clear()
			window.graphics.beginFill(_menuScrollerData.windowData.window.color,_menuScrollerData.windowData.window.alpha);
			window.graphics.drawRect(0, 0, _menuScrollerData.windowData.elasticWidth, _menuScrollerData.windowData.elasticHeight);
			window.graphics.endFill();
		}
	}
}
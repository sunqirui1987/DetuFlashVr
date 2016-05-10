/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.imagebutton.view{
	
	import com.panozona.modules.imagebutton.model.WindowData;
	import flash.display.Sprite;
	
	public class WindowView extends Sprite{
		
		private var _buttonView:ButtonView;
		private var _windowData:WindowData;
		
		public function WindowView(windowData:WindowData):void {
			
			_windowData = windowData;
			
			this.alpha = _windowData.window.alpha;
			
			_buttonView = new ButtonView(_windowData);
			addChild(_buttonView);
			
			visible = _windowData.open;
			
			if (_windowData.button.enable == false) {
				mouseEnabled = false;
				mouseChildren = false;
			}
		}
		
		public function get windowData():WindowData {
			return _windowData;
		}
		
		public function get buttonView():ButtonView {
			return _buttonView;
		}
	}
}
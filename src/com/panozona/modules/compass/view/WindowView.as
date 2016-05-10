/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.compass.view {
	
	import com.panozona.modules.compass.model.CompassData;
	import com.panozona.modules.compass.model.WindowData;
	import flash.display.Sprite;
	
	public class WindowView extends Sprite{
		
		private var _closeView:CloseView;
		private var _compassView:CompassView;
		
		private var _compassData:CompassData;
		
		public function WindowView(compassData:CompassData):void {
			
			_compassData = compassData;
			
			this.alpha = _compassData.windowData.window.alpha;
			
			_compassView = new CompassView(_compassData);
			addChild(_compassView);
			
			_closeView = new CloseView(_compassData);
			addChild(_closeView);
			
			visible = _compassData.windowData.open;
		}
		
		public function get compassData():CompassData {
			return _compassData;
		}
		
		public function get windowData():WindowData {
			return _compassData.windowData;
		}
		
		public function get compassView():CompassView {
			return _compassView;
		}
		
		public function get closeView():CloseView {
			return _closeView;
		}
	}
}
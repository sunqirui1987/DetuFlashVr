/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.compass.view {
	
	import com.panozona.modules.compass.model.CompassData;
	import flash.display.Sprite;
	
	public class CloseView extends Sprite {
		
		private var _compassData:CompassData;
		
		public function CloseView(compassData:CompassData):void{
			_compassData = compassData;
			alpha = 1 / _compassData.windowData.window.alpha;
			buttonMode = true;
		}
		
		public function get compassData():CompassData {
			return _compassData;
		}
	}
}
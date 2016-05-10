/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.menuscroller.view{
	
	import com.panozona.modules.menuscroller.model.MenuScrollerData;
	import flash.display.Sprite;
	
	public class CloseView extends Sprite{
		
		private var _menuScrollerData:MenuScrollerData;
		
		public function CloseView(menuScrollerData:MenuScrollerData):void{
			_menuScrollerData = menuScrollerData;
			alpha = 1 / _menuScrollerData.windowData.window.alpha;
			buttonMode = true;
		}
		
		public function get menuScrollerData():MenuScrollerData {
			return _menuScrollerData;
		}
	}
}
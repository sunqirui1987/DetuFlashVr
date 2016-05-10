/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.panolink.view {
	
	import com.panozona.modules.panolink.model.PanoLinkData;
	import flash.display.Sprite;
	
	public class CloseView extends Sprite {
		
		private var _panoLinkData:PanoLinkData;
		
		public function CloseView(panoLinkData:PanoLinkData):void{
			_panoLinkData = panoLinkData;
			alpha = 1 / _panoLinkData.windowData.window.alpha;
			buttonMode = true;
		}
		
		public function get panoLinkData():PanoLinkData {
			return _panoLinkData;
		}
	}
}
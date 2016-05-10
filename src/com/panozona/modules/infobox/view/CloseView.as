/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.infobox.view{
	
	import com.panozona.modules.infobox.model.InfoBoxData;
	import flash.display.Sprite;
	
	public class CloseView extends Sprite{
		
		private var _infoBoxData:InfoBoxData;
		
		public function CloseView(infoBoxData:InfoBoxData):void{
			_infoBoxData = infoBoxData;
			alpha = 1 / _infoBoxData.windowData.window.alpha;
			buttonMode = true;
		}
		
		public function get infoBoxData():InfoBoxData {
			return _infoBoxData;
		}
	}
}
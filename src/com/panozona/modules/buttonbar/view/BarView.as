/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.buttonbar.view{
	
	import com.panozona.modules.buttonbar.model.ButtonBarData;
	import flash.display.Sprite;
	
	public class BarView extends Sprite{
		
		public const buttonsContainer:Sprite = new Sprite();
		
		private var _buttonBarData:ButtonBarData;
		
		public function BarView(buttonBarData:ButtonBarData):void {
			_buttonBarData = buttonBarData;
			addChild(buttonsContainer);
		}
		
		public function get buttonBarData():ButtonBarData {
			return _buttonBarData;
		}
	}
}
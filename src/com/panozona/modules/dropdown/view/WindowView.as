/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.dropdown.view{
	
	import com.panozona.modules.dropdown.model.DropDownData;
	import com.panozona.modules.dropdown.model.WindowData;
	import flash.display.Sprite;
	
	public class WindowView extends Sprite{
		
		private var _boxView:BoxView;
		private var _dropDownData:DropDownData;
		
		public function WindowView(dropDownData:DropDownData) {
			_dropDownData = dropDownData;
			
			this.alpha = _dropDownData.windowData.window.alpha;
			
			_boxView = new BoxView(_dropDownData);
			addChild(_boxView);
			
			visible = _dropDownData.windowData.open;
		}
		
		public function get dropDownData():DropDownData {
			return _dropDownData;
		}
		
		public function get windowData():WindowData {
			return _dropDownData.windowData;
		}
		
		public function get boxView():BoxView {
			return _boxView;
		}
	}
}
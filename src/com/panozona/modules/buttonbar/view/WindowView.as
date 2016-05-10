/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.buttonbar.view{
	
	import com.panozona.modules.buttonbar.model.ButtonBarData;
	import com.panozona.modules.buttonbar.model.WindowData;
	
	import flash.display.Sprite;
	
	public class WindowView extends Sprite{
		
		private var _barView:BarView;
		private var _buttonBarData:ButtonBarData;
		
		private var _bgView:BgView;
		
		private var _swfView:SwfView;
		
		public function WindowView(buttonBarData:ButtonBarData) {
			
			_buttonBarData = buttonBarData;
			
			this.alpha = _buttonBarData.windowData.window.alpha;
			
			visible = _buttonBarData.windowData.open;
			
			if(buttonBarData.swfViewData){
				_swfView = new SwfView(buttonBarData);
				addChild(_swfView);
				return;
			}
			
			_bgView = new BgView(_buttonBarData);
			addChild(_bgView);
			
			_barView = new BarView(_buttonBarData);
			addChild(_barView);
			
			
			
			
		}
		
		public function get windowData():WindowData {
			return _buttonBarData.windowData;
		}
		
		public function get barView():BarView {
			return _barView;
		}
		
		public function get bgView():BgView {
			return _bgView;
		}
		
		public function get swfView():SwfView {
			return _swfView;
		}
	}
}
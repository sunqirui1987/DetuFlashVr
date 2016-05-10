/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.panolink.view{
	
	import com.panozona.modules.panolink.model.PanoLinkData;
	import com.panozona.modules.panolink.model.WindowData;
	import com.panozona.modules.panolink.view.CloseView;
	import flash.display.Sprite;
	
	public class WindowView extends Sprite{
		
		private var _linkView:LinkView;
		private var _closeView:CloseView;
		
		private var _panoLinkData:PanoLinkData;
		
		public function WindowView(panoLinkData:PanoLinkData){
			
			_panoLinkData = panoLinkData;
			
			this.alpha = _panoLinkData.windowData.window.alpha;
			
			_linkView = new LinkView(_panoLinkData);
			addChild(_linkView);
			
			_closeView = new CloseView(_panoLinkData);
			addChild(_closeView);
			
			visible = _panoLinkData.windowData.open;
		}
		
		public function get panoLinkData():PanoLinkData {
			return _panoLinkData;
		}
		
		public function get windowData():WindowData {
			return _panoLinkData.windowData;
		}
		
		public function get linkView():LinkView {
			return _linkView;
		}
		
		public function get closeView():CloseView {
			return _closeView;
		}
	}
}
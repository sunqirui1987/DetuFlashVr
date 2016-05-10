/*
 OuWei Flash3DHDView 
*/
package  com.panozona.modules.baiduMap.view{
	
	import com.panozona.modules.baiduMap.model.BaiduMapData;
	import com.panozona.modules.baiduMap.model.WindowData;
	
	import flash.display.Sprite;
	
	public class WindowView extends Sprite{
		
		private var _closeView:CloseView;
		
		private var window:Sprite;
		
		private var _baiduMapData:BaiduMapData;
		
		public var mapView:MapView;
		
		public function WindowView(_baiduMapData:BaiduMapData) {
			
			this._baiduMapData = _baiduMapData;
			
			this.alpha = _baiduMapData.windowData.window.alpha;
			
			// draw map window
			window = new Sprite();
			window.graphics.beginFill(0xFFFFFF,1);
			window.graphics.drawRect(0, 0, _baiduMapData.windowData.window.size.width, _baiduMapData.windowData.window.size.height);
			window.graphics.endFill();
			addChild(window);
			
			_closeView = new CloseView(_baiduMapData);
			window.addChild(_closeView);
			
			visible = _baiduMapData.windowData.open;
			
			mapView = new MapView(_baiduMapData);
			addChild(mapView);
		}
		
		public function get windowData():WindowData {
			return _baiduMapData.windowData;
		}
		
		public function get closeView():CloseView {
			return _closeView;
		}
		
	}
}
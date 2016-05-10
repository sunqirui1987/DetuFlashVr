/*
 OuWei Flash3DHDView 
*/
package  com.panozona.modules.baiduMap.view{
	
	import com.panozona.modules.baiduMap.model.BaiduMapData;
	
	import flash.display.Sprite;
	
	public class CloseView extends Sprite{
		
		private var _baiduMapData:BaiduMapData;
		
		public function CloseView(_baiduMapData:BaiduMapData):void{
			this._baiduMapData = _baiduMapData;
			alpha = 1 / _baiduMapData.windowData.window.alpha;
			buttonMode = true;
		}
		
		public function get baiduMapData():BaiduMapData {
			return _baiduMapData;
		}
	}
}
package com.panozona.modules.baiduMap.view
{
	import com.panozona.modules.baiduMap.events.BaiduMapEvent;
	import com.panozona.modules.baiduMap.model.BaiduMapData;
	import com.panozona.modules.baiduMap.utils.SwfLoader;
	
	import flash.display.DisplayObject;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	
	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-3-12 上午11:18:06
	 * 功能描述:
	 */
	public class MapView extends Sprite
	{
		
		private var _baiduMapData:BaiduMapData;
		
		public var map:Object;
		
		public function MapView(_baiduMapData:BaiduMapData) {
			this._baiduMapData = _baiduMapData;
			SwfLoader.load(_baiduMapData.windowData.window.corePath,onFinish);
		}
		
		private function onFinish(loaderInfo:LoaderInfo):void{
			var cls:Object = loaderInfo.applicationDomain.getDefinition("BaiduMap");
			map = new cls(_baiduMapData.windowData.window.size.width,_baiduMapData.windowData.window.size.height);
			addChild(map as DisplayObject);
			dispatchEvent(new BaiduMapEvent(BaiduMapEvent.BAIDU_MAP_LOADED));
		}
	}
}
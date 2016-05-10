package com.panozona.modules.imagemap.view
{
	import com.panozona.modules.imagemap.model.ImageMapData;
	
	import flash.display.Sprite;
	
	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-4-4 下午2:21:06
	 * 功能描述:
	 */
	public class PanelView extends Sprite
	{
		private var _imageMapData:ImageMapData;
		
		public function PanelView(imageMapData:ImageMapData):void{
			_imageMapData = imageMapData;
			alpha = 1 / _imageMapData.windowData.window.alpha;
		}
		
		public function get imageMapData():ImageMapData {
			return _imageMapData;
		}
	}
}
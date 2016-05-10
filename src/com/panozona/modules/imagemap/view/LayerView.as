package com.panozona.modules.imagemap.view
{
	import com.panozona.modules.imagemap.model.ImageMapData;
	import com.panozona.modules.imagemap.model.structure.Layer;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-4-10 下午3:22:34
	 * 功能描述:
	 */
	public class LayerView extends Sprite
	{
		private var _imageMapData:ImageMapData;
		
		private var _layerData:Layer;
		
		private var _content:DisplayObject;
		
		public function LayerView(imageMapData:ImageMapData,layerData:Layer) {
			this._imageMapData = imageMapData;
			this._layerData = layerData;
		}
		
		public function set content(_content:DisplayObject):void{
			this._content = _content;
			addChild(this._content);
		}
		
		public function get layerData():Layer{
			return _layerData;
		}
	}
}
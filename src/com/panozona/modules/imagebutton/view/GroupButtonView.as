package com.panozona.modules.imagebutton.view
{
	import com.panozona.modules.imagebutton.model.GroupButtonData;
	import com.panozona.modules.imagebutton.model.ImageButtonData;
	
	import flash.display.Sprite;
	
	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-4-15 下午7:24:57
	 * 功能描述:
	 */
	public class GroupButtonView extends Sprite
	{
		
		private var _groupButtonData:GroupButtonData;
		
		private var _bgView:BgView;
		
		private var _imageButtonData:ImageButtonData;
		
		public function GroupButtonView(_groupButtonData:GroupButtonData,_imageButtonData:ImageButtonData)
		{
			super();
			this._groupButtonData = _groupButtonData;
			
			this._imageButtonData = _imageButtonData;
			
			_bgView = new BgView(_groupButtonData.groupButton);
			addChild(_bgView);
			
			visible = _groupButtonData.groupButton.window.open;
		}
		
		public function get bgView():BgView{
			return _bgView;
		}
		
		public function get groupButtonData():GroupButtonData{
			return _groupButtonData;
		}
		
		public function get imageButtonData():ImageButtonData{
			return _imageButtonData;
		}
	}
}
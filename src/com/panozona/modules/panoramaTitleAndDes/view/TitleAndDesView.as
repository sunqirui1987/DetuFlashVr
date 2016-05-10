package com.panozona.modules.panoramaTitleAndDes.view
{
	import com.panozona.modules.panoramaTitleAndDes.model.PanoramaTitleAndDesData;
	
	import flash.display.Sprite;
	
	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-8-1 上午9:49:32
	 * 功能描述:
	 */
	public class TitleAndDesView extends Sprite
	{
		private var _panoramaTitleAndDesData:PanoramaTitleAndDesData;
		
		public var titleView:TitleView;
		
		public var desView:DesView;
		
		public function TitleAndDesView(_panoramaTitleAndDesData:PanoramaTitleAndDesData)
		{
			super();
			this._panoramaTitleAndDesData = _panoramaTitleAndDesData;
		}
		
		public function setData(title:String,des:String):void{
			if(!titleView){
				titleView = new TitleView(_panoramaTitleAndDesData);
				addChild(titleView);
			}
			if(!desView){
				desView = new DesView(_panoramaTitleAndDesData);
				addChild(desView);
				desView.visible = false;
			}
			titleView.title = title;
			desView.setData(title,des);
		}
		
		public function get panoramaTitleAndDesData():PanoramaTitleAndDesData{
			return this._panoramaTitleAndDesData;
		}
	}
}
package com.panozona.modules.panoramaTitleAndDes.model.structure
{

	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-8-1 上午10:49:14
	 * 功能描述:
	 */
	public class Settings
	{
		
		public var borderColor:Number = 0xffffff;
		
		public var borderThick:Number = 2;
		
		public var backColor:Number = 0x2c2d33;
		
		public var backAlpha:Number = 1;
		
		public var gap:Number = 5;
		
		public var leftPadding:Number = 10;
		
		public var rightPadding:Number = 10;
		
		public var topPadding:Number = 5;
		
		public var titleFontSize:int = 17;
		
		public var titleFontColor:Number = 0xc2c2c2;
		
		public var bigTitleFontSize:int = 25;
		
		public var bigTitleFontColor:Number = 0xffffff;
		
		public var desTitleFontSize:int = 15;
		
		public var desTitleFontColor:Number = 0xc2c2c2;
		
		public var lineAlpha:Number = 1;
		
		public var lineColor:Number = 0x1b1c2d;
		
		public var dropShadowColor:Number = 0x3e3e3e;
		
		public var skinUrls:String;
		
		public var leading:Number = 5;
		
		public var preText:String = "您目前的位置：";
		
		public var spaceleading:Number = 2;
		
		public var isHideDes:Boolean;
		
		public function Settings()
		{
		}
	}
}
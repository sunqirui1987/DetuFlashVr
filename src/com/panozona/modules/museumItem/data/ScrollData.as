package com.panozona.modules.museumItem.data
{
	import com.panozona.player.module.data.property.Size;
	

	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-7-21 下午2:49:27
	 * 功能描述:
	 */
	public class ScrollData
	{
		
		public var backColor:Number = 0xffffff;
		public var backAlpha:Number = 0;
		public var borderColor:Number = 0xffffff;
		
		
		public var itemSize:Size = new Size(50,50);
		public var height:Number = 60;
		
		public var gap:Number = 5;
		
		public var leftpadding:Number=30;
		
		public var itemBackColor:Number = 0x000000;
		
		public var itemBackAlpha:Number = 1;
		
		public function ScrollData()
		{
		}
	}
}
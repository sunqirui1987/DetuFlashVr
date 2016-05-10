package com.panozona.modules.menuscroller.model.structure
{

	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-9-4 上午9:37:29
	 * 功能描述:
	 */
	public class BorderStyle
	{
		
		public var thickness:Number = 1;
		public var color:Number = 0xffffff;
		public var alpha:Number = 0;
		
		public function BorderStyle(thickness:Number = 1,color:Number = 0xffffff,alpha:Number = 0)
		{
			this.thickness = thickness;
			this.color = color;
			this.alpha = alpha;
		}
	}
}
package com.panozona.modules.imagebutton.model.structure
{
	import com.panozona.player.module.data.property.Size;

	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-4-10 上午11:31:03
	 * 功能描述:
	 */
	public class Bg
	{
		public var color:Number = 0xffffff;
		public var alpha:Number = 0;
		public var radius:Number = 10;
		public var mouseEnabled:Boolean;
		public var mouseChildren:Boolean;
		
		public var path:String = null;
		
		public var size:Size = new Size(0,0);
		
		public var type:String = "draw";//draw为画图，pic为纯背景 ，scale9为九宫格
		
		public function Bg()
		{
		}
	}
}
package com.panozona.modules.imagemap.model.structure
{
	import com.panozona.player.module.data.property.Align;
	import com.panozona.player.module.data.property.Move;

	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-4-10 下午3:12:43
	 * 功能描述:
	 */
	public class Layer
	{
		public var name:String;
		public var parent:String;
		public var align:Align = new Align(Align.LEFT,Align.TOP);
		public var move:Move = new Move(0,0);
		public var zorder:int = 1;
		public var url:String = null;
		public var handcursor:Boolean;
		
		public var onclick:String = null;
		
		public var maskRect:MaskRect = new MaskRect();
		public var maskCircle:MaskCircle = new MaskCircle();
		
		public var maskType:String = "rect";//circle
		
		public var mouseChildren:Boolean;
		public var mouseEnabled:Boolean;
		
		
		public function Layer()
		{
		}
	}
}
package com.panozona.modules.guide.model
{
	import com.panozona.player.module.data.property.Align;
	import com.panozona.player.module.data.property.Move;

	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-9-4 上午11:21:41
	 * 功能描述:
	 */
	public class GuideStep
	{
		
		public function GuideStep()
		{
		}
		
		public var id:String;
		public var align:Align = new Align(Align.LEFT,Align.TOP);
		public var move:Move = new Move(0,0);
		public var dir:String = "up";
		public var area:Area = new Area();
		public var timeToNext:Number = 0;
		public var showText:String = "";
		public var picUlr:String = "";
	}
}
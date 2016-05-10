package com.panozona.modules.storyScript.model
{
	import com.panozona.player.module.data.property.Align;
	import com.panozona.player.module.data.property.Move;

	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-8-14 下午1:55:14
	 * 功能描述:
	 */
	public class Close
	{
		public var path:String = null;
		
		public const align:Align = new Align(Align.LEFT, Align.TOP);
		public const move:Move = new Move(0, 0);
		public var toolTips:String="";
		public function Close()
		{
		}
	}
}
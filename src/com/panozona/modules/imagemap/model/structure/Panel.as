package com.panozona.modules.imagemap.model.structure
{
	import com.panozona.player.module.data.property.Align;
	import com.panozona.player.module.data.property.Move;

	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-4-4 下午2:27:18
	 * 功能描述:
	 */
	public class Panel
	{
		public var backPath:String = null;
		
		public var closeButtonPath:String = null;
		
		public const align:Align = new Align(Align.RIGHT, Align.TOP);
		public const move:Move = new Move(0, 0);
		
		public const closeButtonMove:Move = new Move(0, 0);
		
		public var panelHeight:Number = 23;
		public function Panel()
		{
		}
	}
}
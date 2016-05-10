package com.panozona.modules.menuscroller.model.structure
{
	import com.panozona.player.module.data.property.Align;
	import com.panozona.player.module.data.property.Mouse;
	import com.panozona.player.module.data.property.Move;

	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-6-26 下午1:10:56
	 * 功能描述:
	 */
	public class ShowViewItem
	{
		public var align:Align = new Align(Align.LEFT,Align.TOP);
		
		public var move:Move = new Move(0,0);
		
		public var mouse:Mouse= new Mouse();
		
		public var scale:Number= 1;
		
		public var spaceX:Number= 10;
		public var spaceY:Number= 10;
		
		public function ShowViewItem()
		{
		}
	}
}
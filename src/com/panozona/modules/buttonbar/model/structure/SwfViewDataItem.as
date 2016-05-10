package com.panozona.modules.buttonbar.model.structure
{
	import com.panozona.player.module.data.property.Move;

	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-8-20 上午8:45:59
	 * 功能描述:
	 */
	public class SwfViewDataItem
	{
		
		public var id:String;
		
		public var move:Move = new Move(0,0);
		
		public var actionId:String;
		
		public var gap:Number= 5;
		
		public function SwfViewDataItem()
		{
		}
	}
}
package com.panozona.modules.inteltool.data
{
	import com.panozona.common.Ranger;
	import com.panozona.player.module.data.property.Align;
	import com.panozona.player.module.data.property.Move;
	import com.panozona.player.module.data.property.Size;

	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-5-9 下午8:32:59
	 * 功能描述:
	 */
	public class Speaker
	{
		public var path:String;
		public var row:int;
		public var column:int;
		public var interval:Number;
		public var align:Align = new Align(Align.LEFT,Align.TOP);
		public var move:Move = new Move(0,0);
		public var playingFrames:Ranger = new Ranger(0,0);
		public var playFrames:Ranger = new Ranger(0,0);
		public var pauseFrames:Ranger = new Ranger(0,0);
		
		
		public function Speaker()
		{
		}
	}
}
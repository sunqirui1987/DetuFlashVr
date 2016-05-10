package com.panozona.modules.swfobject.data
{
	import com.panozona.player.module.data.property.Align;
	import com.panozona.player.module.data.property.Move;

	public class SwfInfo
	{
		public var path:String;
		public var align:Align = new Align(Align.CENTER, Align.MIDDLE); // horizontal, vertical
		public var move:Move = new Move(0, 0);                       // horizontal, vertical
		
		public function SwfInfo()
		{
		}
	}
}
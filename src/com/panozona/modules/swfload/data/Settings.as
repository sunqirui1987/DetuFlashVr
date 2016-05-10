package com.panozona.modules.swfload.data
{
	import com.panozona.player.module.data.property.Align;
	import com.panozona.player.module.data.property.Move;
	import com.panozona.player.module.data.property.Tween;
	import com.panozona.player.module.data.structure.DataParent;
	import com.robertpenner.easing.*;

	public class Settings 
	{
	
		public var path:String;
		
		public var open:Boolean = true; 
		
		public var onOpen:String;
		
		public var onClose:String;
		
		public var swfwidth:Number = 800;
		
		public var swfheight:Number = 600;
		
		public var swfscalex:Number = 1;
		
		public var swfscaley:Number = 1;
		
		public var index:int = 0;
		
		public var alpha:Number = 0;
		

		
		public var align:Align = new Align(Align.CENTER, Align.MIDDLE); // horizontal, vertical
		public var move:Move = new Move(10, 0);                       // horizontal, vertical
		public var tween:Tween =  new Tween(Linear.easeNone, 0.5);    // transition, time (s)
		
		
	}
}
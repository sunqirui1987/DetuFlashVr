package com.panozona.modules.openhd.data
{
	import com.panozona.modules.openhd.data.StyleContent;
	import com.panozona.player.module.data.property.Tween;
	import com.robertpenner.easing.*;

	public class Settings
	{
		public var alpha:Number=1;
		public var title:String="";
		public var t_x:Number=2;
		public var t_y:Number=20;
		public var leftwidth:Number=200;
		
		public var shucolor:Number=0xcccccc;
		public var shualpha:Number=1;
		
		public var titlestyle:StyleContent=new StyleContent();
		public var detail:String="";
		public var detailstyle:StyleContent=new StyleContent();
		public var d_x:Number=2;
		public var d_y:Number=50;
		
		
		public var swfwidth:Number = 800;
		
		public var swfheight:Number = 600;
		
		public var swfscalex:Number = 1;
		
		public var swfscaley:Number = 1;
		
		
		public var path:String;
		public var open:Boolean = true; 
		public var onOpen:String;	
		public var onClose:String;
		public var tween:Tween =  new Tween(Linear.easeNone, 1);    // transition, time (s)
		
		
	
	}
}
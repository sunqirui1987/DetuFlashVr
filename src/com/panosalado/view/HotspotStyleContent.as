package com.panosalado.view
{
	//ubbleColor:#cccccc,bubblePadding:3,fontFamily:宋体,fontSize:12,fontColor:#000000,fontBold:false,borderSize:1,borderRadius:10,borderColor:#cccccc,alpha:0.7,isdropfilter:true,d_angle:45,d_distance:5,d_alpha:0.5
	public class HotspotStyleContent
	{
		public var bubbleColor:Number = 0xcccccc;
		public var bubblePadding:Number = 3;
		
		public var fontFamily:String = "宋体";
		public var fontSize:Number = 15;
		public var fontColor:Number = 0x000000; // dark grey
		public var fontBold:Boolean = true;
		
		public var borderSize:Number = 0;
		public var borderColor:Number = 0xcccccc;
		public var borderRadius:Number = 0;
		
		public var alpha:Number = 1;
		
		//滤镜
		/*
		var shadow:DropShadowFilter = new DropShadowFilter(); 
		shadow.distance = 10; 
		shadow.angle = 25; 
		
		*/
		public var isdropfilter:Boolean=false;
		public var d_distance:Number=5;
		public var d_angle:Number=45;
		public var d_alpha:Number=1;
		public var d_color:Number=0x000000;
		
	}
}
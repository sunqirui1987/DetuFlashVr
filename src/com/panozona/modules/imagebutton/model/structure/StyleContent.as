/*
 OuWei Flash3DHDView 
*/
package  com.panozona.modules.imagebutton.model.structure{
	import flash.text.TextFormatAlign;
	
	public class StyleContent{
		
		public var bubbleColor:Number = 0x000000;
		public var bubblePadding:Number = 0;
		
		public var fontFamily:String = "Tahoma";
		public var fontSize:Number = 15;
		public var fontColor:Number = 0xffffff; // dark grey
		public var fontBold:Boolean = true;
		
		public var borderSize:Number = 3;
		public var borderColor:Number = 0xffffff;
		public var borderRadius:Number = 15;
		
		public var alpha:Number=1;
		
		public var fontAlign:String = TextFormatAlign.CENTER;
		
		public var backColor:Number = 0xffffff;
		
		public var bgAlpha:Number = 0;
		
		//滤镜
		/*
		var shadow:DropShadowFilter = new DropShadowFilter(); 
		shadow.distance = 10; 
		shadow.angle = 25; 
		 
		*/
		public var isdropfilter:Boolean=false;
		public var d_distance:Number=10;
		public var d_angle:Number=25;
		public var d_alpha:Number=1;
		public var d_color:Number=0x000000;
	}
}
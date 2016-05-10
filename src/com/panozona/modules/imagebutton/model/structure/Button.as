/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.imagebutton.model.structure {
	
	import com.panozona.player.module.data.property.MouseOverOut;
	import com.panozona.player.module.data.structure.DataParent;
	
	public class Button extends DataParent {
		
		override public function getChildrenTypes():Vector.<Class>{
			var result:Vector.<Class> = new Vector.<Class>();
			result.push(Window);
			result.push(SubButtons);
			result.push(HtmlText);
			result.push(TextSize);
			return result;
		}
		
		public var scale:Number = 1;
		
		public var id:String = null;
		
		public var path:String = null;
		
		public var action:String = null;
		
		public var jsaction:String = null;
		
		public var enable:Boolean = true;
		
		public const mouse:MouseOverOut = new MouseOverOut();
		
		public var window:Window;
		
		public var subButtons:SubButtons;
		
		public var panoid:String="";

		public var tipurl:String = "";

		
		public var type:String = null;
		
		public var text:String = null;
		
		public var style:String = null;
		
		public var htmlText:HtmlText = null;
		
		public var textSize:TextSize = new TextSize();
		
		public var pano_xml_for_obj:Object =new Object();

	}
}
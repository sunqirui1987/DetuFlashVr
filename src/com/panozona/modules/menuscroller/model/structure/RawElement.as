/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.menuscroller.model.structure{
	
	import com.panozona.player.module.data.property.MouseOverOut;
	
	public  class RawElement{
		
		public var path:String = null;
		public const mouse:MouseOverOut = new MouseOverOut();
		
		public var text:String = null;
		
		public var style:String = null;
		
		public var pano_xml_for_obj:Object =new Object();
		
		public var action:String = null;
		
	}
}
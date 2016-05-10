/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.buttonbar.model.structure{
	
	import com.panozona.player.module.data.structure.DataParent;
	import com.panozona.player.module.data.property.Align;
	import com.panozona.player.module.data.property.Move;
	import com.panozona.player.module.data.property.Size;
	
	public class Buttons extends DataParent {
		
		public var path:String = null;
		
		public var spacing:Number = 0;
		public var listenKeys:Boolean = false;
		
		override public function getChildrenTypes():Vector.<Class>{
			var result:Vector.<Class> = new Vector.<Class>();
			result.push(Button);
			result.push(ExtraButton);
			return result;
		}
	}
}
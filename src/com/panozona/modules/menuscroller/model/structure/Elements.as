/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.menuscroller.model.structure{
	
	import com.panozona.player.module.data.structure.DataParent;
	
	public class Elements extends DataParent {
		
		override public function getChildrenTypes():Vector.<Class>{
			var result:Vector.<Class> = new Vector.<Class>();
			result.push(Element);
			result.push(ExtraElement);
			return result;
		}
	}
}
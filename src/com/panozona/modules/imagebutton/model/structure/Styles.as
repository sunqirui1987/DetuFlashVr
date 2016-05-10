/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.imagebutton.model.structure{
	
	import com.panozona.player.module.data.structure.DataParent;
	
	public class Styles extends DataParent{
		
		override public function getChildrenTypes():Vector.<Class>{
			var result:Vector.<Class> = new Vector.<Class>();
			result.push(Style);
			return result;
		}
	}
}
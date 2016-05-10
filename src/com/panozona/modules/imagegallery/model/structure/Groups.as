/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.imagegallery.model.structure {
	
	import com.panozona.player.module.data.structure.DataParent;
	
	public class Groups extends DataParent {
		
		override public function getChildrenTypes():Vector.<Class> {
			var result:Vector.<Class> = new Vector.<Class>();
			result.push(Group);
			return result;
		}
	}
}
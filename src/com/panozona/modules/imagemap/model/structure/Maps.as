/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.imagemap.model.structure{
	
	import com.panozona.player.module.data.structure.DataParent;
	
	public class Maps extends DataParent{
		
		override public function getChildrenTypes():Vector.<Class>{
			var result:Vector.<Class> = new Vector.<Class>();
			result.push(Map);
			return result;
		}
	}
}
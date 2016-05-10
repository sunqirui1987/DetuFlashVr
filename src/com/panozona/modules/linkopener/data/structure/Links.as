/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.linkopener.data.structure{
	
	import com.panozona.player.module.data.structure.DataParent;
	
	public class Links extends DataParent{
		
		override public function getChildrenTypes():Vector.<Class>{
			var result:Vector.<Class> = new Vector.<Class>();
			result.push(Link);
			return result;
		}
	}
}
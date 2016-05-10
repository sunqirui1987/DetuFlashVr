/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.jsgateway.data.structure {
	
	import com.panozona.player.module.data.structure.DataParent;
	
	public class ASFunctions extends DataParent{
		
		override public function getChildrenTypes():Vector.<Class>{
			var result:Vector.<Class> = new Vector.<Class>();
			result.push(ASFunction);
			return result;
		}
	}
}
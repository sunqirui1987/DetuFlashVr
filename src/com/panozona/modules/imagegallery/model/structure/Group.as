/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.imagegallery.model.structure {
	
	import com.panozona.player.module.data.structure.DataParent;
	
	public class Group extends DataParent {
		
		public var id:String = null;
		
		override public function getChildrenTypes():Vector.<Class>{
			var result:Vector.<Class> = new Vector.<Class>();
			result.push(Image);
			return result;
		}
	}
}
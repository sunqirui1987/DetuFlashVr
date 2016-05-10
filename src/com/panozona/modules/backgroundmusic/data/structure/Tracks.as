/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.backgroundmusic.data.structure{
	
	import com.panozona.player.module.data.structure.DataParent;
	
	public class Tracks extends DataParent{
		
		override public function getChildrenTypes():Vector.<Class>{
			var result:Vector.<Class> = new Vector.<Class>();
			result.push(Track);
			return result;
		}
	}
}
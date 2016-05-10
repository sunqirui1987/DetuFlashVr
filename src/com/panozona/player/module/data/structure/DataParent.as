/*
 OuWei Flash3DHDView 
*/
package com.panozona.player.module.data.structure{
	
	public class DataParent{
		
		protected const _children:Array = new Array();
		
		public final function getChildrenOfGivenClass(childClass:Class):Array {
			var result:Array = new Array;
			for each (var child:Object in _children) {
				if (child is childClass) result.push(child);
			}
			return result;
		}
		
		public final function getAllChildren():Array {
			return _children;
		}
		
		public function getChildrenTypes():Vector.<Class> {
			throw new Error("You must override getChildrenTypes()");
		}
	}
}
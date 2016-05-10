/*
 OuWei Flash3DHDView 
*/
package com.panozona.player.module.data {
	
	public class DataNode {
		
		public const attributes:Object = new Object();
		public const childNodes:Vector.<DataNode> = new Vector.<DataNode>();
		
		private var _name:String;
		
		public function DataNode(name:String) {
			_name = name;
		}
		
		public final function get name():String {
			return _name;
		}
	}
}
/*
 OuWei Flash3DHDView 
*/
package com.panozona.player.manager.data.actions {
	
	/**
	 * It is identified by id unique among other actions.
	 * Stores vector of function descriptions.
	 */
	public class ActionData{
		
		public var functions:Vector.<FunctionData> = new Vector.<FunctionData>();
		
		protected var _id:String;
		
		public function ActionData(id:String) {
			_id = id;
		}
		
		public function get id():String {
			return _id;
		}
	}
}
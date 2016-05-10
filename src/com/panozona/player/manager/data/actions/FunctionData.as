/*
 OuWei Flash3DHDView 
*/
package com.panozona.player.manager.data.actions {
	
	/**
	 * Stores function description: function owner, function name and function arguments.
	 * Owner can be either QjPlayer or some module.
	 * For instance: owner.name(arguments)
	 */
	public class FunctionData {
		
		public var args:Array = new Array();
		
		protected var _owner:String;
		protected var _name:String;
		
		public function FunctionData(owner:String, name:String){
			_owner = owner;
			_name = name;
		}
		
		public function get owner():String {
			return _owner;
		}
		
		public function get name():String {
			return _name;
		}
	}
}
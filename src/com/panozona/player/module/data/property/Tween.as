/*
 OuWei Flash3DHDView 
*/
package com.panozona.player.module.data.property{
	
	public class Tween {
		
		private var _transition:Function;
		private var _time:Number;
		
		public function Tween(transition:Function, time:Number){
			_transition = transition;
			_time = time;
		}
		
		/**
		 * Null value is discarded.
		 */
		public final function get transition():Function {
			return _transition;
		}
		
		/**
		* @private
		*/
		public final function set transition(value:Function):void {
			if (value == null) return;
			_transition = value;
		}
		
		/**
		 * Value less than 0 is discarded.
		 */
		public final function get time():Number{
			return _time;
		}
		
		/**
		* @private
		*/
		public final function set time(value:Number):void {
			if (value < 0) return;
			_time = value;
		}
	}
}
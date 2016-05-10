/*
 OuWei Flash3DHDView 
*/
package com.panozona.player.module.data.property{
	
	public class Transition{
		
		public static const FADE:String = "fade";
		public static const SLIDE_UP:String = "slideUp";
		public static const SLIDE_DOWN:String = "slideDown";
		public static const SLIDE_LEFT:String = "slideLeft";
		public static const SLIDE_RIGHT:String = "slideRight";
		
		public static const SLIDE_RIGHT_DOWN:String = "slideRightDown";
		
		private var _type:String;
		
		public function Transition(value:String){
			this.type = value;
		}
		
		public final function get type():String {
			return _type;
		}
		
		public final function set type(value:String):void{
			if (value == Transition.FADE || value == Transition.SLIDE_UP
				|| value == Transition.SLIDE_DOWN || value == Transition.SLIDE_LEFT
				|| value == Transition.SLIDE_RIGHT || value == Transition.SLIDE_RIGHT_DOWN) {
				_type = value;
			}else {
				throw new Error("Unrecognized transition value: " + value);
			}
		}
	}
}
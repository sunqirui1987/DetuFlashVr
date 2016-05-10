/*
 OuWei Flash3DHDView 
*/
package com.panozona.player.module.data.property{
	
	public class Align {
		
		public static const RIGHT:String = "right";
		public static const LEFT:String = "left";
		public static const CENTER:String = "center";
		
		public static const BOTTOM:String = "bottom";
		public static const TOP:String = "top";
		public static const MIDDLE:String = "middle";
		
		private var _horizontal:String;
		private var _vertical:String;
		
		public function Align(defaultHorizontal:String, defaultVertical:String) {
			horizontal = defaultHorizontal;
			vertical = defaultVertical;
		}
		
		public final function set horizontal(value:String):void {
			if (value == Align.RIGHT || value == Align.LEFT || value == Align.CENTER) {
				_horizontal = value;
			}else {
				throw new Error("Unrecognized horizontal value: " + value);
			}
		}
		
		public final function get horizontal():String {
			return _horizontal;
		}
		
		public final function set vertical(value:String):void {
			if (value == Align.BOTTOM || value == Align.TOP || value == Align.MIDDLE) {
				_vertical = value;
			}else {
				throw new Error("Unrecognized vertical value: " + value);
			}
		}
		
		public final function get vertical():String {
			return _vertical;
		}
	}
}
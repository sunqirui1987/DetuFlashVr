/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.viewfinder.data {
	
	import com.panozona.player.module.data.property.Align;
	import com.panozona.player.module.data.property.Move;
	
	public class Settings{
		
		public const align:Align = new Align(Align.LEFT, Align.TOP);
		
		public const move:Move = new Move(0, 0);
		
		public var showDirection:Boolean = true;
		
		public var useCursor:Boolean = false;
		
		public var isShow:Boolean = true;
		
		public var isCircle:Boolean = true;
		
		public var qcolor:Number=0xFFFF00;
	}
}
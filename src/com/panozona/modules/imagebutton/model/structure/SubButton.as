/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.imagebutton.model.structure {
	
	import com.panozona.player.module.data.property.MouseOverOut;
	import com.panozona.player.module.data.property.Move;
	
	public class SubButton {
		
		public var id:String = null;
		public var path:String = null;
		
		public var action:String = null;
		
		public const mouse:MouseOverOut = new MouseOverOut();
		public const move:Move = new Move(0, 0);
		
		public var singleState:Boolean = false;
	}
}
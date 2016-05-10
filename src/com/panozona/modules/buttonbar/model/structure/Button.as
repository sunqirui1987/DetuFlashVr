/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.buttonbar.model.structure{
	
	import com.panozona.player.module.data.property.MouseOverOut;
	import com.panozona.player.module.data.property.Move;
	
	public class Button{
		
		public var name:String = null;
		public const move:Move = new Move(NaN, NaN);
		public const mouse:MouseOverOut = new MouseOverOut();
		public var tipurl:String = "";
	}
}
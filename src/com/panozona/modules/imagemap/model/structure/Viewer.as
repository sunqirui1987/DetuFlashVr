/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.imagemap.model.structure{
	import com.panozona.player.module.data.property.Align;
	import com.panozona.player.module.data.property.Move;
	
	public class Viewer {
		
		public var path:String = null; // path to navigation bitmaps grid
		
		public var moveEnabled:Boolean = true;
		public var moveSpeed:Number = 10;
		public var zoomEnabled:Boolean = true;
		public var zoomSpeed:Number = 0.03;
		public var scrollEnabled:Boolean = true;
		public var dragEnabled:Boolean = true;
		public var autofocusEnabled:Boolean = true;
		
		public var align:Align = new Align(Align.LEFT,Align.TOP);
		public var move:Move = new Move(0,0);
		public var scrollsVertical:Boolean = false;
	}
}
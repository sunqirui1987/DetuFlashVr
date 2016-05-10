/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.menuscroller.model.structure {
	
	import com.panozona.player.module.data.property.Tween;
	
	import caurina.transitions.Equations;
	
	public class Scroller {
		
		public var scrollsVertical:Boolean = true;
		public var sizeLimit:Number = 150;
		public var spacing:Number = 10;
		public var isselected:Boolean=true;
		
		public var maskPadding:Number = 0;
		
		public var mouseOver:Expand = new Expand(Equations.easeNone, 0.25, 1.2);
		public var mouseOut:Tween = new Tween(Equations.easeNone, 0.25);
		
		public var boundMaskSize:Number = 100;
		
		public var ratios:String = "120,255";
		
		public var topBorder:BorderStyle = new BorderStyle();
		public var bottomBorder:BorderStyle = new BorderStyle();
		
		public var isClickItemHide:Boolean;
	}
}
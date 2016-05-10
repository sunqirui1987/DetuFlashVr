/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.panolink.model.structure{
	
	import caurina.transitions.Equations;
	import com.panozona.player.module.data.property.Align;
	import com.panozona.player.module.data.property.Move;
	import com.panozona.player.module.data.property.Transition;
	import com.panozona.player.module.data.property.Tween;
	
	public class Window {
	
		public var alpha:Number = 1;
		
		public var align:Align = new Align(Align.RIGHT, Align.TOP);
		public var move:Move = new Move(-20, 20);
		
		public var open:Boolean = false;
		public var onOpen:String = null;
		public var onClose:String = null;
		
		public var openTween:Tween = new Tween(Equations.easeNone, 0.5);
		public var closeTween:Tween = new Tween(Equations.easeNone, 0.5);
		public var transition:Transition = new Transition(Transition.SLIDE_UP);
	}
}
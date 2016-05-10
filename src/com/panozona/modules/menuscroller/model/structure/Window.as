/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.menuscroller.model.structure {
	
	import com.panozona.player.module.data.property.Align;
	import com.panozona.player.module.data.property.Move;
	import com.panozona.player.module.data.property.Size;
	import com.panozona.player.module.data.property.Transition;
	import com.panozona.player.module.data.property.Tween;
	
	import caurina.transitions.Equations;
	
	public class Window{
		
		public const align:Align = new Align(Align.LEFT, Align.MIDDLE);
		public const move:Move = new Move(0, 0);
		public const size:Size = new Size(200, NaN);
		
		public var color:Number = 0x000000;
		public var alpha:Number = 0.75;
		
		public var open:Boolean = true;
		public var onOpen:String = null;
		public var onClose:String = null;
		
		public const openTween:Tween = new Tween(Equations.easeNone, 0.5);
		public const closeTween:Tween = new Tween(Equations.easeNone, 0.5);
		public const transition:Transition = new Transition(Transition.SLIDE_LEFT);
		
		public var isAutoHide:Number=0;
	}
}
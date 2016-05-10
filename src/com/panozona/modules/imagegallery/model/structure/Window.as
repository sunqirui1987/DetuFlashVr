/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.imagegallery.model.structure{
	
	import caurina.transitions.Equations;
	import com.panozona.player.module.data.property.Align;
	import com.panozona.player.module.data.property.Move;
	import com.panozona.player.module.data.property.Size;
	import com.panozona.player.module.data.property.Margin;
	import com.panozona.player.module.data.property.Transition;
	import com.panozona.player.module.data.property.Tween;
	
	public class Window {
		
		public const align:Align = new Align(Align.CENTER, Align.MIDDLE);
		public const margin:Margin = new Margin(20, 20, 20, 20);
		public const minSize:Size = new Size(300, 200);
		public const maxSize:Size = new Size(800, 600);
		
		public var alpha:Number = 1.0;
		
		public var open:Boolean = true;
		public var onOpen:String = null;
		public var onClose:String = null;
		
		public const openTween:Tween = new Tween(Equations.easeNone, 0.5);
		public const closeTween:Tween = new Tween(Equations.easeNone, 0.5);
		public const transition:Transition = new Transition(Transition.FADE);
	}
}
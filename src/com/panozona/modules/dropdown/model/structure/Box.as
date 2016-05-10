/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.dropdown.model.structure{
	
	import caurina.transitions.Equations;
	import com.panozona.player.module.data.property.Tween;
	
	public class Box{
		
		public var opensUp:Boolean = true;
		public const style:Style = new Style();
		
		public const unfoldTween:Tween = new Tween(Equations.easeNone, 0.25);
		public const foldTween:Tween = new Tween(Equations.easeNone, 0.25);
	}
}
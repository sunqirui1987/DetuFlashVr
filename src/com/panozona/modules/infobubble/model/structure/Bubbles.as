/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.infobubble.model.structure {
	
	import caurina.transitions.Equations;
	import com.panozona.player.module.data.property.Tween;
	import com.panozona.player.module.data.structure.DataParent;
	
	public class Bubbles extends DataParent {
		
		public var showTween:Tween = new Tween(Equations.easeNone, 0.25);
		public var hideTween:Tween = new Tween(Equations.easeNone, 0.25);
		
		override public function getChildrenTypes():Vector.<Class>{
			var result:Vector.<Class> = new Vector.<Class>();
			result.push(Image);
			result.push(Text);
			return result;
		}
	}
}
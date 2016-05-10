/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.menuscroller.model.structure{
	
	import com.panozona.player.module.data.property.Tween;
	
	public class Expand extends Tween{
		
		public var scale:Number;
		
		public function Expand(transition:Function, time:Number, scale:Number):void {
			super(transition, time);
			this.scale = scale;
		}
	}
}
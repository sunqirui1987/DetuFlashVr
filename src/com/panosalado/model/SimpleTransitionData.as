
package com.panosalado.model{
	
	import com.robertpenner.easing.*;
	
	public class SimpleTransitionData {
		
		public var tween:Function;
		public var time:Number;
		public var property:String;
		public var startValue:Number;
		public var endValue:Number
		
		public function SimpleTransitionData() {
			tween = Linear.easeNone;
			time = 0.5;
			property = "alpha";
			startValue = 0.1;
			endValue = 1;
		}
	}
}
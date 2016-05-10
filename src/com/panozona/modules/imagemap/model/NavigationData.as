/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.imagemap.model {
	
	import com.panozona.modules.imagemap.events.NavigationEvent;
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	
	public class NavigationData extends EventDispatcher{
		
		public var onPress:Function;
		public var onRelease:Function;
		
		private var _isActive:Boolean;
		
		public function NavigationData(onPress:Function, onRelease:Function):void {
			super();
			this.onPress = onPress;
			this.onRelease = onRelease;
		}
		
		public function get isActive():Boolean { return _isActive; }
		public function set isActive(value:Boolean):void {
			if (value == _isActive) return;
			_isActive = value;
			dispatchEvent(new NavigationEvent(NavigationEvent.CHANGED_IS_ACTIVE));
		}
	}
}
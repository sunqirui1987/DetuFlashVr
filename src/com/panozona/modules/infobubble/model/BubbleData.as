/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.infobubble.model{
	
	import com.panozona.modules.infobubble.events.BubbleEvent;
	import flash.events.EventDispatcher;
	
	public class BubbleData extends EventDispatcher {
		
		private var _currentId:String;
		private var _isShowing:Boolean;
		private var _enabled:Boolean;
		
		public function get currentId():String {return _currentId;}
		public function set currentId(value:String):void {
			if (value == null || value == _currentId) return;
			_currentId = value;
			dispatchEvent(new BubbleEvent(BubbleEvent.CHANGED_CURRENT_ID));
		}
		
		public function get isShowing():Boolean {return _isShowing;}
		public function set isShowing(value:Boolean):void {
			if (value == _isShowing) return;
			_isShowing = value;
			dispatchEvent(new BubbleEvent(BubbleEvent.CHANGED_IS_SHOWING));
		}
		
		public function get enabled():Boolean {return _enabled;}
		public function set enabled(value:Boolean):void {
			if (value == _enabled) return;
			_enabled = value;
			dispatchEvent(new BubbleEvent(BubbleEvent.CHANGED_ENABLED));
		}
	}
}
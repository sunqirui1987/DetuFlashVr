
package com.panosalado.model{
	
	import com.panosalado.events.CameraEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class ArcBallCameraData extends EventDispatcher {
		
		public var sensitivity:Number;
		
		/**
		* friction of camera after mouse is up
		*/
		public var friction:Number;
		
		/**
		* camera pan / tilt threshold at which motion jumps to 0
		*/
		public var threshold:Number;
		
		public var _enabled:Boolean;
		
		public function ArcBallCameraData() {
			sensitivity = 0.0025;
			friction = 0.1;
			threshold = 0.0001;
			_enabled = false;
		}
		
		public function get enabled():Boolean { return _enabled;}
		public function set enabled(value:Boolean):void {
			if (value == _enabled) return;
			_enabled = value;
			dispatchEvent( new Event(CameraEvent.ENABLED_CHANGE));
		}
	}
}
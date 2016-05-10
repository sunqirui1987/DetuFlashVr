
package com.panosalado.model{
	
	import com.panosalado.events.CameraEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	final public class KeyboardCameraData extends EventDispatcher {
		
		/**
		* sensitivity of keyboard
		*/
		public var sensitivity:Number;
		
		/**
		* friction of camera after mouse is up
		*/
		public var friction:Number;
		
		/**
		* delta pan and tilt value that will be used for key movement
		*/
		public var directionSpeed:Number;
		
		/**
		* delta zoom value that will be used for key zooming
		*/
		public var zoomSpeed:Number;
		
		public var _enabled:Boolean;
		
		public function KeyboardCameraData() {
			friction = 0.25;
			sensitivity = 0.5;
			
			directionSpeed = 1.8;
			zoomSpeed = 1.5;
			
			enabled = true;
		}
		
		public function get enabled():Boolean { return _enabled;}
		public function set enabled(value:Boolean):void {
			if (value == _enabled) return;
			_enabled = value;
			dispatchEvent(new Event(CameraEvent.ENABLED_CHANGE));
		}
	}
}
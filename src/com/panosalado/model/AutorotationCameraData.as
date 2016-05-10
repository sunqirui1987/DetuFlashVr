
package com.panosalado.model{
	
	import com.panosalado.events.AutorotationEvent;
	import com.panosalado.events.CameraEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class AutorotationCameraData extends EventDispatcher {
		
		public static const SPEED:String = "speed";
		public static const FRAME_INCREMENT:String = "frameIncrement";
		
		/**
		* delay in miliseconds before autorotation starts
		*/
		public var delay:int;
		
		/**
		* takes "speed" or "frameIncrement"
		*/
		public var mode:String;
		
		/**
		* in degrees per second
		*/
		public var speed:Number;
		
		/**
		* autorotation field of view
		*/
		public var fov:Number;
		
		/**
		* autorotation tilt
		*/
		public var tilt:Number;
		
		/**
		* in degress per frame
		*/
		public var frameIncrement:Number 
		
		protected var _isAutorotating:Boolean;
		
		protected var _enabled:Boolean;
		
		public var autoToNextRotation:Number = 0;
		
		public function AutorotationCameraData() {
			delay = 60;
			mode = AutorotationCameraData.SPEED;
			speed = 5;
			fov = 90;
			tilt = 0;
			frameIncrement = 0.0333;
			_enabled = true;
			_isAutorotating = false;
		}
		
		public function get isAutorotating():Boolean { return _isAutorotating;}
		public function set isAutorotating(value:Boolean):void {
			if (value == _isAutorotating) return;
			_isAutorotating = value;
			dispatchEvent( new Event(AutorotationEvent.AUTOROTATION_CHANGE));
		}
		
		/**
		* Changing this value dispatches CameraEvent.ENABLED_CHANGE
		* Setting it to false disables autorotation completely.
		*/
		public function get enabled():Boolean { return _enabled;}
		public function set enabled(value:Boolean):void {
			if (value == _enabled) return;
			_enabled = value;
			dispatchEvent( new Event(CameraEvent.ENABLED_CHANGE));
		}
	}
}
/*
OuWei Flash3DHDView 
*/
package com.panozona.player.manager.events {

	import flash.display.DisplayObject;
	import flash.events.Event;
	
	public class PanoSoundEvent extends Event {
		
		public static const SOUNDCHANGE:String = "soundchange";
		

		//open  stop
		public var state:String;
		public var targetsource:String;

		public function PanoSoundEvent(eventType:String,state:String , targetsource:String ) {
			super(eventType);
			this.state = state;
			this.targetsource = targetsource;
		}
	}
}



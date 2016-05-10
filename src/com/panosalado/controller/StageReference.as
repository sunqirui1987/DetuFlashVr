
package com.panosalado.controller{
	
	import com.panosalado.model.Characteristics;
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	/* 
	implemented with Dictionary, instead of LinkedList, or Vector, or Array, because 
	weak-keyed dictionary will not require removal of notification targets for them to 
	become eligible for garbage collection. 
	*/
	public dynamic class StageReference extends Dictionary{
		protected var stage:Stage;
		
		public function StageReference(weakKeys:Boolean = true):void{
			super(weakKeys);
		}
		
		public function processDependency(reference:Object,characteristics:*):void { 
			if (characteristics == Characteristics.VIEW_DATA) {
				(reference as EventDispatcher).addEventListener(Event.ADDED_TO_STAGE, notify, false, 0, true);
				(reference as EventDispatcher).addEventListener(Event.REMOVED_FROM_STAGE, notify, false, 0, true);
			}
		}
		
		public function addNotification(object:*, property:String = "stageReference"):void {
			if (object == null) return;
			if (!object.hasOwnProperty(property)) return;
			this[object] = property;
			if (stage != null) object[property] = stage;
		}
		
		public function removeNotification(object:*, property:String = "stageReference"):void {
			if (object == null) return;
			delete this[property];
		}
		
		protected function notify(e:Event):void{
			switch(e.type) {
				case Event.ADDED_TO_STAGE:
					stage = (e.target as DisplayObject).stage;
					break;
				case Event.REMOVED_FROM_STAGE:
					stage = null;
					break;
				default: return;
			}
			var object:*;
			var property:String;
			for (object in this) {
				property = this[object] as String;
				object[property] = stage;
			}
		}
	}
}

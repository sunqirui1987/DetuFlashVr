
package com.panosalado.controller{
	
	import flash.utils.Dictionary;
	
	public dynamic class DependencyRelay extends Dictionary{
		public var callbacks:Dictionary;
		
		public function DependencyRelay(weakKeys:Boolean = true) {
			callbacks = new Dictionary(weakKeys);
			super(weakKeys);
		}
		
		public function addDependency(object:*, characteristics:* = null):void {
			/* workaround to overcome flashplayer bug which doesn't allow string properties in Dictionaries with "illegal" characters */
			if (object is String) object = new StringSmuggler(object as String);
			/* end of workaround */
			this[object] = characteristics;
			for (var callback:* in callbacks) {
				/* workaround for flashplayer bug */
				if (object is StringSmuggler) object = object.string;
				/* end of workaround */
				(callback as Function).call(null, object, characteristics);
			}
		}
		
		public function removeDependency(object:*):void {
			delete this[object];
		}
		
		public function addCallback(callback:Function):void {
			callbacks[callback] = null;
			for (var dependency:* in this) {
				/* workaround for flashplayer bug */
				if (dependency is StringSmuggler) dependency = dependency.string;
				/* end of workaround */
				callback.call(null, dependency, this[dependency]);
			}
		}
		
		public function removeCallback(callback:Function):void {
			delete callbacks[callback];
		}
	}
}

class StringSmuggler{
	public var string:String;
	public function StringSmuggler(str:String) {
		string = str;
	}
}
/*
 OuWei Flash3DHDView 
*/
package com.panozona.player.manager.events {
	
	import com.panozona.player.manager.utils.loading.ILoadable;
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	public class LoadLoadableEvent extends Event {
		
		public static const LOADED:String = "loadableLoaded";
		public static const LOST:String = "loadableLost";
		public static const FINISHED:String = "allLoadablesLoaded";
		public static const ABORTED:String = "loadablesAborted";
		
		public var loadable:ILoadable;
		public var content:DisplayObject;
		
		public function LoadLoadableEvent(eventType:String, loadable:ILoadable = null, content:DisplayObject = null) {
			super(eventType);
			this.loadable = loadable;
			this.content = content;
		}
	}
}
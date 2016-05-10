/*
 OuWei Flash3DHDView 
*/
package com.panozona.viewer {
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	/**
	 * This file is part of examples viewer.
	 * It is simple standalone *.swf that is used to obtain xml files on local computer
	 * from relative paths from higher levels (as ajax cannot do this)
	 */
	public class ExamplesLoader extends Sprite{
		
		public function ExamplesLoader(){
			if (stage) stageReady();
			else addEventListener(Event.ADDED_TO_STAGE, stageReady, false, 0, true);
		}
		
		private function stageReady(e:Event = null):void{
			removeEventListener(Event.ADDED_TO_STAGE, stageReady);
			var xmlLoader:URLLoader = new URLLoader();
			xmlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, configurationLost);
			xmlLoader.addEventListener(Event.COMPLETE, configurationLoaded);
			xmlLoader.load(new URLRequest(loaderInfo.parameters.xml));
			trace(loaderInfo.parameters.xml)
		}
		
		private function configurationLost(event:IOErrorEvent):void {
			event.target.removeEventListener(IOErrorEvent.IO_ERROR, configurationLost);
			event.target.removeEventListener(Event.COMPLETE, configurationLoaded);
			ExternalInterface.call("onLoaded", "Failed to load file.");
		}
		
		protected function configurationLoaded(event:Event):void {
			event.target.removeEventListener(IOErrorEvent.IO_ERROR, configurationLost);
			event.target.removeEventListener(Event.COMPLETE, configurationLoaded);
			var input:ByteArray = event.target.data;
			try { input.uncompress(); } catch (error:Error) { }
			ExternalInterface.call("onLoaded", input.toString());
		}
	}
}
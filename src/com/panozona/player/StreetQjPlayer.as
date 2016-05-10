package com.panozona.player
{
	import com.panozona.player.manager.StreetManager;
	import com.panozona.player.manager.events.ConfigurationEvent;
	import com.panozona.player.manager.events.LoadLoadableEvent;
	import com.panozona.player.manager.utils.configuration.ManagerDataParserXML;
	import com.panozona.player.manager.utils.loading.ILoadable;
	import com.panozona.player.manager.utils.loading.UrlLoadablesLoader;
	import com.panozona.player.module.global;
	import com.spikything.utils.URL;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;

	public class StreetQjPlayer extends QjPlayer
	{
		public function StreetQjPlayer()
		{
			super();
		}
		override protected function configurationLoaded(event:Event):void {
			
			event.target.removeEventListener(IOErrorEvent.IO_ERROR, configurationLost);
			event.target.removeEventListener(Event.COMPLETE, configurationLoaded);
			var input:ByteArray = event.target.data;
			try {input.uncompress();} catch (error:Error) {}
			var settings:XML;
			var str:String = input.toString().replace(/~/gm, loaderInfo.parameters.tilde ? loaderInfo.parameters.tilde : "");
			try {
				settings = XML(str);
			}catch (error:Error) {
				
				addChild(traceWindow);
				traceWindow.printError("加载文件结构出错: " + error.message);
				return;
			}
			
			manager = new StreetManager();

			this.managerData.isstreetviewModel = true;
			
			var managerDataParserXML:ManagerDataParserXML = new ManagerDataParserXML();
			managerDataParserXML.addEventListener(ConfigurationEvent.INFO, printConfigurationMessage, false, 0, true);
			managerDataParserXML.addEventListener(ConfigurationEvent.WARNING, printConfigurationMessage, false, 0, true);
			managerDataParserXML.addEventListener(ConfigurationEvent.ERROR, printConfigurationMessage, false, 0, true);
			managerDataParserXML.configureManagerData(managerData, settings);
			
			
			
			addChild(manager);
			
			
			
			
			var modulesLoader:UrlLoadablesLoader = new UrlLoadablesLoader();
			modulesLoader.addEventListener(LoadLoadableEvent.LOST, moduleLost);
			modulesLoader.addEventListener(LoadLoadableEvent.LOADED, moduleLoaded);
			modulesLoader.addEventListener(LoadLoadableEvent.FINISHED, modulesFinished);
			modulesLoader.load(Vector.<ILoadable>(managerData.modulesData));
			
			
			
		}
	}
}
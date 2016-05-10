
package com.panozona.player.module{
	
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.utils.ModuleDescription;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;
	
	public class Module extends Sprite {
		
		protected var functionDataClass:Class;
		
		private var _qjPlayer:Object;
		private var _moduleDescription:ModuleDescription;
		
		/**
		 * Constructor creates moduleDescription instance and performs, and performs stage ready check.
		 * Once Module is added to stage it sets reference to QjPlayer and calls moduleReady function 
		 * with argument of ModuleData object containing configuration data.
		 * @param	moduleName
		 * @param	moduleVersion
		 * @param	homeUrl
		 */
		public function Module(moduleName:String, moduleVersion:String, homeUrl:String) {
			_moduleDescription = new ModuleDescription(moduleName, moduleVersion, homeUrl);
			if (stage) stageReady();
			else addEventListener(Event.ADDED_TO_STAGE, stageReady, false, 0, true);
		}
		
		private function stageReady(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, stageReady);
			var _moduleData:ModuleData;
			try {
				functionDataClass = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.data.actions.FunctionData") as Class;
				var QjPlayerClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.QjPlayer") as Class;
				_qjPlayer = this.parent.parent.parent as QjPlayerClass;
				_moduleData = _qjPlayer.managerData.getModuleDataByName(_moduleDescription.name) as ModuleData;
			}catch (error:Error) {
				trace(error.message);
				trace(error.getStackTrace());
			}
			try {
				_qjPlayer.traceWindow.printLink(_moduleDescription.homeUrl, _moduleDescription.name + " " + _moduleDescription.version);
				moduleReady(_moduleData);
			}catch (error:Error) {
				printError(error.message);
				trace(error.message);
				trace(error.getStackTrace());
			}
		}
		
		/**
		 * This function has to be overriden by Module descendant. 
		 * At the point when this function is called, module is allready constructed
		 * added to stage and QjPlayer reference is ready to be used.
		 * @param	moduleData
		 */
		protected function moduleReady(moduleData:ModuleData):void {
			throw new Error("Function moduleReady() must be overriden.");
		}
		
		public function execute(functionData:Object):void {
			if(functionData is functionDataClass && _moduleDescription.functionsDescription.hasOwnProperty(functionData.name)) {
				(this[functionData.name] as Function).apply(this, functionData.args);
			}
		}
		
		public final function  ifcheck(obj:Object):Boolean
		{
			if(obj.hasOwnProperty("pano_xml_for_obj") == true)
			{
				
				for(var name:* in obj["pano_xml_for_obj"])
				{
					var val:* = obj["pano_xml_for_obj"][name];
					var panoname:String = String(name).replace("pano_xml_for_","");
	
					//一但不等于则返回false
					if(_qjPlayer.manager.currentPanoramaData.xmlobj[panoname])
					{
						var isfind:Boolean = false;
						var valarr:Array = String(val).split("|");
						for each(var gval:String in valarr)
						{
							if(_qjPlayer.manager.currentPanoramaData.xmlobj[panoname] == gval)
							{
								isfind = true;
								break;
							}
						}
						
						if(isfind == false)
						{
							return false;
						}
						
						
					}
				}
			}
			else
			{
				return true;
			}
			
			return true;
		}
		
		/**
		 * QjPlayer reference avaible since moduleReady is called.
		 */
		public final function get qjPlayer():Object {
			return _qjPlayer;
		}
		
		/**
		 * Alter module description by adding descriptions of exposed functions.
		 * Exposed function will be recognized by QjPlayer validator. 
		 * Module description can be modified only in constructor.
		 */
		public final function get moduleDescription():ModuleDescription{
			return _moduleDescription;
		}
		
		/**
		 * Prints message in green text in trace window.
		 * Printing "info" does not trigger trace window open.
		 * @param message
		 */
		public final function printInfo(message:String):void {
			_qjPlayer.traceWindow.printInfo(_moduleDescription.name + ": " + message);
		}
		
		/**
		 * Prints message in yellow text in trace window.
		 * Printing warning triggers trace window open.
		 * @param message
		 */
		public final function printWarning(message:String):void {
			_qjPlayer.traceWindow.printWarning(_moduleDescription.name + ": " + message);
		}
		
		 /**
		 * Prints message in red text in trace window.
		 * Printing error triggers trace window open.
		 * @param message
		 */
		public final function printError(message:String):void {
			_qjPlayer.traceWindow.printError(_moduleDescription.name + ": " + message);
		}
	}
}
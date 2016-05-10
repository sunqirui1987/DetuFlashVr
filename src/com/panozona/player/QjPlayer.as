
package com.panozona.player {
	

	import com.ouwei.common.global;
	import com.panosalado.controller.ArcBallCamera;
	import com.panosalado.controller.AutorotationCamera;
	import com.panosalado.controller.ICamera;
	import com.panosalado.controller.IResizer;
	import com.panosalado.controller.InertialMouseCamera;
	import com.panosalado.controller.KeyboardCamera;
	import com.panosalado.controller.Nanny;
	import com.panosalado.controller.Resizer;
	import com.panosalado.controller.ScrollCamera;
	import com.panosalado.controller.SimpleTransition;
	import com.panosalado.controller.StageReference;
	import com.panosalado.model.DeepZoomTilePyramid;
	import com.panosalado.view.Panorama;
	import com.panozona.player.manager.Manager;
	import com.panozona.player.manager.ModuleLayer;
	import com.panozona.player.manager.taobao;
	import com.panozona.player.manager.actionCode.Actioncode;
	import com.panozona.player.manager.data.ManagerData;
	import com.panozona.player.manager.events.ConfigurationEvent;
	import com.panozona.player.manager.events.LoadLoadableEvent;
	import com.panozona.player.manager.taobao.Service;
	import com.panozona.player.manager.utils.ContextMenus;
	import com.panozona.player.manager.utils.Trace;
	import com.panozona.player.manager.utils.configuration.ManagerDataParserFlashvars;
	import com.panozona.player.manager.utils.configuration.ManagerDataParserXML;
	import com.panozona.player.manager.utils.configuration.ManagerDataValidator;
	import com.panozona.player.manager.utils.loading.ILoadable;
	import com.panozona.player.manager.utils.loading.UrlLoadablesLoader;
	import com.panozona.player.module.Module;
	import com.panozona.player.module.global;
	import com.panozona.player.module.data.ModuleData;
	import com.spikything.utils.MouseWheelTrap;
	import com.spikything.utils.URL;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.Security;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	[SWF(width="500", height="375", frameRate="30")] // default size is MANDATORY
	
	public class QjPlayer extends Sprite {
		
		/**
		 * Instance of main class that extends PanoSalado.
		 */
		public var manager:Manager = new Manager();
		
		/**
		 * Instance of class that aggregates and stores configuration data.
		 */
		public var managerData:ManagerData = new ManagerData();
		
		/**
		 * Instance of Trace window. Trace can alsa be accessed as singleton.
		 */
		public var traceWindow:Trace = Trace.instance;
		
		/**
		 * Dictionary, where key is moduleData object
		 * and value is loaded module (swf file)
		 */
		public var modules:Dictionary = new Dictionary();
		
		protected var panorama:Panorama;
		protected var stageReference:StageReference;
		protected var resizer:IResizer;
		protected var inertialMouseCamera:ICamera;
		protected var arcBallCamera:ICamera;
		protected var scrollCamera:ICamera;
		protected var keyboardCamera:ICamera;
		public var autorotationCamera:ICamera;
		protected var simpleTransition:SimpleTransition;
		protected var nanny:Nanny;
		
		private var currentxml:String = "";
		public var moduleLayer:ModuleLayer;
		
		public function QjPlayer() {
			trace(" --- QjPlayer start"+new Date()); 

			Security.allowDomain("*"); 
			Security.allowInsecureDomain("*"); 
		
//			MonsterDebugger.initialize(this);
			panorama = new Panorama(); // Singleton
			resizer = new Resizer();
			inertialMouseCamera = new InertialMouseCamera();
			arcBallCamera = new ArcBallCamera();
			scrollCamera = new ScrollCamera();
			keyboardCamera = new KeyboardCamera();
			autorotationCamera = new AutorotationCamera();
			simpleTransition = new SimpleTransition();
			nanny = new Nanny();
			init();
		}
		  
		protected function init():void {

			var currentxml:String = loaderInfo.parameters.xml ?loaderInfo.parameters.xml  :"settings.xml";  // 

			//淘宝CID
			var taobao_cid:String = loaderInfo.parameters.cid ?  loaderInfo.parameters.cid  :"";
			//是否只加载小图
			var isshowsmall:String = loaderInfo.parameters.showsmall ?  loaderInfo.parameters.showsmall  :"";
			//是否默认自动旋转
			var isautoskip:String =  loaderInfo.parameters.isautoskip ?  loaderInfo.parameters.isautoskip  :"";
			//filesync
			var filesyncxml:String = loaderInfo.parameters.filesync ? loaderInfo.parameters.filesync : "";
			
			if(taobao_cid != "")
			{
				com.panozona.player.module.global.ISTAOBAOMODEL = true;
			}
			if(isshowsmall == "1")
			{
				com.panozona.player.module.global.ISSHOWSMALL = true;
			}			
			if(isautoskip == "1")
			{
				com.panozona.player.module.global.ISAUTOROTATIONGONEXT = true;
			}
			
			this.currentxml = currentxml;
			if(com.panozona.player.module.global.ISTAOBAOMODEL == true)
			{
				if(this.currentxml.indexOf("http://") == -1)
				{
					this.currentxml = "http://detuhd.flash.jaeapp.com/"+currentxml;
					filesyncxml = "http://detuhd.flash.jaeapp.com/"+filesyncxml;
				}
				
				if(filesyncxml != "")
				{
					com.panozona.player.manager.taobao.Service.getInstance().loadfileSyncConfig(filesyncxml,startloadconfig);
				}
			}
			else
			{
				startloadconfig();
			}
			
			
			
		}
		
		public function startloadconfig():void{
			currentxml = com.spikything.utils.URL.resolveURI(currentxml);
			currentxml =  currentxml + (currentxml.indexOf("?") > 0 ? "&" : "?")+"v=" + new Date().getTime();
			
			loadConfig(currentxml);
		}
		
		
		
		public function loadConfig(url:String):void{
			var xmlLoader:URLLoader = new URLLoader();
			xmlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			try {
				xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, configurationLost);
				xmlLoader.addEventListener(Event.COMPLETE, configurationLoaded);
				xmlLoader.load(new URLRequest(url));
			}catch (error:Error) {
				addChild(traceWindow);
				traceWindow.printError("加载出错");
			}
		}
		
		protected function configurationLost(event:IOErrorEvent):void {
			event.target.removeEventListener(IOErrorEvent.IO_ERROR, configurationLost);
			event.target.removeEventListener(Event.COMPLETE, configurationLoaded);
			addChild(traceWindow);
			traceWindow.printError("加载出错: " + event.text);
		}
		
		protected function configurationLoaded(event:Event):void {
			event.target.removeEventListener(IOErrorEvent.IO_ERROR, configurationLost);
			event.target.removeEventListener(Event.COMPLETE, configurationLoaded);
			var input:ByteArray = event.target.data;
			try {input.uncompress();} catch (error:Error) {}
			var settings:XML;
			var str:String = input.toString().replace(/~/gm, loaderInfo.parameters.tilde ? loaderInfo.parameters.tilde : "");
			try {
				settings = XML(str);
			}catch (error:Error) {
				
				
				var _l:Loader = new Loader();
				_l.contentLoaderInfo.addEventListener (Event.COMPLETE, function(e:Event){
				
					var _bitmap:Bitmap = e.target.content as Bitmap;
					if(_bitmap != null)
					{
						addChild (_bitmap );
					}
					else
					{
						addChild(traceWindow);
						traceWindow.printError("加载文件结构出错: " + error.message);	
					}
				});
				_l.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, function(e:Event){
					addChild(traceWindow);
					traceWindow.printError("加载文件结构出错: " + error.message);	
				});
				_l.loadBytes(input);
				
				
				return;
			}
			
			
			var managerDataParserXML:ManagerDataParserXML = new ManagerDataParserXML();
			managerDataParserXML.addEventListener(ConfigurationEvent.INFO, printConfigurationMessage, false, 0, true);
			managerDataParserXML.addEventListener(ConfigurationEvent.WARNING, printConfigurationMessage, false, 0, true);
			managerDataParserXML.addEventListener(ConfigurationEvent.ERROR, printConfigurationMessage, false, 0, true);
			managerDataParserXML.configureManagerData(managerData, settings);
			
			
			
			//解析外部参数
			var managerDataParserFlashvars:ManagerDataParserFlashvars = new ManagerDataParserFlashvars();
			managerDataParserFlashvars.configureManagerData(managerData, loaderInfo.parameters);
			
			
			
			
			addChild(manager);
			
			moduleLayer = new ModuleLayer(manager);
			addChild(moduleLayer);
			
			
			
			if(global.ISSHOWSMALL == true)
			{
				finalOperations();
			}
			else
			{
				
				finalOperations();
			}

			/*	 
			var modulesLoader:LoadablesLoader = new LoadablesLoader();
			modulesLoader.addEventListener(LoadLoadableEvent.LOST, moduleLost);
			modulesLoader.addEventListener(LoadLoadableEvent.LOADED, moduleLoaded);
			modulesLoader.addEventListener(LoadLoadableEvent.FINISHED, modulesFinished);
			modulesLoader.load(Vector.<ILoadable>(managerData.modulesData));
			*/
			
			
		}
		
		private var loadModulesFinishFun:Function;
		public function loadModules(callBack:Function):void{
			loadModulesFinishFun = callBack;
			var modulesLoader:UrlLoadablesLoader = new UrlLoadablesLoader();
			modulesLoader.addEventListener(LoadLoadableEvent.LOST, moduleLost);
			modulesLoader.addEventListener(LoadLoadableEvent.LOADED, moduleLoaded);
			modulesLoader.addEventListener(LoadLoadableEvent.FINISHED, modulesFinished);
			modulesLoader.load(Vector.<ILoadable>( managerData.modulesData));
		}
		
		protected function moduleLost(event:LoadLoadableEvent):void {
			traceWindow.printError("Clould not load module: " + event.loadable.path);
		}
		
		protected function moduleLoaded(event:LoadLoadableEvent):void {
			modules[event.loadable] = event.content;
			if (event.content is Module){
				for each (var moduleData:ModuleData in managerData.modulesData) {
					if ((event.loadable as ModuleData) === moduleData) {
						moduleData.descriptionReference = (event.content as Module).moduleDescription;
						return;
					}
				}
			}
		}
		
		protected function modulesFinished(event:LoadLoadableEvent):void {
			trace("modulesFinished");
			event.target.removeEventListener(LoadLoadableEvent.LOST, moduleLost);
			event.target.removeEventListener(LoadLoadableEvent.LOADED, moduleLoaded);
			event.target.removeEventListener(LoadLoadableEvent.FINISHED, modulesFinished);
			for (var i:int = managerData.modulesData.length - 1; i >= 0; i--) {
				if (modules[managerData.modulesData[i]] != undefined){
					moduleLayer.addModule(modules[managerData.modulesData[i]] as Module);
				}
			}
	//		finalOperations();
			
			if(loadModulesFinishFun != null){
				loadModulesFinishFun();
				loadModulesFinishFun = null;
			}
			
			if (managerData.debugMode) {
				runValidator();
			}
			
			if(ExternalInterface.available)
			{
				try{
					//加载完成的事件
					ExternalInterface.call("Flash3dViewLoadCompleteHanlder");
				}
				catch(e:Error){
				
				}
			}
		}
		
		protected function printConfigurationMessage(event:ConfigurationEvent):void {
			if (event.type == ConfigurationEvent.INFO) {
				traceWindow.printInfo(event.message);
			}else if (event.type == ConfigurationEvent.WARNING) {
				traceWindow.printWarning(event.message);
			}else if (event.type == ConfigurationEvent.ERROR) {
				traceWindow.printError(event.message);
			}
		}
		
		protected function runValidator():void {
			var fakeModuleData:ModuleData = new ModuleData(manager.description.name, "fake path");
			fakeModuleData.descriptionReference = manager.description;
			managerData.modulesData.push(fakeModuleData);
			var managerDataValidator:ManagerDataValidator = new ManagerDataValidator();
			managerDataValidator.addEventListener(ConfigurationEvent.INFO, printConfigurationMessage, false, 0, true);
			managerDataValidator.addEventListener(ConfigurationEvent.WARNING, printConfigurationMessage, false, 0, true);
			managerDataValidator.addEventListener(ConfigurationEvent.ERROR, printConfigurationMessage, false, 0, true);
			managerDataValidator.validate(managerData);
			managerData.modulesData.pop();
		}
		
		protected function finalOperations():void {
		
			App.init(this);
			
			addChild(traceWindow); // to make it most on top

			addChild(new ContextMenus());
			/*
			if (managerData.statsData.visible) {
				addChild(new Stats());
			}
			*/
			
			if (managerData.controlData.mouseWheelTrap) {
				MouseWheelTrap.setup(stage);
			}
			
			manager.initialize([
				panorama,
				DeepZoomTilePyramid,
				//ZoomifyTilePyramid,
				resizer,
				managerData.controlData.keyboardCameraData,
				keyboardCamera,
				managerData.controlData.inertialMouseCameraData,
				inertialMouseCamera,
				managerData.controlData.arcBallCameraData,
				arcBallCamera,
				managerData.controlData.scrollCameraData,
				scrollCamera,
				managerData.controlData.autorotationCameraData,
				autorotationCamera,
				managerData.controlData.simpleTransitionData,
				simpleTransition,
				nanny
			]);
			
			manager.loadFirstPanorama();
			

		
			
			Actioncode.getIntance().qjPlayer = this;
		}
		
		/**
		 * Returns reference to module (swf file)
		 * by its name declared in configuration
		 * 
		 * @param name of module
		 * @return module as DisplayObject, null if not found
		 */
		public function getModuleByName(name:String):DisplayObject {
			for each(var moduleData:ModuleData in managerData.modulesData) {
				if (moduleData.name.toLocaleLowerCase() == name.toLocaleLowerCase()) {
					return modules[moduleData];
				}
			}
			return null;
		}
	}
}

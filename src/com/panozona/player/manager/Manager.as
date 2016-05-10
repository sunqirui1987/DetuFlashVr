/*
 OuWei Flash3DHDView 
*/
package com.panozona.player.manager {
	
	import com.adobe.images.JPGEncoder;
	import com.adobe.serialization.json;
	import com.adobe.serialization.json.JSON;
	import com.panosalado.controller.SimpleTransition;
	import com.panosalado.core.PanoSalado;
	import com.panosalado.events.PanoSaladoEvent;
	import com.panosalado.model.ViewData;
	import com.panosalado.view.Hotspot;
	import com.panosalado.view.ManagedChild;
	import com.panosalado.view.Panorama;
	import com.panozona.modules.imagegallery.model.structure.Group;
	import com.panozona.player.QjPlayer;
	import com.panozona.player.manager.CustomFunction.YiwuPlugin;
	import com.panozona.player.manager.actionCode.Actioncode;
	import com.panozona.player.manager.data.ManagerData;
	import com.panozona.player.manager.data.actions.ActionData;
	import com.panozona.player.manager.data.actions.FunctionData;
	import com.panozona.player.manager.data.panoramas.HotspotData;
	import com.panozona.player.manager.data.panoramas.HotspotDataImage;
	import com.panozona.player.manager.data.panoramas.HotspotDataSwf;
	import com.panozona.player.manager.data.panoramas.HotspotSprite;
	import com.panozona.player.manager.data.panoramas.PanoramaData;
	import com.panozona.player.manager.data.panoramas.help.HelpView;
	import com.panozona.player.manager.data.panoramas.linkArrows.LinkArrowsContainer;
	import com.panozona.player.manager.data.panoramas.weather.WeatherContainer;
	import com.panozona.player.manager.events.LoadLoadableEvent;
	import com.panozona.player.manager.events.PanoramaEvent;
	import com.panozona.player.manager.extend.AutoSkipPano;
	import com.panozona.player.manager.utils.Trace;
	import com.panozona.player.manager.utils.UploadPostHelper;
	import com.panozona.player.manager.utils.configuration.ManagerDataParserXML;
	import com.panozona.player.manager.utils.loading.ILoadable;
	import com.panozona.player.manager.utils.loading.LoadablesLoader;
	import com.panozona.player.manager.utils.loading.UrlLoadablesLoader;
	import com.panozona.player.module.Module;
	import com.panozona.player.module.global;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.utils.ModuleDescription;
	
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	
	
	public class Manager extends PanoSalado{
		
		public const description:ModuleDescription = new ModuleDescription("FlashHD3DView", "1.0.0", "");
		
		/**
		 * Dictionary, where key is hotspotData object
		 * and value is loaded hotspot (DisplayObject)
		 */
		public var hotspots:Dictionary;
		
		public var allloadhotspots:Dictionary = new Dictionary(true);
		
		public var panoramaIsMoving:Boolean;
		public var pendingActionId:String;
		public var pendingActionpanramaId:String;
		public var panoramaLoadingCanceled:Boolean;
		
		public var _managerData:ManagerData;
		public var _qjPlayer:QjPlayer; // parent needed to access loaded modules
		
		public var _currentPanoramaData:PanoramaData;
		public var _previousPanoramaData:PanoramaData;
		public var arrListeners:Array; // hold hotspots mouse event listeners so that they can be removed
		
		public   var _currentGroupId:String="";
		public   var _prePanoramaDataObject:Object=null;
		
		protected var arrLoadPotHotList:Array;
		
		private  var isFirstPanoNow:Boolean;
		
		public function Manager() {
			description.addFunctionDescription("runJsAction", String);
			description.addFunctionDescription("runAction", String);
			description.addFunctionDescription("print", String);
			description.addFunctionDescription("loadPano", String);
			description.addFunctionDescription("loadPanoThen", String);
			description.addFunctionDescription("loadPanoToNext", String,String);
			description.addFunctionDescription("loadGroupData",String);
			
			description.addFunctionDescription("waitThen", Number, String);
			description.addFunctionDescription("moveToHotspot", String, Number);
			description.addFunctionDescription("moveToHotspotThen", String, Number, String);
			description.addFunctionDescription("moveToView", Number, Number, Number);
			description.addFunctionDescription("moveToViewThen", Number, Number, Number, String);
			description.addFunctionDescription("jumpToView", Number, Number, Number);
			description.addFunctionDescription("startMoving", Number, Number);
			description.addFunctionDescription("stopMoving");
			description.addFunctionDescription("advancedMoveToHotspot", String, Number, Number, Function);
			description.addFunctionDescription("advancedMoveToHotspotThen", String, Number, Number, Function, String);
			description.addFunctionDescription("advancedMoveToView", Number, Number, Number, Number, Function);
			description.addFunctionDescription("advancedMoveToViewThen", Number, Number, Number, Number, Function, String);
			description.addFunctionDescription("advancedStartMoving", Number, Number, Number, Number, Number);
			
			description.addFunctionDescription("loadPanoFix", String,String,Number,Number);
			description.addFunctionDescription("jumpToPreView",Number,Number,Number);
			
			description.addFunctionDescription("loadPanoToPanTilt",String,Number,Number,Number,String);
			description.addFunctionDescription("jumpToPreView_Fix",Number,Number,Number);

			
			description.addFunctionDescription("LoadPotHotDetail",String,String,String);
			
			description.addFunctionDescription("LoadNextPano",String);
			description.addFunctionDescription("loadPrePano",String);
			
			description.addFunctionDescription("addHotpot",String,String,Number,Number);
			description.addFunctionDescription("removeHotpot",String);
			
			description.addFunctionDescription("loadPanoToNextAndMoveToHotspot",String,String);
			description.addFunctionDescription("loadPanoToNextAndMoveToPanTilt", String, Number, Number, Number);
			
			
			if (stage) stageReady();
			else addEventListener(Event.ADDED_TO_STAGE, stageReady);
		}
		
		private function stageReady(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, stageReady);
			_qjPlayer = QjPlayer(this.parent);
			_managerData = _qjPlayer.managerData;
			
			//加载扩展模块
			new AutoSkipPano(this);
			
//			//初始化mornUI
//			App.init(this);
			
			//JS回调事件
			try
			{
				if(ExternalInterface.available)
				{
				
					//运行JsAction 参数： jsaction function
					ExternalInterface.addCallback("runJsAction",runJsAction);
					//运行Action 参数： actionid
					ExternalInterface.addCallback("runAction",runAction);
					ExternalInterface.addCallback("addXmlHotContent",addXmlHotContent);
					//增加Action 代码
					ExternalInterface.addCallback("addActionContent",addActionContent);
					//运行Action 代码
					ExternalInterface.addCallback("runActionContent",runActionContent);
					//获取action列表  参数： 无   返回  actionid列表，用豆号分开，可以在runAction中执行
					ExternalInterface.addCallback("getActionList",getActionList);
					//获取当前全景信息 参数： 无     返回 当前全景的信息。逗号分号  例如： 全景id,pan,tilt,fov
					ExternalInterface.addCallback("getCurrentPanoInfo",getCurrentPanoInfo);
					//得到所有的
					ExternalInterface.addCallback("getAllPanoInfo",getAllPanoInfo);
					//动画 参数：时间 actionid
					ExternalInterface.addCallback("waitThen", waitThen);
					//定位到热点 
					ExternalInterface.addCallback("moveToHotspot",moveToHotspot);
					ExternalInterface.addCallback("moveToHotspotThen",moveToHotspotThen);
					//定位到位置 参数  ： pan  ，tilt ， fov 
					ExternalInterface.addCallback("moveToView", moveToView);
					ExternalInterface.addCallback("moveToViewThen", moveToViewThen);
					//立即定位
					ExternalInterface.addCallback("jumpToView", jumpToView);
					//加载全景 　参数：全景ID   
					ExternalInterface.addCallback("loadPano",loadPano);
					//动画加载全景 参数：全景ID
					ExternalInterface.addCallback("loadPanoThen",loadPanoThen);
					//加载下一个场景 参数：无
					ExternalInterface.addCallback("LoadNextPano",LoadNextPano);
					//加载上一个场景 参数：无
					ExternalInterface.addCallback("loadPrePano",loadPrePano);
					//增加热点 参数： hotid 热点ID　path　资源地址　pan　pan位置　tilt tilt位置
					ExternalInterface.addCallback("addHotpot",addHotpot);
					//删除热点  参数： hotid 热点ID　
					ExternalInterface.addCallback("removeHotpot",removeHotpot);
					//定位到 热点  参数：  全景ID ，热点ID
					ExternalInterface.addCallback("loadPanoToNextAndMoveToHotspot",loadPanoToNextAndMoveToHotspot);
					//定位到 热点  参数  ： 全景ID ，pan (-1为当前位置) ，tilt (-1为当前位置)， fov  (-1为当前位置)
					ExternalInterface.addCallback("loadPanoToNextAndMoveToPanTilt",loadPanoToNextAndMoveToPanTilt);
					

					
					//<<<<<<<<加载新配置 参数：配置地址
					ExternalInterface.addCallback("newConfig",newConfig);
					
					//<<<<<<<<运行一段actionCode 参数：content 脚本内容
					ExternalInterface.addCallback("runActionCode",runActionCode);
					
					//<<<<<<<<添加一段actionCodes 参数：content 脚本内容
					ExternalInterface.addCallback("addActionCodes",addActionCodes);
					
					//<<<<<<<<得到参数
					ExternalInterface.addCallback("ActionCode_getObject",runActionCodegetObject);
						
					
				}
			}
			catch(e:Error)
			{
				trace("js error"+e.message);
			}
			
		}
		
		public function addXmlHotContent(content:String="",hotid:String="",panoid:String=""):void
		{
	
			var reg1:RegExp = new RegExp("\\[","\g");
			var reg2:RegExp = new RegExp("\\]","\g");
			content = content.replace(reg1,"<");
			content = content.replace(reg2,">");
			content = "<pano>"+content+"</pano>";
			
			var panodata:PanoramaData = null;
			if(panoid == "")
			{
				panodata = this.currentPanoramaData;
			}
			else
			{
				for each(var tmppanodata:PanoramaData in this._managerData.panoramasData)
				{
					if(tmppanodata.id == panoid)
					{
						panodata = tmppanodata;
						break;
					}
				}
			}
		
			if(hotid != "")
			{
				for(var i:Number = panodata.hotspotsData.length ; i > 0  ; i--)
				{
					var tmphotdata:HotspotData = panodata.hotspotsData[i];
					if(tmphotdata.id == hotid)
					{
						//存在相同的则删除掉
						panodata.hotspotsData.splice(i,1); 
					}
				}
			}
			
			var xml:XML = new XML(content);
			
			var mdx:ManagerDataParserXML = new ManagerDataParserXML();
			mdx.parseHotspots(panodata,xml);
			
		}
		
		public function addActionCodes(content:String):void
		{
			var reg1:RegExp = new RegExp("\\[","\g");
			var reg2:RegExp = new RegExp("\\]","\g");
			content = content.replace(reg1,"<");
			content = content.replace(reg2,">");
			var xml:XML = new XML(content);
			var parser:ManagerDataParserXML = new ManagerDataParserXML();
			parser.parseActionCodes(xml);
		}
		
		public function runActionCode(content:String):void
		{
			Actioncode.getIntance().runByContent(content);		
		}
		
		public function runActionCodegetObject(content:String):String
		{
			return Actioncode.getIntance().getObject(content);		
		}
		
		public function get managerData():ManagerData
		{
			return _managerData;
		}
		
		public override function initialize(dependencies:Array):void {
			super.initialize(dependencies);
			for (var i:int = 0; i < dependencies.length; i++ ) {
				if (dependencies[i] is SimpleTransition){
					dependencies[i].addEventListener( Event.COMPLETE, transitionComplete, false, 0, true);
				}
			}
			addEventListener(Event.COMPLETE, panoramaLoaded, false, 0, true);
		}
		
		public function get currentPanoramaData():PanoramaData {
			return _currentPanoramaData
		}
		
		public function loadFirstPanorama():void {
			isFirstPanoNow = true;
			var isfind:Boolean = false;
			if (_managerData.allPanoramasData.firstPanorama != null) {
				var panoramaData:PanoramaData = _managerData.getPanoramaDataById(_managerData.allPanoramasData.firstPanorama);
				if(panoramaData != null)
				{
					loadPanoramaById(_managerData.allPanoramasData.firstPanorama);
					isfind = true;
				}
			}
			
			if (isfind == false && _managerData.panoramasData != null && _managerData.panoramasData.length > 0) {
				_managerData.allPanoramasData.firstPanorama = _managerData.panoramasData[0].id;
				loadPanoramaById(_managerData.panoramasData[0].id);
			}
			
		}
		
		public function loadPanoramaById(panoramaId:String):void {
			
			var panoramaData:PanoramaData = _managerData.getPanoramaDataById(panoramaId);
			if (panoramaData == null || panoramaData === _currentPanoramaData) return;
			
			if (!panoramaLoadingCanceled && _currentPanoramaData != null && _currentPanoramaData.onLeaveToAttempt[panoramaData.id] != null) {
				panoramaLoadingCanceled = true;
				runAction(_currentPanoramaData.onLeaveToAttempt[panoramaData.id]);
				return;
			}
			
			panoramaLoadingCanceled = false;
			_previousPanoramaData = _currentPanoramaData;
			_currentPanoramaData = panoramaData;
			panoramaIsMoving = true;
			
			if(_previousPanoramaData != null){
				runAction(_previousPanoramaData.onLeave);
				runAction(_previousPanoramaData.onLeaveTo[currentPanoramaData.id]);
			}
			dispatchEvent(new PanoramaEvent(PanoramaEvent.PANORAMA_STARTED_LOADING));
			
			Trace.instance.printInfo("Loading panorama: " + panoramaData.id);
			
			if (arrListeners != null){
				for (var i:int = 0; i < _managedChildren.numChildren; i++ ) {
					for(var j:Number = 0; j < arrListeners.length; j++){
						if (_managedChildren.getChildAt(i).hasEventListener(arrListeners[j].type)) {
							if(arrListeners[j].type != MouseEvent.ROLL_OUT && arrListeners[j].type != MouseEvent.MOUSE_UP){
								_managedChildren.getChildAt(i).removeEventListener(arrListeners[j].type, arrListeners[j].listener);
							}
						}
					}
				}
			}
			
			arrListeners = new Array();
			_canvas.blendMode = BlendMode.LAYER;
			super.loadPanorama(panoramaData.params.clone());
		}
		
		protected function panoramaLoaded(e:Event):void {
			if(isFirstPanoNow){
				isFirstPanoNow = false;
				if(_managerData.allPanoramasData.helpPath){
					var helpView:HelpView = new HelpView(_managerData.allPanoramasData.helpPath,this);
					stage.addChild(helpView);
				}
				_qjPlayer.loadModules(function():void{
					dispatchEvent(new PanoramaEvent(PanoramaEvent.PANORAMA_STARTED_LOADING));
					dispatchEvent(new PanoramaEvent(PanoramaEvent.PANORAMA_LOADED));
				});
			}
			
			if (_previousPanoramaData != null && isNaN(currentPanoramaData.params.pan)) {
				pan += (_previousPanoramaData.direction - currentPanoramaData.direction);
			}
			loadHotspots(currentPanoramaData);
			
			panoramaIsMoving = false;
			runAction(currentPanoramaData.onEnter);
			if (_previousPanoramaData != null ){
				runAction(currentPanoramaData.onEnterFrom[_previousPanoramaData.id]);
			}else {
				runAction(_managerData.allPanoramasData.firstOnEnter);
			}
			
			dispatchEvent(new PanoramaEvent(PanoramaEvent.PANORAMA_LOADED));
			//创建
			createArrows();
			
			
			if(ExternalInterface.available)
			{
				try{
					//每次加载完全景都会调用
					ExternalInterface.call("Flash3dViewLoadPanoCompleteHanlder");
				}
				catch(e:Error){
					
				}
			}
			//清除状态
			_prePanoramaDataObject = null;
		}
		
		protected function loadHotspots(panoramaData:PanoramaData):void {
			managedChildClickFunList = [];
			hotspots = new Dictionary(true);
			//加载热点列表
			var hotspotsLoader:LoadablesLoader = new LoadablesLoader();
			hotspotsLoader.extraobj = this;
			hotspotsLoader.addEventListener(LoadLoadableEvent.LOST, hotspotLost);
			hotspotsLoader.addEventListener(LoadLoadableEvent.LOADED, hotspotLoaded);
			hotspotsLoader.addEventListener(LoadLoadableEvent.FINISHED, hotspotsFinished);
			hotspotsLoader.load(panoramaData.getHotspotsLoadable());
		}
		
		protected function hotspotLost(event:LoadLoadableEvent):void {
			_qjPlayer.traceWindow.printError("Could not load hotspot: " + event.loadable.path);
		}
		
		protected function hotspotLoaded(event:LoadLoadableEvent):void {
			var hotspot:Hotspot;
			var hotspotData:HotspotData = (event.loadable as HotspotData);
			if (hotspotData is HotspotDataSwf) {
				if ("references" in (event.content as Object)) {
					try {(event.content as Object).references(_qjPlayer, (hotspotData as HotspotDataSwf))} catch (e:Error){}
				}
			}
			
			hotspot = new Hotspot(event.content,hotspotData);
			hotspot.name = hotspotData.id;
			hotspot.setalpha(hotspotData.alpha);
			hotspot.setoveralpha(hotspotData.overalpha);
			hotspot.settiptext(hotspotData.text,hotspotData.textarg);//设置

			allloadhotspots[hotspotData.id] = hotspot;
			
			
			insertHotspot(hotspot as ManagedChild, hotspotData);
		}
		
		
		
		public function insertHotspot(managedChild:ManagedChild, hotspotData:HotspotData):void {
			
			this.addHotspotEvent(managedChild,hotspotData);
			
			var matrix3D:Matrix3D = new Matrix3D();
			matrix3D.appendScale(hotspotData.transform.scaleX, hotspotData.transform.scaleY, hotspotData.transform.scaleZ);
			//是否是新的热点模式
			if(!hotspotData.transform.flat && hotspotData.isnew == false){
				matrix3D.appendRotation(hotspotData.location.tilt, Vector3D.X_AXIS);
				matrix3D.appendRotation(hotspotData.location.pan, Vector3D.Y_AXIS);
			}else {
				managedChild.flat = true;
			}
			/*
		
			* 球面坐标系转直角坐标系
			* @param {Number} a 仰角  pr
			* @param {Number} b 转角  tr
			* @param {Number} r 半径  distance
			
			*/
			var piOver180:Number = Math.PI / 180;
			var pr:Number = -1 * (hotspotData.location.pan - 90) * piOver180;
			var tr:Number = -1 * hotspotData.location.tilt * piOver180;
			var xc:Number = hotspotData.location.distance * Math.cos(pr) * Math.cos(tr);
			var yc:Number = hotspotData.location.distance * Math.sin(tr);
			var zc:Number = hotspotData.location.distance * Math.sin(pr) * Math.cos(tr);
			matrix3D.appendTranslation(xc, yc, zc); 
			matrix3D.prependRotation(hotspotData.transform.rotationX, Vector3D.X_AXIS);
			matrix3D.prependRotation(hotspotData.transform.rotationY, Vector3D.Y_AXIS);
			matrix3D.prependRotation(hotspotData.transform.rotationZ, Vector3D.Z_AXIS);
			
			var decomposition:Vector.<Vector3D> = matrix3D.decompose();
			managedChild.x = decomposition[0].x;
			managedChild.y = decomposition[0].y;
			managedChild.z = decomposition[0].z;
			managedChild.rotationX = decomposition[1].x;
			managedChild.rotationY = decomposition[1].y;
			managedChild.rotationZ = decomposition[1].z;
			managedChild.scaleX = decomposition[2].x;
			managedChild.scaleY = decomposition[2].y;
			managedChild.scaleZ = decomposition[2].z;
			
			var precedingHotspotData:HotspotData = null;
			for (var addedHotspotData:Object in hotspots) {
				if (!isNaN(addedHotspotData.location.distance) && !isNaN(hotspotData.location.distance)
					&& addedHotspotData.location.distance < hotspotData.location.distance) {
					if (precedingHotspotData == null || precedingHotspotData.location.distance < addedHotspotData.location.distance){
						precedingHotspotData = addedHotspotData as HotspotData;
					}
				}
			}
			if(hotspots == null)
			{
				hotspots = new Dictionary(true);
			}
			hotspots[hotspotData] = managedChild;
			if (precedingHotspotData == null) {
				addChild(managedChild);
			} else {
				addChildAt(managedChild, _managedChildren.getChildIndex(hotspots[precedingHotspotData]));
			}
			updateChildren(this);
		}
		
		private var _mousepoint:Point = new Point();
		private function managedChildMouseDownFun(e:MouseEvent):void {
			_mousepoint = new Point(e.stageX,e.stageY);
		}
		
		private function managedChildMouseUpFun(e:MouseEvent):void {
			var upmousepoint:Point = new Point(e.stageX,e.stageY);
			if(Math.abs(upmousepoint.x - _mousepoint.x) < 2 && Math.abs(upmousepoint.y - _mousepoint.y) < 2)
			{
				var target:ManagedChild = e.currentTarget as ManagedChild;
				if(target){
					var fun:Function = managedChildClickFunList[target.hotId];
					if(fun != null)
						fun(e);
				}
			}
		}
		
		private var managedChildClickFunList:Array = [];
		public function addHotspotEvent(managedChild:ManagedChild, hotspotData:HotspotData):void 
		{
			managedChild.buttonMode = hotspotData.handCursor;
			managedChild.hotId = hotspotData.id;
			var tmpFunction:Function;
			if (hotspotData.target != null) {
				tmpFunction = getTargetHandler(hotspotData.target);
				managedChildClickFunList[managedChild.hotId] = tmpFunction;
				managedChild.addEventListener(MouseEvent.MOUSE_DOWN, managedChildMouseDownFun);
				managedChild.addEventListener(MouseEvent.MOUSE_UP, managedChildMouseUpFun);
				arrListeners.push({type:MouseEvent.MOUSE_DOWN, listener:managedChildMouseDownFun});
				arrListeners.push({type:MouseEvent.MOUSE_UP, listener:managedChildMouseUpFun});
//				managedChild.addEventListener(MouseEvent.CLICK, tmpFunction);
//				arrListeners.push({type:MouseEvent.CLICK, listener:tmpFunction});
			}
			if (hotspotData.mouse.onClick != null) {
				tmpFunction = getMouseEventHandler(hotspotData.mouse.onClick);
				managedChildClickFunList[managedChild.hotId] = tmpFunction;
				managedChild.addEventListener(MouseEvent.MOUSE_DOWN, managedChildMouseDownFun);
				managedChild.addEventListener(MouseEvent.MOUSE_UP, managedChildMouseUpFun);
				arrListeners.push({type:MouseEvent.MOUSE_DOWN, listener:managedChildMouseDownFun});
				arrListeners.push({type:MouseEvent.MOUSE_UP, listener:managedChildMouseUpFun});
//				managedChild.addEventListener(MouseEvent.CLICK, tmpFunction);
//				arrListeners.push({type:MouseEvent.CLICK, listener:tmpFunction} );
			}
			if (hotspotData.mouse.onPress != null) {
				tmpFunction = getMouseEventHandler(hotspotData.mouse.onPress)
				managedChild.addEventListener(MouseEvent.MOUSE_DOWN, tmpFunction);
				arrListeners.push({type:MouseEvent.MOUSE_DOWN, listener:tmpFunction});
			}
			if (hotspotData.mouse.onRelease != null) {
				tmpFunction = getMouseEventHandler(hotspotData.mouse.onRelease)
				managedChild.addEventListener(MouseEvent.MOUSE_UP, tmpFunction, false, 0, true);
				arrListeners.push({type:MouseEvent.MOUSE_UP, listener:tmpFunction});
			}
			if (hotspotData.mouse.onOver != null) {
				tmpFunction = getMouseEventHandler(hotspotData.mouse.onOver)
				managedChild.addEventListener(MouseEvent.ROLL_OVER, tmpFunction);
				arrListeners.push({type:MouseEvent.ROLL_OVER, listener:tmpFunction});
			}
			if (hotspotData.mouse.onOut != null) {
				tmpFunction = getMouseEventHandler(hotspotData.mouse.onOut)
				managedChild.addEventListener(MouseEvent.ROLL_OUT, tmpFunction, false, 0, true);
				arrListeners.push({type:MouseEvent.ROLL_OUT, listener:tmpFunction});
			}

		}
		
		public  function addHotspot(managedChild:ManagedChild, hotspotData:HotspotData):void
		{
			this.insertHotspot(managedChild,hotspotData);
		}
		
	
		private function getMouseEventHandler(id:String):Function{
			return function(e:MouseEvent):void {
				runAction(id);
			}
		}
		
		private function getTargetHandler(panoramaId:String):Function{
			return function(e:MouseEvent):void {
				loadPanoramaById(panoramaId);
			}
		}
		
		protected function hotspotsFinished(event:LoadLoadableEvent):void {
			event.target.removeEventListener(LoadLoadableEvent.LOST, hotspotLost);
			event.target.removeEventListener(LoadLoadableEvent.LOADED, hotspotLoaded);
			event.target.removeEventListener(LoadLoadableEvent.FINISHED, hotspotsFinished);
			dispatchEvent(new PanoramaEvent(PanoramaEvent.HOTSPOTS_LOADED));
		}
		
		protected function transitionComplete(e:Event):void {
			_canvas.blendMode = BlendMode.NORMAL;
			if (_previousPanoramaData == null) {
				runAction(_managerData.allPanoramasData.firstOnTransitionEnd);
			}else {
				runAction(currentPanoramaData.onTransitionEndFrom[_previousPanoramaData.id]);
			}
			runAction(currentPanoramaData.onTransitionEnd);
			dispatchEvent(new PanoramaEvent(PanoramaEvent.TRANSITION_ENDED));
		}
		
		protected function swingloadPanoThenComplete(e:PanoSaladoEvent):void {
			removeEventListener(PanoSaladoEvent.SWING_TO_CHILD_COMPLETE, swingloadPanoThenComplete);
			removeEventListener(PanoSaladoEvent.SWING_TO_COMPLETE, swingloadPanoThenComplete);
			panoramaIsMoving = false;
			if (this.pendingActionpanramaId != null) {
				this.loadPano(pendingActionpanramaId);
			}
		}
		
		protected function swingComplete(e:PanoSaladoEvent):void {
			removeEventListener(PanoSaladoEvent.SWING_TO_CHILD_COMPLETE, swingComplete);
			removeEventListener(PanoSaladoEvent.SWING_TO_COMPLETE, swingComplete);
			panoramaIsMoving = false;
			if (pendingActionId != null) {
				runAction(pendingActionId);
			}
		}
		
		public function moveToViewThenFunction(pan:Number, tilt:Number, fieldOfView:Number,fun:Function):void {
			if (panoramaIsMoving) return;
			panoramaIsMoving = true;
			addEventListener(PanoSaladoEvent.SWING_TO_COMPLETE,fun);
			swingTo(pan, tilt, fieldOfView);
		}
		
		
		
		private var __toDegrees:Number = 180 / Math.PI;
		private var __toRadians:Number = Math.PI / 180;
		private function validatePanTilt(value:Number):Number {
			if (value <= -180) value = (((value + 180) % 360) + 180);
			if (value > 180) value = (((value + 180) % 360) - 180);
			return value;
		}
		public function getCursorPan():Number {
			return validatePanTilt( this._pan +
				Math.atan((this.mouseX - this.boundsWidth * 0.5)
					* Math.tan(this.fieldOfView * 0.5 * __toRadians) / (this.boundsWidth * 0.5)) * __toDegrees);
		}
		
		private var verticalFieldOfView:Number
		public function getCursorTilt():Number {
			verticalFieldOfView =  __toDegrees * 2 * Math.atan((this.boundsHeight / this.boundsWidth) * Math.tan(__toRadians * 0.5 * this.fieldOfView));
			
			var ti:Number = this._tilt -
				Math.atan(( this.mouseY - this.boundsHeight * 0.5)
					* Math.tan(verticalFieldOfView * 0.5 * __toRadians) / (this.boundsHeight * 0.5)) * __toDegrees;
			
			return validatePanTilt(ti );
		}
		//添加热点到当前场景
		public function addHotpot(hotid:String,path:String,pan:Number=-1,tilt:Number=-1):void
		{
			
			if(pan == -1 && tilt == -1)
			{
				pan =Number(getCursorPan().toFixed(2));
				tilt = Number(getCursorTilt().toFixed(2));

			}
			var customhotid:String = hotid;
			var hotspotData:HotspotDataImage = new HotspotDataImage(customhotid,path);
			hotspotData.location.pan = pan;
			hotspotData.location.tilt = tilt;
			hotspotData.isnew = true;
			this.currentPanoramaData.hotspotsData.push(hotspotData);
			var hotpotsprite:HotspotSprite = new HotspotSprite();
			hotpotsprite.name = customhotid;
			hotpotsprite.path = path;
			
			this.addHotspot(hotpotsprite,hotspotData);
		}
		
		//删除热点
		public function removeHotpot(hotid:String):void
		{
			var customhotid:String = hotid;
			for(var i:int = 0 ; i < this.currentPanoramaData.hotspotsData.length; i++)
			{
				var hot:HotspotData = this.currentPanoramaData.hotspotsData[i];
				if(hot.id == customhotid)
				{
					delete this.currentPanoramaData.hotspotsData[i];
					break;
				}
			}
			
			var child:DisplayObject = this._getChildByName(customhotid,true);
			if(child != null)
			{
				this.removeChild(child);
			}
		}
		
		
		
		
		//---------加载新配置 begin-------------
		private function cleanPanoramasData():void {
			while (_managerData.panoramasData.length > 0) {
				_managerData.panoramasData.pop();
			}
		}
		
		private function cleanActionsData():void {
			while (_managerData.actionsData.length > 0) {
				_managerData.actionsData.pop();
			}
		}
		
		private function cleanModulesData():void {
			while (_managerData.modulesData.length > 0) {
				_managerData.modulesData.pop();
			}
		}
		
		private function cleanModulesViews():void {
			this._qjPlayer.moduleLayer.removeModules();
			for each (var s:* in _qjPlayer.modules) 
			{
				if (_qjPlayer.modules[s] &&　_qjPlayer.modules[s].parent){
					_qjPlayer.modules[s].parent.removeChild(_qjPlayer.modules[s]);
				}
			}
		}
		
		private function reloadConfig(url:String):void{
			cleanPanoramasData();
			cleanActionsData();
			cleanModulesData();
			cleanModulesViews();
			_qjPlayer.loadConfig(url);
		}
		//---------加载新配置 end-------------
		
		//---------全景串联begin-------------
		
		private var linkArrowsContainer:LinkArrowsContainer;
		
		private function createArrows():void{
			if(!_managerData.allPanoramasData.isAutoLink)
				return;
			if(!linkArrowsContainer){
				linkArrowsContainer = new LinkArrowsContainer(this);
			}else{
				linkArrowsContainer.update();
			}
			addChild(linkArrowsContainer);
			updateChildren(this);
			linkArrowsContainer.x = 0;
			linkArrowsContainer.y = 200 ;// this.boundsHeight/2-_managerData.allPanoramasData.linkArrowDrawHeight   ;// (this.boundsHeight - this.streetviewarrow.height ) ;
			linkArrowsContainer.z = 500;
			
//			if(!weatherContainer){
//				weatherContainer = new WeatherContainer(this);
//			}
//			addChild(weatherContainer);
//			updateChildren(this);
//			weatherContainer.x = 0;
//			weatherContainer.y = 0;
//			weatherContainer.z = 0;
		}
		private var weatherContainer:WeatherContainer;
		
		override protected function updateChildren(viewData:ViewData):void {
			for (var i:int = 0; i < _managedChildren.numChildren; i++) {
				var child:ManagedChild = _managedChildren.getChildAt(i) as ManagedChild;
				var matrix3D:Matrix3D = child._matrix3D;
				if (child.invalid) {
					matrix3D.recompose(child._decomposition);
					child.invalid = false;
				}
				matrix3D = matrix3D.clone();
				if(child is WeatherContainer)
				{
					matrix3D.appendTranslation(0, 0, this.fieldOfView - 90);
					
					var rz:Number = this._pan;
					matrix3D.appendRotation(-rz,Vector3D.Y_AXIS);
					
					var rzt:Number = this._tilt;
					matrix3D.appendRotation(-rzt,Vector3D.X_AXIS);
					
					if(this.fieldOfView < 90 )
					{
						var rzf:Number = (this.fieldOfView - 90 ) * 10;
						matrix3D.appendTranslation( 0,-rzf, 0);
					}
					if(this._tilt > 0)
					{
						var rzft:Number = (this._tilt - 0 ) * 10;
						matrix3D.appendTranslation( 0,rzft, 0);
					}
					
					child.transform.matrix3D = matrix3D;
					continue;
				}
				if(child.name == "hotspotpolygonal")
				{ 
					//matrix3D.appendTranslation(0, 0, -viewData.perspectiveProjection.focalLength);
					//child.transform.matrix3D = matrix3D;
					continue;
				}
				
				if(child is LinkArrowsContainer)
				{ 
					
					matrix3D.appendTranslation(0, 0, this.fieldOfView - 90);
					
					rz = this._pan;
					matrix3D.appendRotation(-rz,Vector3D.Y_AXIS);
					
					var dz:Number = -fieldOfView/2;
					child.z = dz;
					
			//		matrix3D.appendTranslation( 0,0,-dz);
					
					rzt = this._tilt;
					matrix3D.appendRotation(-rzt,Vector3D.X_AXIS);
					
					if(this.fieldOfView < 90 )
					{
						//rzf = (this.fieldOfView - 90 ) * 10;
					//	matrix3D.appendTranslation( 0,-rzf, 0);
					}
					if(this._tilt > 0)
					{
						rzft = (this._tilt - 0 ) * 10;
						matrix3D.appendTranslation( 0,rzft, 0);
					}
					
					child.transform.matrix3D = matrix3D;
					continue;
				}
				matrix3D.append(viewData.transformMatrix3D);
				matrix3D.appendTranslation(0, 0, -viewData.perspectiveProjection.focalLength);
				
				if (!child.flat) {
					child.transform.matrix3D = matrix3D;
				}else {
					var pos:Vector3D = matrix3D.decompose()[0];
					var t:Number = viewData.perspectiveProjection.focalLength / (viewData.perspectiveProjection.focalLength + pos.z);
					if (t > 0) {
						child.flatX = pos.x * t; 
						child.flatY = pos.y * t;
					}else {
						child.flatX = 9999;
						child.flatY = 9999;
					}
				}
			}
		}
		
		
		
		
		//---------全景串联 en的-------------
		
///////////////////////////////////////////////////////////////////////////////
//  Exposed functions 
///////////////////////////////////////////////////////////////////////////////
		//加载分组
		public function loadGroupData(groupid:String):void
		{
			if(groupid == _currentGroupId)
			{
				return;
			}
			_currentGroupId = groupid;
			
			var initgobject:Object = null;
			//后面的替换前面的
			var managerxml:ManagerDataParserXML = new ManagerDataParserXML();
			for(var i:Number = 0;i < this._managerData.groupsData.length;i++)
			{
				var tobj:Object = this._managerData.groupsData[i];
				if(tobj.group_id == groupid)
				{
					initgobject = tobj;
					break;
				}
			}
			if(initgobject != null)
			{
				if(initgobject.group_x_panoramas != null && initgobject.group_x_panoramas.elements().length() > 0)
				{
					this._managerData.allPanoramasData.firstPanorama = initgobject.group_firstPanorama;
					//初始化
					this._managerData.panoramasData=new Vector.<PanoramaData>();
					managerxml.parsePanoramas(managerData.panoramasData,initgobject.group_x_panoramas);
					
					this.loadPanoramaById(this._managerData.allPanoramasData.firstPanorama);
				}
				if(initgobject.array_delmodules != null)
				{
					for each(var delobject:Object in initgobject.array_delmodules)
					{
						for(var j:Number = 0; j < this._managerData.modulesData.length;j++)
						{
							var md:ModuleData = this._managerData.modulesData[j];
							if(md.name == delobject.name)
							{
								this._managerData.modulesData.splice(j,1);
								break;
							}
						}
						this._qjPlayer.moduleLayer.removeModule(delobject.name);
					}
				}
				if(initgobject.group_x_modules != null)
				{
					var modulesData_vector:Vector.<ModuleData> = new Vector.<ModuleData>();
					managerxml.parseModules(modulesData_vector,initgobject.group_x_modules);
					for each(var m:ModuleData in modulesData_vector)
					{
						
						for(var j:Number = 0; j < this._managerData.modulesData.length;j++)
						{
							var md:ModuleData = this._managerData.modulesData[j];
							if(md.name == m.name)
							{
								this._managerData.modulesData[j] = m;
								break;
							}
						}
			
						//删除模块
						this._qjPlayer.moduleLayer.removeModule(m.name);
					}
					
					
					
					var modulesLoader:UrlLoadablesLoader = new UrlLoadablesLoader();
					modulesLoader.addEventListener(LoadLoadableEvent.LOADED, function(event:LoadLoadableEvent){
						
						if (event.content is Module){
							for each (var moduleData:ModuleData in managerData.modulesData) {
								if ((event.loadable as ModuleData) === moduleData) {
									moduleData.descriptionReference = (event.content as Module).moduleDescription;
									break;
								}
							}
						}
						
						_qjPlayer.modules[event.loadable] = event.content;
						_qjPlayer.moduleLayer.addModule(event.content as Module);
					});
					modulesLoader.load(Vector.<ILoadable>( modulesData_vector));
				}
				if(initgobject.group_x_actions != null)
				{
					managerxml.parseActions(managerData.actionsData,initgobject.group_x_actions);
				}
			}
		}
		
		//运行JS
		public function runJsAction(jsaction:String, ... args):void
		{
			
			try
			{
				if(ExternalInterface.available)
				{
					ExternalInterface.call(jsaction,args);
				}
			}
			catch(e:Error)
			{
				trace("js error"+e.message);
			}
		}
		
		
		
		public function addActionContent(jsactionid:String,actioncontent:String):void
		{
			var actionid:String =jsactionid;
			if(jsactionid == "")
			{
				actionid = "id_"+(new Date()).time.toString() +"_"+ Math.random().toString();
			}
			var actionData:ActionData = new ActionData(actionid);
			var managerxml:ManagerDataParserXML = new ManagerDataParserXML();
			managerxml.parseActionContent(actionData,actioncontent);
			
			var isexist:Boolean = false;
			for each(var tmpactiondata:ActionData in _managerData.actionsData)
			{
				if(tmpactiondata.id == actionData.id)
				{
					tmpactiondata.functions = actionData.functions
					isexist = true;
					break;
				}
			}
			if(isexist == false)
			{
				_managerData.actionsData.push(actionData);
			}
			
		}
		
		//运行ACTIONcontent
		public function runActionContent(actioncontent:String):void
		{
				var actionid:String =actionid = "id_"+(new Date()).time.toString() +"_"+ Math.random().toString();
				var actionData:ActionData = new ActionData(actionid);
				var managerxml:ManagerDataParserXML = new ManagerDataParserXML();
				managerxml.parseActionContent(actionData,actioncontent);
				
				_managerData.actionsData.push(actionData);
				this.runAction(actionid);
		}
		
		public function runAction(actionId:String):void {
			var actionData:ActionData = _managerData.getActionDataById(actionId);
			if (actionData == null) {
				if (actionId != null) Trace.instance.printWarning("Action not found: " + actionId);
				return;
			}
			for each(var functionData:FunctionData in actionData.functions) {
				try{
					if(functionData.owner == "ActionsCode")
					{
						(Actioncode.getIntance()[functionData.name] as Function).apply(null, functionData.args);
					}
					else if (functionData.owner == description.name) {
						if (description.functionsDescription[functionData.name] != undefined){
							(this[functionData.name] as Function).apply(this, functionData.args);
						}else {
							_qjPlayer.traceWindow.printError("Unknown function: " + functionData.owner + "." + functionData.name);
						}
					}else{
						(_qjPlayer.getModuleByName(functionData.owner) as Object).execute(functionData);
					}
				}catch (error:Error) {
					_qjPlayer.traceWindow.printError("Could not execute " + functionData.owner + "." + functionData.name + ": " + error.message);
				}
			}
		}
		
		public function getActionList():String
		{
			var actionlist:String = "";
			for each(var actionData:ActionData in _managerData.actionsData) {
				actionlist+=actionData.id+",";
			}
			return actionlist;
		}
		
		public function getAllPanoInfo():String
		{
			var allpanoinfo:Array = new Array();
			for each(var p:PanoramaData in this._managerData.panoramasData)
			{
				var panoinfo:Object = new Object();
				panoinfo.id = p.id;
				panoinfo.pan = this.pan;
				panoinfo.tilt = this.tilt;
				panoinfo.fov =  this.fieldOfView;
				panoinfo.title = p.title;
				panoinfo.desc = p.description;
				panoinfo.gps = p.lngLat;
				panoinfo.hot = new Array();
				for each(var h:HotspotData in p.hotspotsData)
				{
					panoinfo.hot.push(h);
				}
				
				allpanoinfo.push(panoinfo);
			}
			
			
			var panoinfostr:String = com.adobe.serialization.json.JSON.encode(allpanoinfo);
			return panoinfostr;
			
			
		}
		
		public function getCurrentPanoInfo():String
		{
			var panoinfo:Object = new Object();
			panoinfo.id = this.currentPanoramaData.id;
			panoinfo.pan = this.pan;
			panoinfo.tilt = this.tilt;
			panoinfo.fov =  this.fieldOfView;
			panoinfo.title = this.currentPanoramaData.title;
			panoinfo.desc = this.currentPanoramaData.description;
			panoinfo.gps = this.currentPanoramaData.lngLat;
			panoinfo.hot =new Array(); 
			for each(var h:HotspotData in this.currentPanoramaData.hotspotsData)
			{
				panoinfo.hot.push(h);
			}
			
			var panoinfostr:String = com.adobe.serialization.json.JSON.encode(panoinfo);
			return panoinfostr;
		}
		
		
		public function waitThen(time:Number, actionId:String):void {
			var timer:Timer = new Timer(time*1000,1);
			timer.addEventListener(TimerEvent.TIMER, function():void { runAction(actionId) }, false, 0, true);
			timer.start();
		}
		
		public function print(value:String):void {
			_qjPlayer.traceWindow.printInfo(value);
		}
		
		public function loadPano(panramaId:String):void {
			loadPanoramaById(panramaId);
		}
		
		public function loadPanoThen(panramaId:String):void {
			if (panoramaIsMoving) return;
			panoramaIsMoving = true;
			pendingActionpanramaId = panramaId;
			addEventListener(PanoSaladoEvent.SWING_TO_COMPLETE, swingloadPanoThenComplete);
			swingTo(NaN,NaN, 30,100);
		}
		
		
		public function loadPanoToNext(panramaId:String,hotid:String):void {
			
		    var hot:HotspotData = this._currentPanoramaData.hotspotDataById(hotid);
			if(hot != null)
			{
				_prePanoramaDataObject=new Object();
				_prePanoramaDataObject["pan"]=hot.nextpan;
				_prePanoramaDataObject["tilt"]=hot.nexttilt;
				_prePanoramaDataObject["fov"]= hot.nextfov;
			}
			
			loadPanoramaById(panramaId);
			
		}
		
		//加载到下一个场景的热点位置
		public function loadPanoToNextAndMoveToHotspot(panramaId:String,moveToHotid:String):void {
			if(this.currentPanoramaData.id == panramaId)
			{
				moveToHotspot(moveToHotid,30);
			}
			else
			{
				_prePanoramaDataObject=new Object();
				_prePanoramaDataObject["hotid"]= moveToHotid;
				loadPanoramaById(panramaId);
			}
		}
		
		//加载到下一个场景的位置
		public function loadPanoToNextAndMoveToPanTilt(panramaId:String, t_pan:Number,t_tilt:Number,t_fov:Number):void 
		{
			var p_pan:Number = t_pan == -1 ? NaN : t_pan;
			var p_tilt:Number = t_tilt == -1 ? NaN : t_tilt;
			var p_fov:Number =  t_fov == -1 ? NaN : t_fov;
			
			if(this.currentPanoramaData.id == panramaId)
			{
				this.moveToView(p_pan,p_tilt,p_fov);
			}
			else
			{
				_prePanoramaDataObject=new Object();
				_prePanoramaDataObject["pan"]= p_pan;
				_prePanoramaDataObject["tilt"]= p_tilt;
				_prePanoramaDataObject["fov"]= p_fov;
				loadPanoramaById(panramaId);
			}
		}
		

		public function loadPanoFix(panramaId:String,hotspotId:String,t_tilt:Number,fov:Number):void {
			loadPanoramaById(panramaId);
		}
		

		public function loadPanoToPanTilt(hotspotId:String,t_pan:Number,t_tilt:Number,fov:Number,actionId:String):void
		{
			_prePanoramaDataObject=new Object();
			var fieldOfView:Number=this._fieldOfView;
			_prePanoramaDataObject["pan"]=t_pan;
			_prePanoramaDataObject["tilt"]=t_tilt;
			_prePanoramaDataObject["fov"]=fieldOfView;
			
			moveToHotspotThen(hotspotId,fov,actionId);
		}
		
		public function moveToHotspot(hotspotId:String, fieldOfView:Number):void {
			var child:ManagedChild = hotspots[currentPanoramaData.hotspotDataById(hotspotId)];
			if(child != null && child.name == "hotspotpolygonal")
			{
				moveToView(child._childobj.pan,child._childobj.tilt,fieldOfView);
				return;
			}
			if (panoramaIsMoving) return;
			panoramaIsMoving = true;
			pendingActionId = null;
			addEventListener(PanoSaladoEvent.SWING_TO_CHILD_COMPLETE, swingComplete);
			swingToChild(hotspots[currentPanoramaData.hotspotDataById(hotspotId)], fieldOfView);
		}
		
		public function moveToHotspotThen(hotspotId:String, fieldOfView:Number, actionId:String):void {
			var child:ManagedChild = hotspots[currentPanoramaData.hotspotDataById(hotspotId)];
			if(child != null && child.name == "hotspotpolygonal")
			{
				moveToViewThen(child._childobj.pan,child._childobj.tilt,fieldOfView,actionId);
				return;
			}
			if (panoramaIsMoving) return;
			panoramaIsMoving = true;
			pendingActionId = actionId; 
			addEventListener(PanoSaladoEvent.SWING_TO_CHILD_COMPLETE, swingComplete);
			swingToChild(hotspots[currentPanoramaData.hotspotDataById(hotspotId)], fieldOfView);
		}
		
		public function moveToView(pan:Number, tilt:Number, fieldOfView:Number):void {
			if (panoramaIsMoving) return;
			panoramaIsMoving = true;
			pendingActionId = null;
			addEventListener(PanoSaladoEvent.SWING_TO_COMPLETE, swingComplete);
			swingTo(pan, tilt, fieldOfView);
		}
		
		public function moveToViewThen(pan:Number, tilt:Number, fieldOfView:Number, actionId:String):void {
			if (panoramaIsMoving) return;
			panoramaIsMoving = true;
			pendingActionId = actionId;
			addEventListener(PanoSaladoEvent.SWING_TO_COMPLETE, swingComplete);
			swingTo(pan, tilt, fieldOfView);
		}
		
		public function jumpToView(pan:Number, tilt:Number, fieldOfView:Number):void {
			if (panoramaIsMoving) return;
			renderAt(pan, tilt, fieldOfView);
		}
		
		public function jumpToPreView(pan:Number,tilt:Number, fieldOfView:Number):void {
			if (panoramaIsMoving) return;
			if(_prePanoramaDataObject != null)
			{
				var flag:int = 1;
				var hotid:String = _prePanoramaDataObject.hotid;
				if(hotid){
					var hot:HotspotData = this._currentPanoramaData.hotspotDataById(hotid);
					if(hot != null)
					{
						renderAt(hot.location.pan,hot.location.tilt);
						flag = 0;
					}
				}
				if(flag == 1){
					var tpan:Number = _prePanoramaDataObject.pan;
					var ttilt:Number = _prePanoramaDataObject.tilt;
					var tfov:Number = _prePanoramaDataObject.fov;
					renderAt(tpan,ttilt,tfov);
				}
				
				_prePanoramaDataObject = null;
			}
		}
		
		public function jumpToPreView_Fix(pan:Number,tilt:Number, fieldOfView:Number):void {
			if (panoramaIsMoving) return;
			if(_prePanoramaDataObject != null)
			{
				var flag:int = 1;
				var hotid:String = _prePanoramaDataObject.hotid;
				if(hotid){
					var hot:HotspotData = this._currentPanoramaData.hotspotDataById(hotid);
					if(hot != null)
					{
						renderAt(hot.location.pan,hot.location.tilt);
						flag = 0;
					}
				}
				if(flag == 1){
					var tpan:Number = _prePanoramaDataObject.pan;
					var ttilt:Number = _prePanoramaDataObject.tilt;
					var tfov:Number = _prePanoramaDataObject.fov;
					_qjPlayer.traceWindow.printInfo(tpan+","+ttilt);
					renderAt(tpan,ttilt,tfov);
				}
				
				_prePanoramaDataObject = null;
			}
			else
			{
			    renderAt(pan,tilt,fieldOfView);
			}
			
		}
		
	
		
		public function startMoving(panSpeed:Number, tiltSpeed:Number):void {
			if (panoramaIsMoving) return;
			panoramaIsMoving = true;
			startInertialSwing(panSpeed, tiltSpeed);
		}
		
		public function stopMoving():void {
			panoramaIsMoving = false;
			stopInertialSwing();
		}
		
		public function advancedMoveToHotspot(hotspotId:String, fieldOfView:Number, speed:Number, tween:Function):void {
			var child:ManagedChild = hotspots[currentPanoramaData.hotspotDataById(hotspotId)];
			if(child != null && child.name == "hotspotpolygonal")
			{
				advancedMoveToView(child._childobj.pan,child._childobj.tilt,fieldOfView, speed, tween);
				return;
			}
			if (panoramaIsMoving) return;
			panoramaIsMoving = true;
			pendingActionId = null;
			addEventListener(PanoSaladoEvent.SWING_TO_CHILD_COMPLETE, swingComplete);
			swingToChild(hotspots[currentPanoramaData.hotspotDataById(hotspotId)], fieldOfView, speed, tween);
		}
		
		public function advancedMoveToHotspotThen(hotspotId:String, fieldOfView:Number, speed:Number, tween:Function, actionId:String):void {
			var child:ManagedChild = hotspots[currentPanoramaData.hotspotDataById(hotspotId)];
			if(child != null && child.name == "hotspotpolygonal")
			{
				advancedMoveToViewThen(child._childobj.pan,child._childobj.tilt,fieldOfView, speed, tween, actionId);
				return;
			}
			if (panoramaIsMoving) return;
			panoramaIsMoving = true;
			pendingActionId = actionId;
			addEventListener(PanoSaladoEvent.SWING_TO_CHILD_COMPLETE, swingComplete);
			swingToChild(hotspots[currentPanoramaData.hotspotDataById(hotspotId)], fieldOfView, speed, tween);
		}
		
		public function advancedMoveToView(pan:Number, tilt:Number, fieldOfView:Number, speed:Number, tween:Function):void {
			if (panoramaIsMoving) return;
			panoramaIsMoving = true;
			pendingActionId = null;
			addEventListener(PanoSaladoEvent.SWING_TO_COMPLETE, swingComplete);
			swingTo(pan, tilt, fieldOfView, speed, tween);
		}
		
		public function advancedMoveToViewThen(pan:Number, tilt:Number, fieldOfView:Number, speed:Number, tween:Function, actionId:String):void {
			if (panoramaIsMoving) return;
			panoramaIsMoving = true;
			pendingActionId = actionId;
			addEventListener(PanoSaladoEvent.SWING_TO_COMPLETE, swingComplete);
			swingTo(pan, tilt, fieldOfView, speed, tween);
		}
		
		public function advancedStartMoving(panSpeed:Number, tiltSpeed:Number, sensitivity:Number, friction:Number, threshold:Number):void {
			if (panoramaIsMoving) return;
			panoramaIsMoving = true;
			startInertialSwing(panSpeed, tiltSpeed, sensitivity, friction, threshold);
		}
		
		
	
		public function LoadNextPano(str:String):void
		{
			
			if (_managerData.panoramasData != null ) {
				
				var mpanoarr:Array = new Array();
				var i:int = 0;
				
				if(str == "default")
				{
					for(i = 0 ;i < _managerData.panoramasData.length; i++)
					{
						var pid:String = _managerData.panoramasData[i].id;
						if(pid ==  this.currentPanoramaData.id)
						{
							var nextid:int = i+1;
							//下一个
							if(nextid < _managerData.panoramasData.length)
							{
								loadPanoramaById(_managerData.panoramasData[nextid].id);
								
								return;
							}
							else
							{
								//回到第一个
								loadPanoramaById(_managerData.panoramasData[0].id);
								return;
							}
						}
					}
				}
				else if(str.indexOf("default_fix") > -1)
				{
					for(i = 0 ;i < _managerData.panoramasData.length; i++)
					{
						pid = _managerData.panoramasData[i].id;
						if(pid ==  this.currentPanoramaData.id)
						{
							nextid = i+1;
							//下一个
							if(nextid < _managerData.panoramasData.length)
							{
								var t_pan:Number = this._pan;
								var t_tilt:Number = this._tilt;
								
								_prePanoramaDataObject=new Object();
								var fieldOfView:Number=this._fieldOfView;
								_prePanoramaDataObject["pan"]=t_pan;
								_prePanoramaDataObject["tilt"]=t_tilt;
								_prePanoramaDataObject["fov"]=fieldOfView;
								
								

								
								var panoid:String = _managerData.panoramasData[nextid].id;
								
								//去掉定位场景
								var noarr:Array = str.split("|");
								for(var j:int=0;j< noarr.length;j++)
								{
									if(noarr[j] == panoid)
									{
										_prePanoramaDataObject = null;
										break;
									}
								}
								
								loadPanoramaById(panoid);
								
								return;
							}
						}
					}
				}
				else
				{
				
					mpanoarr = str.split("|");
					
					for(i = 0 ;i < mpanoarr.length; i++)
					{
						pid = mpanoarr[i];
						if(pid ==  this.currentPanoramaData.id)
						{
							nextid = i+1;
							//下一个
							if(nextid < mpanoarr.length)
							{
								loadPanoramaById(mpanoarr[nextid]);
								
								return;
							}
						}
					}
					
					
				
				}
			
			}
			
		}
		public function loadPrePano(str:String):void
		{
			if (_managerData.panoramasData != null ) {
				
				var mpanoarr:Array = new Array();
				var i:int = 0;
				var pid:String = "";
				
				if(str == "default")
				{
				
					for(i = 0 ;i < _managerData.panoramasData.length; i++)
					{
						pid = _managerData.panoramasData[i].id;
						if(pid ==  this.currentPanoramaData.id)
						{
							var preid:int = i - 1;
							//上一个
							if(preid >= 0)
							{
								loadPanoramaById(_managerData.panoramasData[preid].id);
								
								return;
							}
							else
							{
								//回到最后一个
								loadPanoramaById(_managerData.panoramasData[_managerData.panoramasData.length - 1].id);
								return;
							}
						}
					}
					
				}
				else if(str.indexOf("default_fix") > -1)
				{
					for(i = 0 ;i < _managerData.panoramasData.length; i++)
					{
						pid = _managerData.panoramasData[i].id;
						if(pid ==  this.currentPanoramaData.id)
						{
							preid = i - 1;
							//上一个
							if(preid >= 0)
							{
								var t_pan:Number = this._pan;
								var t_tilt:Number = this._tilt;
								
								_prePanoramaDataObject=new Object();
								var fieldOfView:Number=this._fieldOfView;
								_prePanoramaDataObject["pan"]=t_pan;
								_prePanoramaDataObject["tilt"]=t_tilt;
								_prePanoramaDataObject["fov"]=fieldOfView;
								
								
								var panoid:String = _managerData.panoramasData[preid].id;
								
								//去掉定位场景
								var noarr:Array = str.split("|");
								for(var j:int=0;j< noarr.length;j++)
								{
									if(noarr[j] == panoid)
									{
										_prePanoramaDataObject = null;
										break;
									}
								}
								
								
								loadPanoramaById(panoid);

								return;
							}
						}
					}
				}
				else 
				{
					
					mpanoarr = str.split("|");
					
					for(i = 0 ;i < mpanoarr.length; i++)
					{
						pid = mpanoarr[i];
						if(pid ==  this.currentPanoramaData.id)
						{
							preid = i - 1;
							//上一个
							if(preid >= 0)
							{
								loadPanoramaById(mpanoarr[preid]);
								
								return;
							}
						}
					}
				}
				
			}
		}
		
		public function LoadPotHotDetail(src:String,swf:String,name:String):void
		{
			
			switch(name)
			{ 
				case "Yiwu":
					
					if( YiwuPlugin.getInstance().isloaded == false )
					{
						YiwuPlugin.getInstance().load(src,swf,this);
					}
					else
					{
						YiwuPlugin.getInstance().toggle();
					}
					break;
				
			}
			
		
			
		}
		
		
		
		
		
	
		/**
		 * 有新的配置
		 */
		public function newConfig(url:String):void{
			reloadConfig(url);
		}
		
		/**
		 * 设置容器大小
		 */
		public function setWH(w:Number,h:Number):void{
			this.boundsWidth = w;
			this.boundsHeight = h;
			global.IS_SET_SHOW_WIDTH_AND_HEIGHT = true;
		}
	}
}
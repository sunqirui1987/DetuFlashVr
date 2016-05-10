package com.panozona.player.manager
{
	import com.panosalado.events.CameraEvent;
	import com.panosalado.events.ReadyEvent;
	import com.panosalado.events.ViewEvent;
	import com.panosalado.model.Params;
	import com.panosalado.model.ViewData;
	import com.panosalado.view.ManagedChild;
	import com.panozona.modules.infobubble.model.structure.Text;
	import com.panozona.player.manager.data.actions.ActionData;
	import com.panozona.player.manager.data.actions.FunctionData;
	import com.panozona.player.manager.data.panoramas.PanoramaData;
	import com.panozona.player.manager.data.streetview.StreetviewArrowData;
	import com.panozona.player.manager.data.streetview.StreetviewHotspotData;
	import com.panozona.player.manager.data.streetview.StreetviewPanoramaData;
	import com.panozona.player.manager.data.streetview.StreeviewArrow;
	import com.panozona.player.manager.data.streetview.StreeviewArrowHotpot;
	import com.panozona.player.manager.data.streetview.StreeviewBranding;
	import com.panozona.player.manager.data.streetview.StreeviewCompass;
	import com.panozona.player.manager.data.streetview.StreeviewPoint;
	import com.panozona.player.manager.events.PanoramaEvent;
	import com.panozona.player.manager.utils.Trace;
	import com.panozona.player.manager.utils.UrlParser;
	import com.panozona.player.module.data.property.Geolocation;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import caurina.transitions.Tweener;
	
	
	public class StreetManager extends Manager
	{
		
		
		
		private var xmlLoader:URLLoader;
		
		private var calledPano:String;
		private var panoWasLoaded:Boolean;
		private var loadedId:String;
		
		
		public var streetviewarrow:StreeviewArrow;
		public var streetviewpoint:StreeviewPoint;
		
		private var _prepan:Number = 0;
		private var _pretilt:Number = 0;
		private var _prefov:Number = 90;
		private var streeviewBranding:StreeviewBranding=null;

		
		//得到正北方角 的Pan度数
		private var _northDegreePan:Number = 0;
		
		//场景方向夹角数组
		private var _directionarrowarr:Vector.<StreetviewArrowData> = new Vector.<StreetviewArrowData>();
		
		
		public function StreetManager(){
			super();
			
			if (stage) stageReady();
			else addEventListener(Event.ADDED_TO_STAGE, stageReady, false, 0, true);
		}
		
		public function get northDegreePan():Number
		{
			return this._northDegreePan;
		}
		public function get directionarrowarr():Vector.<StreetviewArrowData>
		{
			return this._directionarrowarr;
		}
		
		private function stageReady(e:Event = null):void {
			
			streetviewpoint = new StreeviewPoint(this);
			this.addChild(streetviewpoint);
			
			var streetviewcompass:StreeviewCompass = new StreeviewCompass(this);
			this.addChild(streetviewcompass);
			streetviewcompass.x = 10;
			streetviewcompass.y = 10;
			
			streeviewBranding = new StreeviewBranding(this);
			addChild(streeviewBranding);
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
			this.addEventListener(ViewEvent.BOUNDS_CHANGED, handleResize, false, 0, true);
			
			ExternalInterface.addCallback("flashcallPano", flashcallPano);
			
			
		}
		
		
		private function onEnterFrame(e:Event):void {
			this.managerData.controlData.autorotationCameraData.isAutorotating=false;
			
			
			if(this.pan != 0)
			{
				_prepan = this.pan;
			}
			if(this.tilt != 0)
			{
				_pretilt = this.tilt;
			}
			if(this.fieldOfView != 90)
			{
				_prefov  = this.fieldOfView;
			}
			
			
			
		}
		private function handleResize(e:ViewEvent):void
		{
			if(streetviewarrow != null)
			{
				streetviewarrow.x = 0;
				streetviewarrow.y = this.boundsHeight/2 - 150 ;
				
			}
		}
		
		
		override public function loadFirstPanorama():void {
			panoWasLoaded = true;
			
			if (calledPano != null){
				flashcallPano(calledPano);
				calledPano = null;
			}
			try {
				
				var urlParser:UrlParser = new UrlParser(ExternalInterface.call("window.location.href.toString"));
				var fxml:String = "";
				if(urlParser.pano != null){
					_prepan = urlParser.heading;
					_pretilt = urlParser.pitch;
					_prefov  =  urlParser.fov;
					loadStreetviewPano(urlParser.pano,"true",_prepan);	
					
				}else if (_managerData.streetviewData.resources.start != null) {
					var start:String = _managerData.streetviewData.resources.start;	
					loadStreetviewPano(start,"true");
				}
			}catch (error:Error) {
				trace(error.message);
			}
		}
		
		private function flashcallPano(panoIdentifyier:String):void {
			if (!panoWasLoaded){
				calledPano = panoIdentifyier;
				return;
			}
			loadStreetviewPano(panoIdentifyier);
		}
		
		
		
		public function loadStreetviewPano(panoramaId:String,isfix:String = "",direction:Number = -1,distance:Number = -1):void {
			if (!_managerData.getPanoramaDataById(panoramaId) is StreetviewPanoramaData) {
				super.loadPano(panoramaId);
				return;
			}
			loadedId = panoramaId;
			xmlLoader = new URLLoader();
			xmlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			try {
				xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, xmlLost, false, 0, true);
				xmlLoader.addEventListener(Event.COMPLETE, xmlLoaded, false, 0, true);
				var url:String=buildDescriptionPath(panoramaId);
				url =  url + (url.indexOf("?") > 0 ? "&" : "?")+"isfix=" + isfix.toString();
				url =  url + (url.indexOf("?") > 0 ? "&" : "?")+"direction=" + direction.toString();
				url =  url + (url.indexOf("?") > 0 ? "&" : "?")+"distance=" + distance.toString();
				url =  url + (url.indexOf("?") > 0 ? "&" : "?")+"v=" + new Date().getTime();
				
				xmlLoader.load(new URLRequest(url));
			}catch (error:Error) {
				trace(error.message);
			}
		}
		private function xmlLost(error:IOErrorEvent):void {
			xmlLoader.removeEventListener(IOErrorEvent.IO_ERROR, xmlLost);
			xmlLoader.removeEventListener(Event.COMPLETE, xmlLoaded);
			Trace.instance.printError("Failed to load configuration file: ");
		}
		
		
		
		
		
		private function xmlLoaded(event:Event):void {
			cleanPanoramasData(loadedId);
			cleanActionsData();
			
			var input:ByteArray = event.target.data;
			try {input.uncompress()}catch (error:Error) {}
			
			try {
				var panoxml:XML = XML(input);
				var streetviewPanoramaData:StreetviewPanoramaData;
				
				var panoid:String = panoxml.pano.@panoid
				var fxml:String =  buildImagesPath(panoid) ;
				streetviewPanoramaData = new StreetviewPanoramaData(panoid,fxml);
				streetviewPanoramaData.direction = Number(panoxml.pano.@direction);
				streetviewPanoramaData.params.minVerticalFov = -65;
				streetviewPanoramaData.params.maxVerticalFov = 65;
				streetviewPanoramaData.params.maxFov = 95;
				streetviewPanoramaData.params.minFov = 60;
				streetviewPanoramaData.params.maxPixelZoom = 0.5;
				_managerData.panoramasData.push(streetviewPanoramaData);
				
				
				this.managerData.controlData.autorotationCameraData.isAutorotating=false;
				
				
				
				if(panoxml.pano.@initpan != "" && panoxml.pano.@initpan != "-1" )
				{
					this._pan = Number(panoxml.pano.@initpan);
					_prepan = this._pan;
				}
				var direction:Number = streetviewPanoramaData.direction;
				
				///  正北方向
				this._northDegreePan =  -direction;
				
				
				var mainGpsData:Geolocation = new Geolocation();
				mainGpsData.x = Number(panoxml.pano.@x);
				mainGpsData.y = Number(panoxml.pano.@y);
				
				var powerbytxt:String = String(panoxml.pano.@powerby);
				streeviewBranding.powerby = powerbytxt;
				
				ExternalInterface.call("flashloadpano", streetviewPanoramaData.id, _prepan,_pretilt,_prefov,mainGpsData.x,mainGpsData.y);
				super.loadPanoramaById(streetviewPanoramaData.id);
				
				
				
				this._directionarrowarr = new Vector.<StreetviewArrowData>();

				for each(var neighbour:XML in panoxml.neighbours.children()) {
					var neipanoid:String = neighbour.@path;
					
					var arrowdata:StreetviewArrowData = new StreetviewArrowData();
					arrowdata.panoid  = neipanoid;
					arrowdata.direct  = Number(neighbour.@direction);
					arrowdata.txtdirect = Number(neighbour.@txtdirection);
					arrowdata.x  = Number(neighbour.@x);
					arrowdata.y  = Number(neighbour.@y);
					arrowdata.text  = String(neighbour.@text);
					//取得方位信息
					_directionarrowarr.push(arrowdata);
					
					
				}
				trace(this._directionarrowarr)
				
				streetviewarrow = new StreeviewArrow(this);
				streetviewarrow.x = 0;
				streetviewarrow.y = this.boundsHeight/2 - 150  ;// (this.boundsHeight - this.streetviewarrow.height ) ;
				streetviewarrow.z = 500;
				
				
				
				
				
			}catch (error:Error) {
				trace(error.getStackTrace());
			}
		}
		
		
		
		
		
		private function buildDescriptionPath(path:String):String {
			var result:String = "";
			if (_managerData.streetviewData.resources.url == null) {
				result += _managerData.streetviewData.resources.directory;
				if (_managerData.streetviewData.resources.prefix != null) {
					result += _managerData.streetviewData.resources.prefix;
				}
				result += path + ".xml";
			}else {
				result += _managerData.streetviewData.resources.url + path;
			}
			return result;
		}
		
		private function buildImagesPath(path:String):String {
			var result:String = "";
			result += _managerData.streetviewData.resources.directory;
			if (_managerData.streetviewData.resources.prefix != null) {
				result += _managerData.streetviewData.resources.prefix;
			}
			var pattern:RegExp = /%s/g;
			result = result.replace(pattern,path);
			
			return result;
		}
		
		private function cleanPanoramasData(excpetion:String):void {
			var tmpPanoramasData:Vector.<PanoramaData> = new Vector.<PanoramaData>();
			for each(var panoramaData:PanoramaData in _managerData.panoramasData) {
				if (!(panoramaData is  StreetviewPanoramaData) || panoramaData.id == excpetion) {
					tmpPanoramasData.push(panoramaData);
				}
			}
			while (_managerData.panoramasData.length > 0) {
				_managerData.panoramasData.pop();
			}
			for each(panoramaData in tmpPanoramasData) {
				_managerData.panoramasData.push(panoramaData);
			}
		}
		
		private function cleanActionsData():void {
			var tmpActionsData:Vector.<ActionData> = new Vector.<ActionData>();
			for each(var actionData:ActionData in _managerData.actionsData) {
				if (!(actionData is ActionData)) {
					tmpActionsData.push(actionData);
				}
			}
			while (_managerData.actionsData.length > 0) {
				_managerData.actionsData.pop();
			}
			for each(actionData in tmpActionsData) {
				_managerData.actionsData.push(actionData);
			}
		}
		
		override protected function panoramaLoaded(e:Event):void {
			super.panoramaLoaded(e);
			if(streetviewarrow != null)
			{
				this.addChild(streetviewarrow);
				updateChildren(this);
			}
			this._pan = _prepan;
			this._tilt = _pretilt;
			
		}
		
		
		override  protected function updateChildren(viewData:ViewData):void {
			for (var i:int = 0; i < _managedChildren.numChildren; i++) {
				var child:ManagedChild = _managedChildren.getChildAt(i) as ManagedChild;
				var matrix3D:Matrix3D = child._matrix3D;
				if (child.invalid) {
					matrix3D.recompose(child._decomposition);
					child.invalid = false;
				}
				
				matrix3D = matrix3D.clone();
				if(child as StreeviewArrow)
				{
					matrix3D.appendTranslation(0, 0, -500);
					
					var rx:Number = 0;
					if(this._pan >= -45 && this._pan <= 25)
					{
						rx  =  30;
					}
					else if(this._pan > 25 && this._pan <= 45)
					{
						rx  =  29.89;
					}
					else if(this._pan > 45 && this._pan <= 135)
					{
						rx =  29.80;
					}
					else if(this._pan > 135 && this._pan <= 180)
					{
						rx  =  29.75;
					}
					else if(this._pan > -180 && this._pan <= -135)
					{
						rx  =  29.75;
					}
					else if(this._pan > -135 && this._pan <= -45)
					{
						rx  =  29.80;
					}
					else if(this._pan > -45 && this._pan <= -25)
					{
						rx  =  29.85;
					}
					else
					{
						rx  =  29.75;
					}
					
					this.streetviewarrow.rotationX = rx;
					
					
					
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
					
				}
				else
				{
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
		}
		
		override protected function commitPath(e:ReadyEvent, updateFOV:Boolean = true):void {
			dispatchEvent(new CameraEvent(CameraEvent.ACTIVE));
			var path:String = e.tilePyramid.path;
			var params:Params = _params[path];
			
			if (params == null) { //path was set directly, so go to super's behavior directly
				super.commitPath(e, true);
				return;
			}
			
			if (canvas != null && canvas.width > 0 && canvas.height > 0) { // COREMOD, entire section
				try{
					var bd:BitmapData = new BitmapData(canvas.width, canvas.height);
					bd.draw(canvas);
					var bmp:Bitmap = new Bitmap(bd);
					bmp.alpha = canvas.alpha;
					_background.addChild(bmp);
					
					
				}catch(e:Error){}
			}
			updateFOV = (params.minFov) ? true : false ;
			_params[path] = null;
			params.path = null;
			params.copyInto(this as ViewData);
			super.commitPath(e, updateFOV);
			dispatchEvent( new CameraEvent(CameraEvent.INACTIVE));
		}
		
		
		
		
		
	}
}
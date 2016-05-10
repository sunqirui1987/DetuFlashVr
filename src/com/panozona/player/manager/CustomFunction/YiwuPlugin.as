package com.panozona.player.manager.CustomFunction
{
	import com.panosalado.view.Hotspot;
	import com.panosalado.view.ManagedChild;
	import com.panozona.player.manager.Manager;
	import com.panozona.player.manager.data.panoramas.HotspotData;
	import com.panozona.player.manager.events.PanoramaEvent;
	import com.panozona.player.module.data.property.Location;
	import com.panozona.player.module.data.property.Mouse;
	import com.panozona.player.module.data.property.Transform;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.filters.DisplacementMapFilterMode;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;

	
	public class YiwuPlugin 
	{
		//对外
		
		public  var isloaded:Boolean=false; //插件是否
		
	   //内部	
		private var _yiwuxmlArray:Array = new Array();
		private var _manager:Manager;
		private var _hotpotArray:Array = new Array();
		private var _swf:String;
		private var _src:String;
		private var _load:Loader;

		private var _isshow:Boolean=false;//是否显示
		private var _swf_loaded:Boolean=false;
		
		
		private var _swf_show:MovieClip;
		
		
		[Embed(source="tmp.png")]
		private static var hotpottmp:Class;
		[Embed(source="tt1.swf")]
		private static var hotpotshow:Class;
		
		//实例
		private static var _instance:YiwuPlugin;
		
		public function YiwuPlugin(enforcer:SingletonEnforcer) {
			
			
		}
		
		public static function getInstance():YiwuPlugin {
			
			if(YiwuPlugin._instance == null) {
				YiwuPlugin._instance = new YiwuPlugin(new SingletonEnforcer());
			}
			return YiwuPlugin._instance;
		}
		
		
		//加载
		public function load(src:String,swf:String,manager:Manager):void
		{
			
			if(_swf_loaded==true)
			{
				show();
				return;
			}
			
			_swf_loaded = true;
			isloaded = true;
			_isshow =true;
			
			
			this._manager = manager;
			this._swf = swf;
			this._src = src;
		
			this._manager.addEventListener(PanoramaEvent.PANORAMA_LOADED,panoloadHandler);
			
			
			_manager.managerData.controlData.arcBallCameraData.enabled=false;
			_manager.managerData.controlData.scrollCameraData.enabled=false;
			_manager.managerData.controlData.autorotationCameraData.isAutorotating=false;
			
			this._manager.addEventListener(MouseEvent.CLICK,mouseclickHandler);
			
			

			var loader:Loader = new Loader();
			var o:Object = new hotpotshow() as MovieClip;
			var ld:Loader = o.getChildAt(0) as Loader;
			var bytes:ByteArray = ld.contentLoaderInfo.bytes;
			loader.contentLoaderInfo.addEventListener("complete",swfshowcompletehandler);
			loader.loadBytes(bytes);
			

		}
		private function swfshowcompletehandler(e:Event):void
		{
			
			_swf_show = e.target.loader.content as  MovieClip;
			_swf_show.visible=false;
			_swf_show.mouseEnabled=false;
			this._manager.addChild(_swf_show);
			
			var url:URLRequest=new URLRequest(_src);
			var xmlLoader:URLLoader= new URLLoader();
			xmlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			xmlLoader.addEventListener(Event.COMPLETE,LoadPotHotDetailCompleteHandler);
			xmlLoader.load(url);
		}
		
		
		
		public function panoloadHandler(e:PanoramaEvent):void
		{
			_swf_loaded = false;
			isloaded =  false;
			_isshow =  false;
			_yiwuxmlArray = new Array();
			_hotpotArray = new Array();
		}
		
		private var isfirst:Boolean=true;
		public function toggle():void
		{
			if(this._isshow == true)
			{
				hide();
			}
			else
			{
				show();
			}
		}
		public function hide():void
		{
			_isshow =false;
		
			_manager.managerData.controlData.arcBallCameraData.enabled=true;
			_manager.managerData.controlData.scrollCameraData.enabled=true;
			for(var i:int;i<_hotpotArray.length;i++)
			{
				var hos:Hotspot = _hotpotArray[i] as Hotspot;
				hos.visible=false;
				
			}
			
		}
		public function show():void
		{
			_isshow =true;
			
			_manager.managerData.controlData.arcBallCameraData.enabled=false;
			_manager.managerData.controlData.scrollCameraData.enabled=false;
			_manager.managerData.controlData.autorotationCameraData.isAutorotating=false;
			
			if(isfirst == true)
			{
				isfirst = false;
				addManager();
			}
			else
			{
				
				for(var i:int;i<_hotpotArray.length;i++)
				{
					var hos:Hotspot = _hotpotArray[i] as Hotspot;
					hos.visible=true;
				}
			}
			
		}
		
		private function mouseclickHandler(e:MouseEvent):void
		{
			if(_manager.managerData.controlData.arcBallCameraData.enabled==false)
			{
				var pan:String = getCursorPan().toFixed(2);
				var tilt:String = getCursorTilt().toFixed(2) ;
				
	
				ExternalInterface.call("OnClickHandlerCartCursor",pan,tilt,"",this._manager.currentPanoramaData.id);
				ExternalInterface.call("OnClickHandlerAddCursor",pan,tilt,"",this._manager.currentPanoramaData.id);
			}
		
		}
		
		private var __toDegrees:Number = 180 / Math.PI;
		private var __toRadians:Number = Math.PI / 180;
		private function getCursorPan():Number {
			return validatePanTilt(_manager._pan +
				Math.atan((_manager.mouseX -_manager.boundsWidth * 0.5)
					* Math.tan(_manager.fieldOfView * 0.5 * __toRadians) / (_manager.boundsWidth * 0.5)) * __toDegrees);
		}
		
		private var verticalFieldOfView:Number
		private function getCursorTilt():Number {
			verticalFieldOfView = __toDegrees * 2 * Math.atan((_manager.boundsHeight / _manager.boundsWidth)
				* Math.tan(__toRadians * 0.5 * _manager.fieldOfView));
			return validatePanTilt( _manager._tilt -
				Math.atan((_manager.mouseY -_manager.boundsHeight * 0.5)
					* Math.tan(verticalFieldOfView * 0.5 * __toRadians) / (_manager.boundsHeight * 0.5)) * __toDegrees);
		}
		private function validatePanTilt(value:Number):Number {
			if (value <= -180) value = (((value + 180) % 360) + 180);
			if (value > 180) value = (((value + 180) % 360) - 180);
			return value;
		}
		
		
		
		
		private function LoadPotHotDetailCompleteHandler(event:Event):void
		{
			_yiwuxmlArray = new Array();
			var input:ByteArray = event.target.data;
			try {input.uncompress();} catch (error:Error) {}
			var settings:XML;
			try {
				settings = XML(input.toString());
			}catch (error:Error) {				
				return;
			}
			
			
			for each(var hotxml:XML in settings.hots.hot)
			{
				var yiwuxml:YiwuXml=new YiwuXml();
				yiwuxml.locx = hotxml.locx;
				yiwuxml.locy = hotxml.locy;
				yiwuxml.name = hotxml.name;
				yiwuxml.price = hotxml.price;
				yiwuxml.memo = hotxml.memo;
				yiwuxml.sceneid = hotxml.sceneid;
			
				
				_yiwuxmlArray.push(yiwuxml);
				
				
			}
			
			
			
			show();

			
			
		}
		
		
		private function addManager():void
		{
			//_manager.managerData.controlData.arcBallCameraData.enabled=false;
			//转换成热点
			for(var i:int=0;i<_yiwuxmlArray.length;i++)
			{				
				var xml:YiwuXml=_yiwuxmlArray[i];
				if(xml.sceneid != this._manager.currentPanoramaData.id && xml.sceneid != null && xml.sceneid!="")
				{
					continue;
				}
				var hotpotdata:HotspotData=new HotspotData("yiwu_"+i.toString());
				hotpotdata.location=new Location();
				hotpotdata.location.pan = xml.locx;
				hotpotdata.location.tilt = xml.locy;
				hotpotdata.location.distance = xml.locz;
				hotpotdata.transform=new Transform();
				hotpotdata.transform.flat=true;
				
				
				var bitmapdata:BitmapData=new hotpottmp().bitmapData;
		
		
				var obj:DisplayObject = new Bitmap(bitmapdata,"auto",true);
				
			
					/*
				var mv:MovieClip = obj as MovieClip;
				mv.Name = xml.name;
				mv.Price = xml.price;
				mv.Memo = xml.memo;
				*/
					
				var hos:Hotspot=new Hotspot(obj);
				hos.visible=true;
				
				var tmpFunction:Function=getMouseEventHandler(hotpotdata,xml);
				var overtmpFunction:Function = getMouseOverEventHandler(hotpotdata,xml);
				hos.addEventListener(MouseEvent.CLICK,tmpFunction);
				hos.addEventListener(MouseEvent.MOUSE_OVER,overtmpFunction);
				hos.addEventListener(MouseEvent.MOUSE_OUT,mouseouthander);
				
				
				_hotpotArray.push(hos);
				
				
				if(!_manager.contains(hos as ManagedChild))
				{
	
					_manager.addHotspot(hos as ManagedChild ,hotpotdata);
				}
				
			}
		}
		private function mouseouthander(e:MouseEvent):void
		{
			this._swf_show.visible=false;
		}
		
		private function  getMouseOverEventHandler(hotpotdata:HotspotData,xml:YiwuXml):Function{
			var pan:Number = hotpotdata.location.pan;
			var tilt:Number = hotpotdata.location.tilt;
			
			var name:String = xml.name.toString();
			var price:String = parseInt(xml.price.toString()).toString();
			return function(e:MouseEvent):void {
				e.stopPropagation();
				
				
				var mv:MovieClip = _swf_show;
				if(mv == null)
				{
					return;
				}
				mv.Name = xml.name;
				mv.Price = xml.price;
				mv.Memo = xml.memo;
				
				_swf_show.visible=true;
				_swf_show.x = e.stageX + 10;
				_swf_show.y = e.stageY + 10;
				
			}
		}
		
		private function getMouseEventHandler(hotpotdata:HotspotData,xml:YiwuXml):Function{
			var pan:Number = hotpotdata.location.pan;
			var tilt:Number = hotpotdata.location.tilt;
			
			var name:String = xml.name.toString();
			var price:String = parseInt(xml.price.toString()).toString();
			return function(e:MouseEvent):void {
				e.stopPropagation();
				_manager.moveToView(pan,tilt,40);
				
				ExternalInterface.call("OnClickHandlerCartCursor",pan.toFixed(2),tilt.toFixed(2),name,_manager.currentPanoramaData.id);
				ExternalInterface.call("OnClickHandlerAddCursor",pan.toFixed(2),tilt.toFixed(2),name,_manager.currentPanoramaData.id);
			
		
				
			}
		}
		
		public function duplicateDisplayObject(
			source:DisplayObject, 
			autoAdd:Boolean = false
		):DisplayObject
		{
			// create duplicate
			var sourceClass:Class = Object(source).constructor;
			var duplicate:DisplayObject = new sourceClass();
			
			// duplicate properties
			duplicate.transform = source.transform;
			duplicate.filters = source.filters;
			duplicate.cacheAsBitmap = source.cacheAsBitmap;
			duplicate.opaqueBackground = source.opaqueBackground;
			if (source.scale9Grid) {
				var rect:Rectangle = source.scale9Grid;
				// WAS Flash 9 bug where returned scale9Grid is 20x larger than assigned
				// rect.x /= 20, rect.y /= 20, rect.width /= 20, rect.height /= 20;
				duplicate.scale9Grid = rect;
			}
			
			// add to source parent's display list
			// if autoAdd was provided as true
			if (autoAdd && source.parent) {
				source.parent.addChild(duplicate);
			}
			return duplicate;
		}    
		
	}
}

class YiwuXml
{
	public var locx:Number;
	public var locy:Number;
	public var locz:Number=1200;// 默认参数
	public var sceneid:String="";
	public var name:String;
	public var price:String;
	public var memo:String;
}
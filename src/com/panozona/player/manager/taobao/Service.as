package com.panozona.player.manager.taobao
{
	import com.panozona.player.manager.ModuleLayer;
	import com.panozona.player.manager.events.ConfigurationEvent;
	import com.panozona.player.manager.utils.configuration.ManagerDataParserFlashvars;
	import com.panozona.player.manager.utils.configuration.ManagerDataParserXML;
	import com.panozona.player.module.global;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;

	public class Service
	{
		public var CdnUrlData:Array = [];
		public var Mastercallfun:Function = null;
		
		static private var instance:Service;  /* 单例类实例 */
		
		static public function getInstance():Service
		{
			if (!instance) instance = new Service();
			
			return instance;
		}
		
		public function Service() 
		{
		
		}

		
		public static function Instance():Service{
			
			return new Service();
		} 
		
		public function loadfileSyncConfig(url:String,callfun:Function):void
		{
			Mastercallfun = callfun;
			
			var xmlLoader:URLLoader = new URLLoader();
			xmlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			try {
				xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, configurationLost);
				xmlLoader.addEventListener(Event.COMPLETE, configurationLoaded);
				xmlLoader.load(new URLRequest(url));
			}catch (error:Error) {
				
			}
		}
		
		public function filterpathurl(pathurl:String):String
		{
			
			var tmp:String = pathurl;
			if(CdnUrlData != null)
			{
				for(var i:int=0;i<this.CdnUrlData.length;i++)
				{
					var obj:Object = this.CdnUrlData[i];
					var orginurl:String = obj.orginurl;
					var tourl:String = obj.tourl;
					
					if(pathurl.indexOf(orginurl) > -1)
					{
					
						var regex:RegExp = /http:\/\/img\d+\./i;
						tourl = tourl.replace(regex,"http://img01.");
						return tourl;
					}
				}
			}
			
			
			return tmp;
		}	
		
		protected function configurationLost(event:IOErrorEvent):void {
			event.target.removeEventListener(IOErrorEvent.IO_ERROR, configurationLost);
			event.target.removeEventListener(Event.COMPLETE, configurationLoaded);
			if(Mastercallfun != null)
			{
				Mastercallfun();
			}
		}
		
		protected function configurationLoaded(event:Event):void {
			if(Mastercallfun != null)
			{
				Mastercallfun();
			}
			event.target.removeEventListener(IOErrorEvent.IO_ERROR, configurationLost);
			event.target.removeEventListener(Event.COMPLETE, configurationLoaded);
			var input:ByteArray = event.target.data;
			try {input.uncompress();} catch (error:Error) {}
			var settings:XML;
			var str:String = input.toString();
			try {
				settings = XML(str);
			}catch (error:Error) {
				return;
			}
			
			try
			{
				//载入TAOBAO CDN图片资源
				var len:int = settings.file.length()
				
				for (var j:int = 0; j < len; j++)
				{
					var urlxml:XML = settings.file[j]
					var obj:Object=new Object();
					if(String(urlxml.@flag) == "0") { 
						continue;
					}
					obj.orginurl=String(urlxml.@orgin)
					obj.tourl = String(urlxml.@dst)
					
					CdnUrlData.push(obj)
				}
				
			}
			catch(e:Error){
			}
			
		
			
		}
		
		
		
	}
}
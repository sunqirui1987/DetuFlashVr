package com.panozona.modules.guestBook
{
	import com.panozona.modules.guestBook.controller.GuestBookController;
	import com.panozona.modules.guestBook.model.GuestBookData;
	import com.panozona.modules.guestBook.utils.GuestBookDataParseXml;
	import com.panozona.modules.guestBook.view.GuestBookView;
	import com.panozona.player.manager.events.ConfigurationEvent;
	import com.panozona.player.module.Module;
	import com.panozona.player.module.data.ModuleData;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-2-20
	 * 功能描述:留言板模块
	 */
	public class GuestBook extends Module
	{
		/**
		 * 留言板的数据 
		 */		
		private var guestBookData:GuestBookData;
		
		/**
		 * 留言板的视图界面 
		 */		
		private var guestBookView:GuestBookView;
		
		/**
		 * 留言板的控制器
		 */		
		private var guestBookController:GuestBookController;
		
		public function GuestBook()
		{
			super("GuestBook", "1.1", "http://panozona.com/wiki/Module:GuestBook");
			moduleDescription.addFunctionDescription("openGuestBook");
		}
		
		override protected function moduleReady(moduleData:ModuleData):void {
			
			guestBookData = new GuestBookData(moduleData, qjPlayer); // always first
			
			var xmlLoader:URLLoader = new URLLoader();
			xmlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			try {
				xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, configurationLost);
				xmlLoader.addEventListener(Event.COMPLETE, configurationLoaded);
				xmlLoader.load(new URLRequest(guestBookData.setting.dataPath));
			}catch (error:Error) {
				throw new Error("加载留言板数据出错");
			}
		}
		
		protected function configurationLost(event:IOErrorEvent):void {
			event.target.removeEventListener(IOErrorEvent.IO_ERROR, configurationLost);
			event.target.removeEventListener(Event.COMPLETE, configurationLoaded);
			throw new Error("加载留言板数据出错");
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
				throw new Error("加载留言板数据出错");
				return;
			}
			
			var guestBookDataParserXML:GuestBookDataParseXml = new GuestBookDataParseXml();
			guestBookDataParserXML.addEventListener(ConfigurationEvent.INFO, printConfigurationMessage, false, 0, true);
			guestBookDataParserXML.addEventListener(ConfigurationEvent.WARNING, printConfigurationMessage, false, 0, true);
			guestBookDataParserXML.addEventListener(ConfigurationEvent.ERROR, printConfigurationMessage, false, 0, true);
			guestBookDataParserXML.configureManagerData(guestBookData.messagesData, settings);
			
			//将显示数据转化成对象
			guestBookData.parseMessageData();
			
			guestBookView = new GuestBookView(guestBookData);
			guestBookController = new GuestBookController(guestBookView, this);
			addChild(guestBookView);
			
		}
		
		protected function printConfigurationMessage(event:ConfigurationEvent):void
		{
			if (event.type == ConfigurationEvent.INFO) {
				trace(event.message);
			}else if (event.type == ConfigurationEvent.WARNING) {
				trace(event.message);
			}else if (event.type == ConfigurationEvent.ERROR) {
				trace(event.message);
			}
		}
		
		
		///////////////////////////////////////////////////////////////////////////////
		//  Exposed functions 
		///////////////////////////////////////////////////////////////////////////////
		
		public function openGuestBook():void{
			guestBookData.windowData.open = true;
		}
	}
}
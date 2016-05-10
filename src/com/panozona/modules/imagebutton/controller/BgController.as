package com.panozona.modules.imagebutton.controller
{
	import com.panozona.modules.imagebutton.view.BgView;
	import com.panozona.player.module.Module;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;

	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-4-17 下午1:18:55
	 * 功能描述:
	 */
	public class BgController
	{
		
		private var module:Module;
		private var bgView:BgView;
		
		public function BgController(bgView:BgView, module:Module) {
			this.module = module;
			this.bgView = bgView;
			
			switch(bgView.bgData.type){//draw为画图，pic为纯背景 ，scale9为九宫格
				case "draw":
				default:
					bgView.drawBg();
					break;
				case "pic":
					if(!bgView.bgData.path)
						return;
					var picLoader:Loader = new Loader();
					picLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onErr);
					picLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, picLoaded);
					picLoader.load(new URLRequest(bgView.bgData.path),new flash.system.LoaderContext(true));
					break;
				case "scale9":
					if(!bgView.bgData.path)
						return;
					var scale9Loader:Loader = new Loader();
					scale9Loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onErr);
					scale9Loader.contentLoaderInfo.addEventListener(Event.COMPLETE,scale9Loaded);
					scale9Loader.load(new URLRequest(bgView.bgData.path),new flash.system.LoaderContext(true));
					break;
			}
		}
		
		protected function scale9Loaded(event:Event):void
		{
			bgView.createScale9(event.target.content);		
		}
		
		protected function picLoaded(event:Event):void
		{
			bgView.setBackGroundPic(event.target.content);			
		}
		
		protected function onErr(event:IOErrorEvent):void
		{
			module.printError(event.text);		
		}
	}
}
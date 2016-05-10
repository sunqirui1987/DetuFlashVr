package com.panozona.modules.menuscroller.controller
{
	import com.panozona.modules.menuscroller.events.WindowEvent;
	import com.panozona.modules.menuscroller.view.IconView;
	import com.panozona.player.module.Module;
	import com.panozona.player.module.data.property.Align;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;

	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-6-25 下午5:07:30
	 * 功能描述:
	 */
	public class IconController
	{
		
		private var view:IconView;
		
		private var module:Module;
		
		public function IconController(view:IconView,module:Module)
		{
			this.view = view;
			this.module = module;
			
			if(view.item.mouse.onClick){
				view.addEventListener(MouseEvent.CLICK,onClick, false, 0, true);
			}
			
			var imageLoader:Loader = new Loader();
			imageLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, imageLost, false, 0, true);
			imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, baseimageLoaded, false, 0, true);
			imageLoader.load(new URLRequest(view.item.baseUrl),new LoaderContext(true));
			
			view.menuScrollerData.windowData.addEventListener(WindowEvent.CHANGED_ELASTIC_WIDTH, showAlign, false, 0, true);
			view.menuScrollerData.windowData.addEventListener(WindowEvent.CHANGED_ELASTIC_HEIGHT, showAlign, false, 0, true);
			showAlign();
		}
		
		protected function onClick(event:MouseEvent):void
		{
			module.qjPlayer.manager.runAction(view.item.mouse.onClick);
		}
		
		private function imageLost(error:IOErrorEvent):void {
			error.target.removeEventListener(IOErrorEvent.IO_ERROR, imageLost);
			error.target.removeEventListener(Event.COMPLETE, baseimageLoaded);
			module.printError(error.text);
		}
		
		private function imageLost2(error:IOErrorEvent):void {
			error.target.removeEventListener(IOErrorEvent.IO_ERROR, imageLost2);
			error.target.removeEventListener(Event.COMPLETE, mouseimageLoaded);
			module.printError(error.text);
		}
		
		private function baseimageLoaded(e:Event):void {
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, imageLost);
			e.target.removeEventListener(Event.COMPLETE, baseimageLoaded);
			view.baseBmd = (e.target.content as Bitmap).bitmapData;
			if(view.item.mouseOverUrl){
				var imageLoader:Loader = new Loader();
				imageLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, imageLost2, false, 0, true);
				imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, mouseimageLoaded, false, 0, true);
				imageLoader.load(new URLRequest(view.item.mouseOverUrl),new LoaderContext(true));
			}
			showAlign();
		}
		
		protected function mouseimageLoaded(event:Event):void
		{
			event.target.removeEventListener(IOErrorEvent.IO_ERROR, imageLost2);
			event.target.removeEventListener(Event.COMPLETE, mouseimageLoaded);	
			view.mouseOverBmd = (event.target.content as Bitmap).bitmapData;
			showAlign();
		}
		
		private function showAlign(event:Event = null):void {
			view.x = getWindowOpenX();
			view.y = getWindowOpenY();
		}
		
		private function getWindowOpenX():Number {
			var result:Number = 0;
			switch(view.item.align.horizontal) {
				case Align.RIGHT:
					result += view.menuScrollerData.windowData.elasticWidth
					- view.width
					+ view.item.move.horizontal;
					break;
				case Align.LEFT:
					result += view.item.move.horizontal;
					break;
				default: // CENTER
					result += (view.menuScrollerData.windowData.elasticWidth 
						- view.width) * 0.5 
					+ view.item.move.horizontal;
			}
			return result;
		}
		
		private function getWindowOpenY():Number{
			var result:Number = 0;
			switch(view.item.align.vertical) {
				case Align.TOP:
					result += view.item.move.vertical;
					break;
				case Align.BOTTOM:
					result += view.menuScrollerData.windowData.elasticHeight
					- view.height
					+ view.item.move.vertical;
					break;
				default: // MIDDLE
					result += (view.menuScrollerData.windowData.elasticHeight
						- view.height) * 0.5
					+ view.item.move.vertical;
			}
			return result;
		}
	}
}
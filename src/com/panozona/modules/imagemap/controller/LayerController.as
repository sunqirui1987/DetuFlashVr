package com.panozona.modules.imagemap.controller
{
	import com.panozona.modules.imagemap.model.structure.MaskCircle;
	import com.panozona.modules.imagemap.model.structure.MaskRect;
	import com.panozona.modules.imagemap.view.LayerView;
	import com.panozona.modules.imagemap.view.WindowView;
	import com.panozona.player.module.Module;
	import com.panozona.player.module.data.property.Align;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;

	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-4-10 下午3:28:11
	 * 功能描述:
	 */
	public class LayerController
	{
		
		private var layerView:LayerView;
		private var module:Module;
		
		private var windowView:WindowView;
		
		public function LayerController(layerView:LayerView,module:Module,windowView:WindowView)
		{
			this.layerView = layerView;
			this.module = module;
			this.windowView = windowView;
			
			var index:int = layerView.layerData.zorder;
			index = Math.max(index,0);
			
			var tempView:Sprite;
			switch(layerView.layerData.parent){
				case "base":
					tempView = windowView;
					break;
				case "window":
					tempView = windowView.container;
					break;
				case "panel":
					tempView = windowView.panelView;
					break;
				case "close":
					tempView = windowView.closeView;
					break;
				case "viewer":
					tempView = windowView.viewerView;
					break;
				case "list":
					tempView = windowView.listView;
					break;
				default:
					tempView = windowView.container;
					break;
			}
			index = Math.min(index,tempView.numChildren);
			if(layerView.layerData.parent != "base"){
				tempView.addChildAt(layerView,index);
			}else{
				windowView.addChild(layerView);
				layerView.mouseEnabled = layerView.layerData.mouseEnabled;
				layerView.mouseChildren = layerView.layerData.mouseChildren;
				var mask:Sprite = new Sprite();
				switch(layerView.layerData.maskType){
					case "rect":
					default:
						var maskData:MaskRect = layerView.layerData.maskRect;
						mask.graphics.beginFill(1,0);
						mask.graphics.drawRect(maskData.x,maskData.y,maskData.width,maskData.height);
						mask.graphics.endFill();
						break;
					case "circle":
						var maskCircle:MaskCircle = layerView.layerData.maskCircle;
						mask.graphics.beginFill(1,0);
						mask.graphics.drawCircle(maskCircle.x,maskCircle.y,maskCircle.radius);
						mask.graphics.endFill();
						break;
				}
				
				windowView.addChild(mask);
				mask.mouseChildren = mask.mouseEnabled = false;
				windowView.setMask(mask);
			}
			
			if(layerView.layerData.handcursor){
				layerView.buttonMode = true;
			}
			
			if(layerView.layerData.onclick){
				layerView.addEventListener(MouseEvent.CLICK,onClick);
			}
			
			if(layerView.layerData.url){
				var imageLoader:Loader = new Loader();
				imageLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, imageLost, false, 0, true);
				imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoaded, false, 0, true);
				imageLoader.load(new URLRequest(layerView.layerData.url),new flash.system.LoaderContext(true));
			}else{
				module.printError("layer url is null");
			}
		}
		
		protected function onClick(event:MouseEvent):void
		{
			module.qjPlayer.manager.runAction(layerView.layerData.onclick);			
		}		
	
		private function imageLost(error:IOErrorEvent):void {
			error.target.removeEventListener(IOErrorEvent.IO_ERROR, imageLost);
			error.target.removeEventListener(Event.COMPLETE, imageLoaded);
			module.printError(error.text);
		}
	
		private function imageLoaded(e:Event):void {
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, imageLost);
			e.target.removeEventListener(Event.COMPLETE, imageLoaded);
			layerView.content = e.target.content;
			placeonWindow();
		}
	
		private function placeonWindow(e:Event = null):void {
			var align:Align = layerView.layerData.align;
			if (align.horizontal == Align.LEFT) {
				layerView.x = 0;
			}else if (align.horizontal == Align.RIGHT) {
				layerView.x = layerView.parent.width - layerView.width;
			}else { // CENTER
				layerView.x = (layerView.parent.width - layerView.width) * 0.5;
			}
			if (align.vertical == Align.TOP){
				layerView.y = 0;
			}else if (align.vertical == Align.BOTTOM) {
				layerView.y = layerView.parent.height - layerView.height;
			}else { // MIDDLE
				layerView.y = (layerView.parent.height - layerView.height) * 0.5;
			}
			layerView.x += layerView.layerData.move.horizontal;
			layerView.y += layerView.layerData.move.vertical;
		}
	}
}
package com.panozona.modules.imagemap.controller
{
	import com.panozona.player.module.utils.ILoader;
	import com.panozona.player.module.utils.Scale9BitmapSprite;
	import com.panozona.player.module.utils.SwfLoader;
	import com.panozona.modules.imagemap.view.CloseView;
	import com.panozona.modules.imagemap.view.PanelView;
	import com.panozona.player.module.Module;
	import com.panozona.player.module.data.property.Align;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;

	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-4-4 下午2:22:43
	 * 功能描述:
	 */
	public class PanelController implements ILoader
	{
		private var _panelView:PanelView;
		private var _module:Module;
		
		public function PanelController(_panelView:PanelView, module:Module){
			this._panelView = _panelView;
			_module = module;
			
			if (_panelView.imageMapData.panel == null){
				return;
			}
			

			SwfLoader.setlLoader(this);
			
			if(_panelView.imageMapData.panel.backPath != null)
			{
				SwfLoader.load(_panelView.imageMapData.panel.backPath,buildBack);
			}
			if(_panelView.imageMapData.panel.closeButtonPath != null)
			{
				SwfLoader.load(_panelView.imageMapData.panel.closeButtonPath,buildButton);
			}
		}
		
		private function buildBack(loaderinfo:LoaderInfo):void{
			var bmd:BitmapData = (loaderinfo.content as Bitmap).bitmapData;
			var h:int = bmd.height;
			var bg:Scale9BitmapSprite = new Scale9BitmapSprite(bmd,new Rectangle(1,1,bmd.width-2,bmd.height-2));
			bg.width = _panelView.imageMapData.windowData.window.size.width;
			bg.height = _panelView.imageMapData.panel.panelHeight;
			_panelView.addChildAt(bg,0);
			
			
		}	
		
		private function buildButton(loaderinfo:LoaderInfo):void{
			var bmd:BitmapData = (loaderinfo.content as Bitmap).bitmapData;
			var bmp:Bitmap = new Bitmap(bmd);
			var sp:Sprite = new Sprite();
			sp.buttonMode = true;
			sp.addChild(bmp);
			sp.addEventListener(MouseEvent.CLICK,handleMouseClick);
			sp.x = _panelView.imageMapData.windowData.window.size.width-sp.width;
			sp.x += _panelView.imageMapData.panel.closeButtonMove.horizontal;
			sp.y += _panelView.imageMapData.panel.closeButtonMove.vertical;
			_panelView.addChild(sp);
			placeonWindow();
		}	
		
		
		private function placeonWindow(e:Event = null):void {
			
			_panelView.x += _panelView.imageMapData.panel.move.horizontal;
			_panelView.y += _panelView.imageMapData.panel.move.vertical;
		}
		
		private function handleMouseClick(e:MouseEvent):void {
			_panelView.imageMapData.windowData.open = false;
		}
		
		public function onCmp(e:Event,url:String):void{}
		
		public function onErr(e:IOErrorEvent,url:String):void{
			_module.printError("load "+url+" err:"+e.text);
		}
		
		public function onProgress(e:ProgressEvent,url:String):void{}
		
		public function loaded(url:String):void
		{
		}
	}
}
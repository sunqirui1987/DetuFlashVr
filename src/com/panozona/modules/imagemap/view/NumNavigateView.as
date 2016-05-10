package com.panozona.modules.imagemap.view
{
	import com.panozona.modules.imagemap.events.ListEvent;
	import com.panozona.modules.imagemap.model.ImageMapData;
	import com.panozona.modules.imagemap.model.structure.List;
	import com.panozona.player.module.Module;
	import com.panozona.player.module.utils.ILoader;
	import com.panozona.player.module.utils.SwfLoader;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-3-11 上午9:54:59
	 * 功能描述:
	 */
	public class NumNavigateView extends Sprite implements ILoader
	{
		private var _imageMapData:ImageMapData;
		
		private var bmd_num:BitmapData;
		private var bmd_tooltip:BitmapData;
		
		private var tooltip:NumNavigateTooltip;
		
		public var printErrorFun:Function;
		private var _module:Module;
		public function NumNavigateView(_imageMapData:ImageMapData,module:Module) {
			_module = module;
			this._imageMapData = _imageMapData;
			super();
		//	addEventListener(Event.ADDED_TO_STAGE,onAddToStage);
		}
		
		public function init():void{
			
			//没有定义过lists
			if(_imageMapData.listData.lists.model == 0)
			{
				return;
			}
			if(!_imageMapData.listData.lists.model1_num_url){
				printError("model1_num_url is null");
				return;
			}
			if(!_imageMapData.listData.lists.model1_tooltip_url){
				printError("model1_tooltip_url is null");
				return;
			}
			
			SwfLoader.setlLoader(this);
			
			if(_imageMapData.listData.lists.model1_num_url != null)
			{
				SwfLoader.load(_imageMapData.listData.lists.model1_num_url,checkBitMapFinish);
			}
			if(_imageMapData.listData.lists.model1_tooltip_url != null)
			{
				SwfLoader.load(_imageMapData.listData.lists.model1_tooltip_url,checkBitMapFinish);
			}
		}
		
//		protected function onAddToStage(event:Event):void
//		{
//			removeEventListener(Event.ADDED_TO_STAGE,onAddToStage);
//			stage.addEventListener(MouseEvent.CLICK,hideTip);
//		}
		
		protected function hideTip():void
		{
			if(tooltip && stage && stage.contains(tooltip))
				stage.removeChild(tooltip);
		}
		
		protected function showTip(data:List,x:int,y:int):void
		{
			if(tooltip){
				tooltip.showString(data.label);
				tooltip.x = x;
				tooltip.y = y;
				if(stage){
					if(!stage.contains(tooltip))
						stage.addChild(tooltip);
					else
						stage.setChildIndex(tooltip,stage.numChildren-1);
				}
			}
		}
		
		private function checkBitMapFinish(loaderinfo:LoaderInfo):void{
			if(loaderinfo.loader.name == _imageMapData.listData.lists.model1_num_url){
				bmd_num = (loaderinfo.content as Bitmap).bitmapData;
			}else if(loaderinfo.loader.name == _imageMapData.listData.lists.model1_tooltip_url){
				bmd_tooltip = (loaderinfo.content as Bitmap).bitmapData;
			}
			if(bmd_num && bmd_tooltip){
				var arr:Array = _imageMapData.listData.lists.getAllChildren();
				for(var i:int=0;i<arr.length;i++){
					var item:NumNavigateViewItemRenderer = new NumNavigateViewItemRenderer(getBmdByNum(i,false),getBmdByNum(i,true),arr[i]);
					item.addEventListener(MouseEvent.ROLL_OVER,onMouseHandel);
					item.addEventListener(MouseEvent.ROLL_OUT,onMouseHandel);
					item.addEventListener(MouseEvent.CLICK,onMouseHandel);
					item.y = i*(item.height+1);
					addChild(item);
				}
				dispatchEvent(new ListEvent(ListEvent.LIST_VIEW_BUILDED));
				
				tooltip = new NumNavigateTooltip(bmd_tooltip,"");
			}
		}
		
		private function onMouseHandel(e:MouseEvent):void{
			var item:NumNavigateViewItemRenderer = e.target as NumNavigateViewItemRenderer;
			if(!item)
				return;
			switch(e.type){
				case MouseEvent.ROLL_OVER:
					var showP:Point = item.localToGlobal(new Point(item.width,0));
					showTip(item.itemData,showP.x+5,showP.y);
					break;
				case MouseEvent.ROLL_OUT:
					hideTip();
					break;
				case MouseEvent.CLICK:
					clearSelect();
					item.select = true;
					_imageMapData.mapData.currentMapId = item.itemData.mapid;
					break;
			}
		}
		
		private function getBmdByNum(num:int,isSelect:Boolean):BitmapData{
			var bmd:BitmapData = new BitmapData(23,30);
			bmd.copyPixels(bmd_num,new Rectangle(num*24,isSelect?31:0,23,30),new Point(0,0));
			return bmd;
		}
		
		public function getItemByMapId(mapId:String):NumNavigateViewItemRenderer{
			for(var i:int=0;i<numChildren;i++){
				var item:NumNavigateViewItemRenderer = getChildAt(i) as NumNavigateViewItemRenderer;
				if(item && item.itemData.mapid == mapId)
					return item;
			}
			return null;
		}
		
		public function clearSelect():void{
			for(var i:int=0;i<numChildren;i++){
				var item:NumNavigateViewItemRenderer = getChildAt(i) as NumNavigateViewItemRenderer;
				if(item)
					item.select = false;
			}
		}
		
		public function showListSelect():void{
			clearSelect();
			var item:NumNavigateViewItemRenderer = getItemByMapId(_imageMapData.mapData.currentMapId);
			if(item)
				item.select = true;
		}
		
		private function printError(info:String):void{
			if(printErrorFun != null){
				printErrorFun(info);
			}
		}
		
		public function onCmp(e:Event,url:String):void{}
		
		public function onErr(e:IOErrorEvent,url:String):void{
			printError("load "+url+" err:"+e.text);
		}
		
		public function onProgress(e:ProgressEvent,url:String):void{}
		
		public function loaded(url:String):void
		{
		}
	}
}
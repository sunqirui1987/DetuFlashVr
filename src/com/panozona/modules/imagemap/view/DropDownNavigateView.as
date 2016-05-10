package com.panozona.modules.imagemap.view
{
	import com.panozona.modules.imagemap.events.ListEvent;
	import com.panozona.modules.imagemap.model.ImageMapData;
	import com.panozona.player.module.Module;
	import com.panozona.player.module.utils.ILoader;
	import com.panozona.player.module.utils.Scale9BitmapSprite;
	import com.panozona.player.module.utils.SwfLoader;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.ByteArray;
	
	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-3-11 下午2:40:14
	 * 功能描述:
	 */
	public class DropDownNavigateView extends Sprite implements ILoader
	{
		
		private var _imageMapData:ImageMapData;
		
		private var bmd_back:BitmapData;
		private var bmd_dropList:BitmapData;
		
		private var bmd_smallArrow:BitmapData;
		private var bmd_triangle:BitmapData;
		private var triangleBmp:Bitmap;
		
		private var dropBg:Scale9BitmapSprite;
		private var dropSp:Sprite;
		
		private var textBg:Scale9BitmapSprite;
		private var text:TextField;
		
		public var printErrorFun:Function;
		
		private const defaultWidth:int = 25;
		
		private var maxLen:int;
		private var _module:Module;
		
		public function DropDownNavigateView(_imageMapData:ImageMapData,module:Module) {
			_module = module;
			
			this._imageMapData = _imageMapData;
			super();
		}
		
		public function init():void{
			if(!_imageMapData.listData.lists.model2_back_url){
				printError("model2_back_url is null");
			}
			if(!_imageMapData.listData.lists.model2_downListBack_url){
				printError("model2_downListBack_url is null");
			}
			if(!_imageMapData.listData.lists.model2_dropListSmallArrow_url){
				printError("model2_dropListSmallArrow_url is null");
			}
			if(!_imageMapData.listData.lists.model2_dropListTriangle_url){
				printError("model2_dropListTriangle_url is null");
			}
			
			SwfLoader.setlLoader(this);
			
			if(_imageMapData.listData.lists.model2_back_url)
				SwfLoader.load(_imageMapData.listData.lists.model2_back_url,checkBitMapFinish);
			if(_imageMapData.listData.lists.model2_downListBack_url)
				SwfLoader.load(_imageMapData.listData.lists.model2_downListBack_url,checkBitMapFinish);
			if(_imageMapData.listData.lists.model2_dropListSmallArrow_url)
				SwfLoader.load(_imageMapData.listData.lists.model2_dropListSmallArrow_url,checkBitMapFinish);
			if(_imageMapData.listData.lists.model2_dropListTriangle_url)
				SwfLoader.load(_imageMapData.listData.lists.model2_dropListTriangle_url,checkBitMapFinish);
			
			addEventListener(Event.ADDED_TO_STAGE,onAddToStage);
		}
		
		protected function onAddToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE,onAddToStage);
			stage.addEventListener(MouseEvent.CLICK,checkHideDropList);
		}
		
		protected function checkHideDropList(event:MouseEvent):void
		{
			if(event.target == textBg || event.target == this)
				return;
			hideDropList();		
		}
		
		private function checkBitMapFinish(loaderinfo:LoaderInfo):void{
			if(loaderinfo.loader.name == _imageMapData.listData.lists.model2_back_url){
				bmd_back = (loaderinfo.content as Bitmap).bitmapData;
			}else if(loaderinfo.loader.name == _imageMapData.listData.lists.model2_downListBack_url){
				bmd_dropList = (loaderinfo.content as Bitmap).bitmapData;
			}else if(loaderinfo.loader.name == _imageMapData.listData.lists.model2_dropListSmallArrow_url){
				bmd_smallArrow = (loaderinfo.content as Bitmap).bitmapData;
			}else if(loaderinfo.loader.name == _imageMapData.listData.lists.model2_dropListTriangle_url){
				bmd_triangle = (loaderinfo.content as Bitmap).bitmapData;
			}
			if(bmd_back && bmd_dropList && bmd_smallArrow && bmd_triangle){
				dropBg = new Scale9BitmapSprite(bmd_dropList,new Rectangle(1,1,41,49));
				dropSp = new Sprite(); 
				
				var arr:Array = _imageMapData.listData.lists.getAllChildren();
				
				for(var i:int=0;i<arr.length;i++){
					var tempLen:int = GetStringLength(arr[i].label);
					if(tempLen > maxLen)
						maxLen = tempLen;
				}
				for(i=0;i<arr.length;i++){
					var item:DropDownNavigateViewItemRenderer = new DropDownNavigateViewItemRenderer(arr[i],i!=arr.length-1,maxLen,_imageMapData);
					item.addEventListener(MouseEvent.CLICK,onMouseHandel);
					item.y = i*(item.height+1)-3;
					dropSp.addChild(item);
				}
				dropBg.addChild(dropSp);
//				dropSp.x = 5;
				dropSp.y = 5;
				dropBg.width = dropSp.width;
//				if(dropBg.width < defaultWidth)
//					dropBg.width = defaultWidth;
				dropBg.height = dropSp.height+3;
				
				var smallArrowBmp:Bitmap = new Bitmap();
				smallArrowBmp.bitmapData = bmd_smallArrow;
				dropBg.addChild(smallArrowBmp);
				smallArrowBmp.x = (dropBg.width-smallArrowBmp.width)*0.5;
				smallArrowBmp.y = -smallArrowBmp.height;
				
				text = new TextField();
				text.x = 1;
				textBg = new Scale9BitmapSprite(bmd_back,new Rectangle(1,1,41,49));
				text.textColor = 0xffffff;
				var format:TextFormat = new TextFormat(null,_imageMapData.listData.lists.fontSize);
				format.align = TextFormatAlign.CENTER;
				format.font = "宋体";
				text.defaultTextFormat = format;
				text.selectable=false;
				text.mouseEnabled = false;
				text.filters=  [new GlowFilter(0x000000,1,2,2,5)];
				text.height = _imageMapData.listData.lists.textHeight;
				text.text = "  ";
				text.multiline = false;
				text.y = (text.height-text.textHeight)/2;
				textBg.addChild(text);
				textBg.buttonMode = true;
				textBg.mouseChildren = false;
				addChild(textBg);
				
				triangleBmp = new Bitmap();
				triangleBmp.bitmapData = bmd_triangle;
				triangleBmp.x = text.width+text.x;
				textBg.addChild(triangleBmp);
				triangleBmp.y = 5;
				
				textBg.addEventListener(MouseEvent.CLICK,showDropList);
				
				showListSelect();
				
				dispatchEvent(new ListEvent(ListEvent.LIST_VIEW_BUILDED));
			}
		}
		
		protected function showDropList(event:MouseEvent):void
		{
			if(dropBg){
				var showP:Point = textBg.localToGlobal(new Point(textBg.width/2,textBg.height+5));
				dropBg.x = showP.x-dropBg.width/2;
				dropBg.y = showP.y;
				if(stage){
					if(!stage.contains(dropBg))
						stage.addChild(dropBg);
					else
						stage.setChildIndex(dropBg,stage.numChildren-1);
				}
			}			
		}
		
		protected function hideDropList():void
		{
			if(dropBg && stage && stage.contains(dropBg))
				stage.removeChild(dropBg);
		}
		
		private function showText(s:String):void{
			if(!text)
				return;
			text.text = s;
			text.width = maxLen*int(text.defaultTextFormat.size)/1.7;
			if(text.width  <defaultWidth)
				text.width = defaultWidth;
			textBg.width = text.width+22;
			textBg.height = text.height;
			triangleBmp.x = text.width+text.x+4;
			triangleBmp.y = 4+(text.height-text.textHeight)/2;
			
	//		defaultWidth
		}
		
		private function onMouseHandel(e:MouseEvent):void{
			var item:DropDownNavigateViewItemRenderer = e.target as DropDownNavigateViewItemRenderer;
			if(!item)
				return;
			switch(e.type){
				case MouseEvent.CLICK:
					hideDropList();
					_imageMapData.mapData.currentMapId = item.itemData.mapid;
					break;
			}
			if(item.itemData.onSet)
			{
				_module.qjPlayer.manager.runAction(item.itemData.onSet);
			}
			
			
		}
		
		public function getItemByMapId(mapId:String):DropDownNavigateViewItemRenderer{
			if(!dropSp)
				return null;
			for(var i:int=0;i<dropSp.numChildren;i++){
				var item:DropDownNavigateViewItemRenderer = dropSp.getChildAt(i) as DropDownNavigateViewItemRenderer;
				if(item && item.itemData.mapid == mapId)
					return item;
			}
			return null;
		}
		
		public function showListSelect():void{
			var item:DropDownNavigateViewItemRenderer = getItemByMapId(_imageMapData.mapData.currentMapId);
			if(item)
				showText(item.itemData.label);
		}
		
		private function GetStringLength(thisString : String) : Number 
		{ 
			var thisStringByteLengths :ByteArray = new ByteArray(); 
			thisStringByteLengths.writeMultiByte(thisString, "rtf8"); 
			return thisStringByteLengths.length; 
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
package com.baiduMap.component
{
	import com.baiduMap.utils.Scale9BitmapSprite;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
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
	public class DropDownNavigateView extends Sprite
	{
		[Embed(source="../../../model2_back.png")]
		private var backCls:Class;
		
		[Embed(source="../../../model2_downListBack.png")]
		private var dropCls:Class;
		
		[Embed(source="../../../model2_dropListSmallArrow.png")]
		private var smallArrowCls:Class;
		
		[Embed(source="../../../model2_dropListTriangle.png")]
		private var triangleCls:Class;
		
		private var arr:Array;
		
		private var selectedFun:Function;
		
		private var bmd_back:BitmapData;
		private var bmd_dropList:BitmapData;
		
		private var bmd_smallArrow:BitmapData;
		private var bmd_triangle:BitmapData;
		private var triangleBmp:Bitmap;
		
		private var dropBg:Scale9BitmapSprite;
		private var dropSp:Sprite;
		
		private var textBg:Scale9BitmapSprite;
		private var text:TextField;
		
		private const defaultWidth:int = 25;
		
		private var maxLen:int;
		
		public function DropDownNavigateView(arr:Array,selectedFun:Function) {
			super();
			this.arr = arr;
			this.selectedFun = selectedFun;
			addEventListener(Event.ADDED_TO_STAGE,onAddToStage);
			
			checkBitMapFinish();
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
		
		private function checkBitMapFinish():void{
			bmd_back = (new backCls()).bitmapData;
			bmd_dropList = (new dropCls()).bitmapData;
			bmd_smallArrow = (new smallArrowCls()).bitmapData;
			bmd_triangle = (new triangleCls()).bitmapData;
			if(bmd_back && bmd_dropList && bmd_smallArrow && bmd_triangle){
				dropBg = new Scale9BitmapSprite(bmd_dropList,new Rectangle(1,1,41,49));
				dropSp = new Sprite(); 
				
				for(var i:int=0;i<arr.length;i++){
					var tempLen:int = GetStringLength(arr[i].label);
					if(tempLen > maxLen)
						maxLen = tempLen;
				}
				for(i=0;i<arr.length;i++){
					var item:DropDownNavigateViewItemRenderer = new DropDownNavigateViewItemRenderer(arr[i],i!=arr.length-1,maxLen);
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
				text.height = 18;
				text.textColor = 0xffffff;
				var format:TextFormat = new TextFormat(null,12);
				format.align = TextFormatAlign.CENTER;
				format.font = "宋体";
				text.defaultTextFormat = format;
				text.selectable=false;
				text.mouseEnabled = false;
				text.filters=  [new GlowFilter(0x000000,1,2,2,5)];
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
				
				showFirstSelect();
			}
		}
		
		private function showFirstSelect():void{
			if(arr && arr[0])
				showText(arr[0].label);
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
			triangleBmp.y = 4;
			
			//		defaultWidth
		}
		
		private function onMouseHandel(e:MouseEvent):void{
			var item:DropDownNavigateViewItemRenderer = e.target as DropDownNavigateViewItemRenderer;
			if(!item)
				return;
			switch(e.type){
				case MouseEvent.CLICK:
					hideDropList();
					showText(item.itemData.label);
					if(selectedFun != null){
						selectedFun(item.itemData);
					}
					break;
			}
		}
		
		private function GetStringLength(thisString : String) : Number 
		{ 
			var thisStringByteLengths :ByteArray = new ByteArray(); 
			thisStringByteLengths.writeMultiByte(thisString, "rtf8"); 
			return thisStringByteLengths.length; 
		} 
	}
}
package com.panozona.player.manager.actionCode.view
{
	import com.panosalado.view.ManagedChild;
	import com.panozona.player.module.utils.Scale9BitmapSprite;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-10-28 下午3:04:25
	 * 功能描述:
	 */
	public class MarkView extends ManagedChild
	{
		
		public var backUrl:String;
		public var pointUrl:String;
		public var frame:String;
		
		public var label:String = " ";
		
		public var fontSize:int = 11;
		public var fontColor:Number = 0xff0000;
		
		public var gapX:Number = 15;
		public var gapY:Number = -6;
		
		public var backBmp:Scale9BitmapSprite;
		
		public var txt_title:TextField;
		
		private var txt_bmp:Bitmap;
		
		public var pan:Number = 0;
		
		public var tilt:Number = 0;
		
		public var tile:Number = 0;
		
		public var dx:Number = -6;
			
		public var dy:Number = -6;
		
		public var glowColor:Number = -1;
		
		public function MarkView()
		{
		}
		
		private var pointView:Loader;
		
		public function load():void{
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onCmpBack);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onErr);
			loader.load(new URLRequest(backUrl),new LoaderContext(true));
			
			pointView = new Loader();
			pointView.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onErr);
			pointView.load(new URLRequest(pointUrl),new LoaderContext(true));
			addChild(pointView);
		}
		
		protected function onErr(event:IOErrorEvent):void
		{
			trace(event.text);			
		}
		
		protected function onCmpBack(event:Event):void
		{
			var bitmap:Bitmap = ((event.target as LoaderInfo).content as Bitmap);
			var arr:Array = frame.split("-");
			backBmp = new Scale9BitmapSprite(bitmap.bitmapData,new Rectangle(arr[0],arr[1],arr[2],arr[3]));
			addChild(backBmp);
			
			txt_title = getText();
//			backBmp.addChild(txt_title);
			
			txt_bmp = new Bitmap();
			var bmd:BitmapData = new BitmapData(txt_title.width,txt_title.height,true,0x00000000);
			txt_bmp.cacheAsBitmap = true;
			txt_bmp.smoothing = true;
			bmd.draw(txt_title);
			txt_bmp.bitmapData = bmd;
			
			backBmp.addChild(txt_bmp);
			
			backBmp.width = txt_title.width+int(arr[0]);
			backBmp.height = txt_title.height;
			txt_title.x = arr[0];
			txt_bmp.x = arr[0];
			
			backBmp.x = gapX;
			backBmp.y = gapY;
			
			pointView.x += dx;
			pointView.y += dy;
			backBmp.x += dx;
			backBmp.y += dy;
		}
		
		public function getText():TextField{
			
			var textField:TextField = new TextField();
			var textFormat:TextFormat = new TextFormat();
			
			textField.defaultTextFormat = textFormat;
			textField.multiline = false;
			textField.selectable = false;
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.blendMode = BlendMode.LAYER;
			textField.background = false;
			textField.antiAliasType = AntiAliasType.ADVANCED;
			textField.wordWrap = false;
			textField.mouseEnabled = false;
			
			textFormat.font = "微软雅黑";
			textFormat.size = fontSize;
			textFormat.color = fontColor;
			textFormat.bold = false;
			textFormat.leading = 0;
			textField.defaultTextFormat = textFormat;
			textField.text = label;
			textField.width = textField.textWidth;
			if(glowColor != -1)
				textField.filters=  [new GlowFilter(glowColor,1,2,2,5)];
			
			//			textSprite.graphics.clear();
			//			textSprite.graphics.lineStyle();
			//			textSprite.graphics.beginFill(0xcccccc);
			//			textSprite.graphics.drawRoundRect(0, 0,
			//				textField.width + 1 * 2,
			//				textField.height + 1 * 2,
			//				5);
			//			textSprite.graphics.endFill();
			//			
			//			var shadow:DropShadowFilter=new DropShadowFilter();
			//			textSprite.filters=[shadow];
			return textField;
		}
	}
}
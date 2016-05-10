package com.panozona.modules.openMovie.view
{
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.filters.GlowFilter;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class LoadingHtmlTextBar extends Sprite
	{
		
		private var _text:TextField;
		
		private var loadingBar:Sprite;
		
		private var jumpTxt:TextField;
		
		private var barW:int = 210;
		
		private var barH:int = 20;
		
		private var jumpEndFun:Function;
		
		private var gap:int = 15;
		
		public function LoadingHtmlTextBar(_htmlStr:String,jumpEndFun:Function)
		{
			super();
			
			this.jumpEndFun = jumpEndFun;
			
			_text = new TextField();
			_text.selectable=false;
			_text.multiline=true;
			_text.filters=  [new GlowFilter(0x000000,1,2,2,5)];
			_text.defaultTextFormat=new TextFormat("YaHei",20,0xffffff);
			_text.htmlText = _htmlStr;
			_text.height = _text.textHeight+5;
			addChild(_text);
			
			
			loadingBar = new Sprite();
			loadingBar.graphics.beginFill(0xffffff,1);
			loadingBar.graphics.drawRect(0,0,barW,barH);
			loadingBar.graphics.endFill();
			loadingBar.y = _text.y + _text.height + gap;
			loadingBar.filters=  [new GlowFilter(0x000000,1,2,2,5)];
			addChild(loadingBar);
			
			jumpTxt = new TextField();
			jumpTxt.selectable=false;
			jumpTxt.multiline=true;
			jumpTxt.filters=  [new GlowFilter(0x000000,1,2,2,5)];
			var _dtf:TextFormat = new TextFormat("YaHei",20,0xffffff);
			_dtf.underline = true;
			jumpTxt.defaultTextFormat = _dtf;
			jumpTxt.htmlText = "<u><a href=\"event:jumpEnd\">跳过动画>></a></u>";
			jumpTxt.addEventListener(TextEvent.LINK,onLink);
			jumpTxt.height = jumpTxt.textHeight+5;
			jumpTxt.y = loadingBar.y + loadingBar.height+ gap;;
			jumpTxt.x = loadingBar.width-jumpTxt.width;
			jumpTxt.width = jumpTxt.textWidth+5;
			addChild(jumpTxt);
		}
		
		protected function onLink(event:TextEvent):void
		{
			if(jumpEndFun != null){	
				jumpEndFun();
				jumpEndFun = null;
			}
		}
		
		public function set htmlTxt(_htmlStr:String):void{
			_text.htmlText = _htmlStr;
			_text.width=_text.textWidth+5;;
			_text.cacheAsBitmap = true;
		}
		
		public function setPersent(num:Number):void{
			if(loadingBar){
				loadingBar.graphics.clear();
				loadingBar.graphics.beginFill(0xffffff,1);
				loadingBar.graphics.drawRect(0,0,barW,barH);
				loadingBar.graphics.endFill();
				loadingBar.graphics.beginFill(0x009bff,1);
				loadingBar.graphics.drawRect(0,0,barW*num/100,barH);
				loadingBar.graphics.endFill();
			}
		}
	}
}
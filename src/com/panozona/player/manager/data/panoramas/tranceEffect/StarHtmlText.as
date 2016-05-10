package com.panozona.player.manager.data.panoramas.tranceEffect
{
	
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import caurina.transitions.Tweener;

	public class StarHtmlText extends Sprite
	{
		
		private var _text:TextField;
		
		public function StarHtmlText(_htmlStr:String,_seconds:Number=2)
		{
			super();
			_text = new TextField();
			_text.selectable=false;
			_text.multiline=true;
			_text.filters=  [new GlowFilter(0x000000,1,2,2,5)];
			_text.defaultTextFormat=new TextFormat("YaHei",26,0xf6ff00);
			_text.htmlText = _htmlStr;
			_text.height = _text.textHeight+5;;
			addChild(_text);
			_text.width=_text.textWidth+10;
			var tweenObj:Object = new Object();
			tweenObj["time"] = _seconds;
			tweenObj["onComplete"] = doFade;
			tweenObj["y"] = y-40;
			Tweener.addTween(_text, tweenObj);
			_text.cacheAsBitmap = true;
		}
		
		private function doFade():void{
			destroy();
		}
		
		private	function destroy():void{
			if(this.parent){
				removeChild(_text);
				_text = null;
				this.parent.removeChild(this);
			}
		}
	}
}
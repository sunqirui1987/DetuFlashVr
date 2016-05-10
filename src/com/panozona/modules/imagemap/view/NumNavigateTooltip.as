package com.panozona.modules.imagemap.view
{
	import com.panozona.player.module.utils.Scale9BitmapSprite;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	

	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-3-11 上午11:13:47
	 * 功能描述:
	 */
	public class NumNavigateTooltip extends Sprite
	{
		
		private var tipBg:Scale9BitmapSprite;
		
		private var text:TextField;
		
		public function NumNavigateTooltip(bmd:BitmapData,s:String)
		{
			var rect:Rectangle = new Rectangle(7,3,38,17);
			tipBg = new Scale9BitmapSprite(bmd, rect);
			tipBg.visible=true;
			addChild(tipBg);
			
			text = new TextField();
			text.height = 20;
			text.textColor = 0xffffff;
			var format:TextFormat = new TextFormat(null,14);
			format.align = TextFormatAlign.CENTER;
			format.font = "宋体";
			text.defaultTextFormat = format;
			text.selectable=false;
			text.x = 3;
	//		text.filters=  [new GlowFilter(0x000000,1,2,2,5)];
			addChild(text);
			showString(s);
		}
		
		public function showString(s:String):void{
			text.width = (s.length+1)*int(text.defaultTextFormat.size);
			text.text = s;
			tipBg.width = text.width ;
			tipBg.height = text.height;
		}
	}
}
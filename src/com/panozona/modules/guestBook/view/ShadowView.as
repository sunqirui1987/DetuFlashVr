package com.panozona.modules.guestBook.view
{
	import com.panozona.modules.guestBook.model.GuestBookData;
	
	import flash.display.Sprite;
	
	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-2-21
	 * 功能描述:
	 */
	public class ShadowView extends Sprite
	{
		
		private var _guestBookData:GuestBookData;
		
		public function ShadowView(_guestBookData:GuestBookData):void{
			this._guestBookData = _guestBookData;
		}
		
		public function drawBg(w:Number,h:Number):void{
			clear();
			graphics.beginFill(_guestBookData.setting.backShadowColor,_guestBookData.setting.backShadowAlpha);
			graphics.drawRect(0,0,w,h);
			graphics.endFill();
		}
		
		
		public function clear():void{
			graphics.clear();
		}
	}
}
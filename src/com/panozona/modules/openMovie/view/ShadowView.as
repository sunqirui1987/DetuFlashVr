package com.panozona.modules.openMovie.view
{
	import com.panozona.modules.openMovie.model.OpenMovieData;
	
	import flash.display.Sprite;
	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-2-21
	 * 功能描述:
	 */
	public class ShadowView extends Sprite
	{
		
		private var _openMovieData:OpenMovieData;
		
		public function ShadowView(_openMovieData:OpenMovieData):void{
			this._openMovieData = _openMovieData;
		}
		
		public function drawBg(w:Number,h:Number):void{
			clear();
			graphics.beginFill(_openMovieData.setting.backShadowColor,_openMovieData.setting.backShadowAlpha);
			graphics.drawRect(0,0,w,h);
			graphics.endFill();
		}
		
		public function clear():void{
			graphics.clear();
		}
	}
}
package com.panozona.modules.imagebutton.view
{
	import com.panozona.modules.imagebutton.model.structure.Bg;
	import com.panozona.modules.imagebutton.model.structure.GroupButton;
	import com.panozona.player.module.utils.Scale9BitmapSprite;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-4-10 下午1:12:41
	 * 功能描述:
	 */
	public class BgView extends Sprite
	{
		private var bg:Bg;
		
		private var groupButtonData:GroupButton;
		
		public function BgView(groupButtonData:GroupButton):void {
			this.bg = groupButtonData.bg;
			this.groupButtonData = groupButtonData;
			
			this.mouseChildren = bg.mouseChildren;
			this.mouseEnabled = bg.mouseEnabled;
		}
		
		public function drawBg():void{
			this.graphics.clear();
			this.graphics.beginFill(bg.color,bg.alpha);
			this.graphics.drawRoundRect(0,0,bg.size.width,bg.size.height,bg.radius);
			this.graphics.endFill();
		}
		
		public function get bgData():Bg{
			return this.bg;
		}
		
		public function setBackGroundPic(content:DisplayObject):void{
			addChildAt(content,0);
		}
		
		private var scale9:Scale9BitmapSprite;
		
		public function createScale9(bitmap:Bitmap):void{
			scale9 = new Scale9BitmapSprite(bitmap.bitmapData,new Rectangle(1,1,bitmap.bitmapData.width-2,bitmap.bitmapData.height-2));
			scale9.width = bg.size.width;
			scale9.height = bg.size.height;
			addChildAt(scale9,0);
		}
	}
}
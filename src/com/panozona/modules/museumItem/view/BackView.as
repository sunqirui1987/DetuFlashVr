package com.panozona.modules.museumItem.view
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-10-31 下午2:21:38
	 * 功能描述:
	 */
	public class BackView extends Sprite
	{
		
		private var bitmap:Bitmap = new Bitmap();
		
		public function BackView()
		{
			super();
			this.mouseChildren = this.mouseEnabled = false;
			bitmap.cacheAsBitmap = true;
			addChild(bitmap);
		}
		
		public function drawBg(w:Number,h:Number):void{
			var sp:Sprite = new Sprite();
			var graphics:Graphics = sp.graphics;
			graphics.clear();
			graphics.beginFill(0x2c2c2c,1);
			graphics.drawRect(0,0,w,h);
			graphics.endFill();	
			graphics.lineStyle(1,0x0d0d0d);
			var p1:Point = new Point(w,0);
			var p2:Point = new Point(w,0);
			var dd:Number = 10;
			for(var i:Number=0;i<w+dd;i+=dd){
				p1.x = w-i; 
				p2.y = i;
				graphics.moveTo(p1.x,p1.y);
				graphics.lineTo(p2.x,p2.y);
			}
			
			for(i=0;i<h+dd;i+=dd){
				p1.y = i; 
				p2.x = w-i;
				graphics.moveTo(p1.x,p1.y);
				graphics.lineTo(p2.x,p2.y);
			}
			var bmd:BitmapData = new BitmapData(w,h,true,0x00000000);
			bmd.draw(sp);
			bitmap.bitmapData = bmd;
		}
	}
}
package com.panozona.modules.guide.view
{
	import com.panozona.modules.guide.model.GuideData;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	
	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2013-8-8 下午05:12:59
	 * 功能描述:
	 */
	public class GuideLayer extends Sprite
	{
		public var guideData:GuideData;
		
		public var guideView:GuideView;
		
		public function GuideLayer(guideData:GuideData)
		{
			this.guideData = guideData;
			guideView = new GuideView(guideData);
		}
		
		public function clear():void{
			this.graphics.clear();
		}
		
		public function drawMask(x:int,y:int,w:int,h:int,bw:Number,bh:Number):void{
			this.graphics.clear();
			this.graphics.beginFill(1,0);
			this.graphics.drawRect(0,0,bw,y);
			this.graphics.drawRect(0,y,x,h);
			this.graphics.drawRect(x+w,y,bw-x-w,h);
			this.graphics.drawRect(0,y+h,bw,bh-h-y);
			this.graphics.endFill();
			
			center.x = x+w/2;
			center.y = y+h/2;
		}
		
		public function drawFull(w:Number,h:Number):void{
			this.graphics.clear();
			this.graphics.beginFill(1,0);
			this.graphics.drawRect(0,0,w,h);
			this.graphics.endFill();
		}
		
		public var center:Point = new Point(0,0);
		
	}
}
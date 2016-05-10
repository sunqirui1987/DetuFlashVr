package com.panozona.player.manager.data.panoramas.weather
{
	import flash.display.Sprite;
	
	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-3-21 上午9:29:23
	 * 功能描述:
	 */
	public class Weaher3dObject extends Sprite
	{
		
		
		public var speed:Number;
		
		public function Weaher3dObject()
		{
			super();
		}
		
		public function update(focal_length:Number,pan:Number,tilt:Number):void{
			this.rotationY = pan;
			this.rotationX = tilt;
			this.scaleX = this.scaleY = 1;
		}
		
		public function draw():void{
			graphics.clear();
			graphics.beginFill(0xffffff,1);
			graphics.drawCircle(0,0,1);
			graphics.endFill();
		}
	}
}
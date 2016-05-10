package com.baiduMap.overLay
{
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.text.TextFormat;
	
	import baidu.map.basetype.LngLat;
	import baidu.map.basetype.Size;
	import baidu.map.overlay.Marker;
	
	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-3-13 上午10:25:21
	 * 功能描述:
	 */
	public class MyMarker extends Marker
	{
		
		public var data:Object;
		
		private var sp:Sprite = new Sprite();
		
		public function MyMarker(data:Object)
		{
			super();
			this.data = data;
			this.buttonMode = true;
			this.position = new LngLat(data.lng, data.lat);
			isCurrent = false;
		}
		
		private var _isCurrent:Boolean;
		public function get isCurrent():Boolean{
			return _isCurrent;
		}
		public function set isCurrent(_isCurrent:Boolean):void{
			this._isCurrent = _isCurrent;
			if(_isCurrent){
				sp.graphics.clear();
				sp.graphics.beginFill(0x00ccff,1);
				sp.graphics.drawCircle(0,0,5);
				sp.graphics.endFill();
				sp.graphics.lineStyle(1,0x0c8cca);
				sp.graphics.drawCircle(0,0,5);
				sp.graphics.drawCircle(0,0,7.5);
				offset = new Size(6,14);
				icon = sp;
			}else{
				sp.graphics.clear();
				sp.graphics.beginFill(0x00ccff,1);
				sp.graphics.drawCircle(0,0,6);
				sp.graphics.endFill();
				sp.graphics.lineStyle(1,0x0c8cca);
				sp.graphics.drawCircle(0,0,6);
				offset = new Size(5,11);
				icon = sp;
			}
		}
		
		public function drawCurrentIcon(startAngle:Number,endAngle:Number,divisions:Number,span:Number,rotationZ):void{
			var controlRadius:Number = 50 / Math.cos(span);
			sp.graphics.clear();
			sp.graphics.beginFill(0x00ccff,1);
			sp.graphics.drawCircle(0,0,5);
			sp.graphics.endFill();
			sp.graphics.lineStyle(1,0x0c8cca);
			sp.graphics.drawCircle(0,0,5);
			sp.graphics.drawCircle(0,0,7.5);
			sp.rotationZ = rotationZ;
			var gradientBoxMatrix:Matrix = new Matrix();
	//		gradientBoxMatrix.createGradientBox(290, 290, 360);
			sp.graphics.beginGradientFill(GradientType.RADIAL,[0x00ccff, 0xFFFFFF], [1, 0.85], [0, 255], gradientBoxMatrix, SpreadMethod.REPEAT);
			
			//_waypointView.radar.graphics.lineStyle(_waypointView.waypointData.radar.borderSize, _waypointView.waypointData.radar.borderColor);
			
			sp.graphics.moveTo(0, 0);
			sp.graphics.lineTo((Math.cos(startAngle) * 50), Math.sin(startAngle) * 50);
			var controlPoint:Point;
			var anchorPoint:Point;
			for(var i:Number=0; i < divisions; ++i){
				endAngle = startAngle + span;
				startAngle = endAngle + span;
				
				controlPoint = new Point(Math.cos(endAngle) * controlRadius, Math.sin(endAngle) * controlRadius);
				anchorPoint = new Point(Math.cos(startAngle) * 50, Math.sin(startAngle) * 50);
				sp.graphics.curveTo(controlPoint.x, controlPoint.y, anchorPoint.x, anchorPoint.y);
			}
			sp.graphics.endFill();
		}
	}
}
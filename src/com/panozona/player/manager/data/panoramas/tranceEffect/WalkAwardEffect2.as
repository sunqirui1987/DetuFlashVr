package com.panozona.player.manager.data.panoramas.tranceEffect
{
	
	import com.panozona.player.manager.Manager;
	import com.panozona.player.module.global;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import caurina.transitions.Tweener;
	
	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-3-24 上午10:07:47
	 * 功能描述:
	 */
	public class WalkAwardEffect2 extends Sprite
	{
		
		private var bitMapData:BitmapData;
		
		private var endFun:Function;
		
		private var bitMap:Bitmap;
		
		public var movePan:Number = 0;
		
		private var vertices:Vector.<Number>;
		private var indices:Vector.<int>;
		
		private var uvdata: Vector.<Number>;
		
		private var manager:Manager;
		
		private var sp:Sprite;
		
		private var cPoints:Array=[];
		
		private var cube:Vector.<Vector3D>;
		
		public function WalkAwardEffect2(manager:Manager,movePan:Number=0,endFun:Function=null)
		{
			
			global.IS_WALK_AWARD_EFFECT_NOW = true;
			
			this.graphics.clear();
			this.graphics.beginFill(1,1);
			this.graphics.drawRect(0,0,manager.boundsWidth,manager.boundsHeight);
			this.graphics.endFill();
			
			sp = new Sprite();
			addChild(sp);
			sp.x = manager.boundsWidth/2;
			sp.y = manager.boundsHeight/2;
			super();
			
			this.movePan = movePan;
			
			this.manager = manager;
			manager.managedChildren.visible = false;
			this.bitMapData = new BitmapData(manager.boundsWidth,manager.boundsHeight);
			this.bitMapData.draw(manager);
			//			manager.visible = false;
			manager.managedChildren.visible = true;
			this.endFun = endFun;
			//			bitMap = new Bitmap();
			//			bitMap.bitmapData = this.bitMapData;
			//			addChild(bitMap);
			manager.stage.addChild(this);
			
			
			
			createPoints();
		}
		
		private var xsegments:int = 16;
		private var ysegments:int = 8;
		
		
		
		private function createPoints():void{
			
			var z:Number = Math.abs(manager.boundsWidth/2/Math.tan(manager.fieldOfView/2));
			z = focalLengthValue;
			cube = new Vector.<Vector3D>();
			vertices = new Vector.<Number>();
			indices = new Vector.<int>();
			uvdata = new Vector.<Number>();
			
			var k:int=0;
			
			for ( var x: int = 0; x < xsegments + 1; x++ )
			{
				var px: Number = ( x / xsegments ) * bitMapData.width;
				
				for ( var y: int = 0; y < ysegments + 1; y++ )
				{
					var py: Number = ( y / ysegments ) * bitMapData.height;
					cube.push(new Vector3D( px-manager.boundsWidth/2, py-manager.boundsHeight/2, -z));
					
					var uvx: Number = x / xsegments;
					var uvy: Number = y / ysegments;
					
					if ( y < ysegments )
						indices.push( k, k + ysegments + 1, k + 1, k + ysegments + 1, k + ysegments + 2, k + 1 );
					uvdata.push( uvx, uvy );
					++k;
				}
			}
			
			for each (var v:Vector3D in cube)
			{
				var p:Point = convertTo2D(v);
				vertices.push(p.x, p.y);
			}
			
			draw();
			
			movePoints();
		}
		
		private var movetimes:int=0;
		
		private var focalLengthValue:Number = 400;
		
		private var moveVector:Vector3D;
		private var obj:Object = {a:1};
		
		private function movePoints():void
		{
//			var angle:Number = movePan-manager.pan;
//			Tweener.addTween(obj,{a:1000,time:0.6,onComplete:function():void{
//				destroy();
//			},onUpdate:function():void{
//				for(var i:int=0;i<cube.length;i++){
//					var p:Vector3D = cube[i];
////					if(checkIsBound(p))
////						continue;
//					p = p.add(new Vector3D(obj.a*(Math.sin(angle)),0,obj.a*(Math.cos(angle))));
//					render();
//					if(i == 0)
//						trace(p.x,p.y,p.z);
//				}
//			}});
//			return;
	//		var angle:Number = (movePan-manager.pan+360)%360;
			var angle:Number = movePan-manager.pan;
	//		var r:Number = Math.abs(manager.boundsWidth/2/Math.tan(manager.fieldOfView/2));
			var r:Number = focalLengthValue;	
			r = r/4;
//						var st:StarHtmlText = new StarHtmlText("angle="+angle+" xadd="+(-r*Math.sin((angle)*Math.PI/180)).toFixed(2)+" zadd="+(r*Math.cos((angle)*Math.PI/180)).toFixed(2),10);
//						st.x = (manager.boundsWidth-st.width)*0.5;
//						st.y = (manager.boundsHeight-st.height)*0.5;
//						manager.stage.addChild(st);
			for(var i:int=0;i<cube.length;i++){
				var p:Vector3D = cube[i];
				if(checkIsBound(p))
					continue;
				var tweenObj:Object = new Object();
				tweenObj["time"] = 0.6;
				tweenObj["x"] = p.x - r*Math.sin((angle)*Math.PI/180);
				tweenObj["z"] = p.z + r*Math.cos((angle)*Math.PI/180);
				tweenObj["onUpdate"] = function():void{
					r += 1;
					render();
				};
				Tweener.addTween(p,tweenObj);
			}
			Tweener.addTween(this,{time:movetimes==0?0.5:0.6,onComplete:function():void{
				movetimes ++;
				if(movetimes <2 )
					movePoints();
				else
					destroy();
			}});
		}		
		
		private function checkIsBound(p:Vector3D):Boolean
		{
			return (p.x == -manager.boundsWidth/2) || (p.y == -manager.boundsHeight/2) || (p.x == manager.boundsWidth/2) || (p.y == manager.boundsHeight/2);
		}
		
		private function render():void{
			vertices.length = 0;
			
			for each (var v:Vector3D in cube)
			{
				var p:Point = convertTo2D(v);
				vertices.push(p.x, p.y);
			}
			draw();
		}
		
		
		private function draw():void{
			sp.graphics.clear();
			sp.graphics.beginBitmapFill( bitMapData, null, false, false );
			sp.graphics.drawTriangles(vertices, indices,uvdata);
			sp.graphics.endFill();
		}
		
		private function convertTo2D(v:Vector3D):Point
		{
			var focalLength:Number = Math.abs(manager.boundsWidth/2/Math.tan(manager.fieldOfView/2));
			focalLength = focalLengthValue;
			var perspective:Number = focalLength/-v.z;
			//			trace("perspective="+perspective);
			var toX:Number = v.x*perspective;
			var toY:Number = v.y*perspective;
			
//						toX  = Math.min(manager.boundsWidth/2,toX);
//						toX  = Math.max(-manager.boundsWidth/2,toX);
//						toY  = Math.min(manager.boundsHeight/2,toY);
//						toY  = Math.max(-manager.boundsHeight/2,toY);
			return new Point(toX, toY);
		}
		
		//		private function convertTo2D(v:Vector3D):Point
		//		{
		//			var nums:Vector.<Number> = new Vector.<Number>();
		//			nums.push(1,0,0,0,0,1,0,0,0,0,1,0);
		//			var perspectiveMatrix3D:Matrix3D = new Matrix3D(nums);
		//			var v2:Vector3D = perspectiveMatrix3D.deltaTransformVector(v);
		//			return new Point(v2.x, v2.y);
		//		}
		
		private function destroy():void{
			if(endFun != null){
				endFun();
				endFun = null;
			}
			if(this.parent)
				this.parent.removeChild(this);
		}
	}
}


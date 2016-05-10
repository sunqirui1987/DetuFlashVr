package com.panosalado.model
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.system.Security;  

	public class Sphere3D extends Sprite
	{
		private var vertices    :Vector.<Number> = new Vector.<Number>();
		private var uvtData     :Vector.<Number> = new Vector.<Number>();
		private var indices     :Vector.<int> = new Vector.<int>();
		private var bitmap      :Bitmap;
		private var sprite      :Sprite;        
		private var res         :Number = 60;
		private var cols        :int = 20;
		private var rows        :int = 20;    
		private var centerZ     :Number = 465;
		private var focalLength :Number = 200;
		private var radius      :Number = 400;
		private var offset      :Number = 0;
		private var value       :Number = 0;
		private var isWire      :Boolean;
		
		public function RotateSphere3D() 
		{
	
			sprite = new Sprite();
			sprite.x = 233;
			sprite.y = 233;
			addChild(sprite);
			
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event):void 
			{               
				bitmap = bitmap = new Bitmap(Bitmap(loader.contentLoaderInfo.content).bitmapData);
				makeTriangles();
				draw();
				stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
				stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			});
			loader.load(new URLRequest("http://assets.wonderfl.net/images/related_images/e/e4/e45c/e45ca86197dec7ac6b74b94fd190d288e01813ea"));
		}
		
		private function onEnterFrame(e:Event):void 
		{
			draw();            
			value = (mouseX - 233) * .001;
		}
		
		private function draw():void 
		{
			offset += value;            
			vertices.length = 0;
			uvtData.length = 0;
			
			for (var i:int = 0; i < rows; i++) 
			{
				for (var j:int = 0; j < cols; j++) 
				{
					var angle:Number = Math.PI * 2 / (cols - 1) * j;                    
					var angle2:Number = Math.PI * i / (rows - 1) - Math.PI / 2;                    
					var xpos:Number = Math.cos(angle + offset) * radius * Math.cos(angle2);
					var ypos:Number = Math.sin(angle2) * radius;
					var zpos:Number = Math.sin(angle + offset) * radius * Math.cos(angle2);                    
					var scale:Number = focalLength / (focalLength + zpos + centerZ);                    
					vertices.push(xpos * scale, ypos * scale);
					uvtData.push(j / (cols -1), i / (rows - 1));
					uvtData.push(scale);
				}
			}
			
			sprite.graphics.clear();
			sprite.graphics.beginBitmapFill(bitmap.bitmapData, null, false, true);
			sprite.graphics.drawTriangles(vertices, indices, uvtData, TriangleCulling.NEGATIVE);
			sprite.graphics.endFill();     
			
			if(isWire)
			{
				sprite.graphics.lineStyle(0, 0, .5);
				sprite.graphics.drawTriangles(vertices, indices, uvtData, TriangleCulling.NEGATIVE);
			}
			
			
		}
		
		private function makeTriangles():void 
		{
			for (var i:int = 0; i < rows; i++) 
			{
				for (var j:int = 0; j < cols; j++) 
				{
					if (i < rows - 1 && j < cols - 1)
					{
						indices.push(i * cols + j, i * cols + j + 1, (i + 1) * cols + j);
						indices.push(i * cols + j + 1, (i + 1) * cols + j + 1, (i + 1) * cols + j);
					}
				}
			}
		}
		
		private function onMouseDown(e:MouseEvent):void
		{
			(isWire) ? isWire = false : isWire = true;
		}
	}
}
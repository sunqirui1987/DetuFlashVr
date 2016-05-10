package com.panozona.player.manager.utils
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;

	public class ImageCutter
	{
		public function ImageCutter()
		{
		}
		
		public static function cut(source:BitmapData,column:int,rows:int):Array{
			var arr:Array = new Array();
			var width:Number = Number(source.width/column);
			var height:Number = Number(source.height/rows);
			for(var j:int=0;j<rows;j++){
				for(var i:int=0;i<column;i++){
					var bitmapData:BitmapData = new BitmapData(width,height,true,0);
					bitmapData.copyPixels(source,new Rectangle(i*width,j*height,width,height),new Point());
					arr.push(bitmapData);
				}
			}
			return arr;
		}
		
		public static function cutimg(source:BitmapData,rect:Rectangle):BitmapData
		{
			var bitmapData:BitmapData = new BitmapData(rect.width,rect.height,true,0);
			bitmapData.copyPixels(source,new Rectangle(rect.x,rect.y,rect.width,rect.height),new Point());
			return bitmapData;
		}
		
		
		public static function duplicateDisplayObject(target:DisplayObject):DisplayObject {
			// create duplicate
			var targetClass:Class=Object(target).constructor;
			var duplicate:DisplayObject=new targetClass();
			
			// duplicate properties
			duplicate.transform=target.transform;
			duplicate.filters=target.filters;
			duplicate.cacheAsBitmap=target.cacheAsBitmap;
			duplicate.opaqueBackground=target.opaqueBackground;
			duplicate.scaleX=target.scaleX;
			duplicate.scaleY=target.scaleY;
			if (target.scale9Grid)
			{
				var rect:Rectangle=target.scale9Grid;
				duplicate.scale9Grid=rect;
			}
			
			if (target is Sprite)
			{
				var lenTarget:int=(target as Sprite).numChildren;
				var lenDuplicate:int=(duplicate as Sprite).numChildren;
				if (lenTarget > lenDuplicate)
				{
					for (var i:int=0; i < lenTarget; i++)
					{
						var child:DisplayObject=(target as Sprite).getChildAt(i);
						var flag:int=0;
						for (var j:int=0; j < lenDuplicate; j++)
						{
							var child1:DisplayObject=(duplicate as Sprite).getChildAt(j);
							if (child1.name != child.name)
							{
								flag++;
							}
							else
							{
								//TraceUtil.traceInfo(child1.name, " == ", child.name);
							}
						}
						if (flag == lenDuplicate)
						{
							var childAdd:DisplayObject=duplicateDisplayObject(child);
							(duplicate as Sprite).addChildAt(childAdd, i);
						}
					}
					
				}
			}
			
			
			
			
			return duplicate;
		}
	}
}
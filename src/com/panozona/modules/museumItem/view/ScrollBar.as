package com.panozona.modules.museumItem.view
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-11-4 下午5:30:18
	 * 功能描述:
	 */
	public class ScrollBar extends Sprite
	{
		
		private var h:Number;
		
		private var sp_block:Sprite = new Sprite();
		
		private var sp_back:Sprite = new Sprite();
		
		private var isMouseDown:Boolean;
		
		private var moveFun:Function;
		
		public function ScrollBar(h:Number,moveFun:Function)
		{
			super();
			this.moveFun = moveFun;
			sp_block.buttonMode = true;
			sp_block.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown,false,0,true);
			addChild(sp_back);
			addChild(sp_block);
			setH(h);
		}
		
		protected function onMouseMove(event:MouseEvent):void
		{
			if(isMouseDown)
				moveScroll(event);
		}
		
		protected function onMouseUp(event:MouseEvent):void
		{
			isMouseDown = false;	
			sp_block.stopDrag();
			moveScroll(event);
			sp_block.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown,false,0,true);
			if(sp_block.hasEventListener(MouseEvent.MOUSE_UP))
				sp_block.removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			if(sp_block.hasEventListener(MouseEvent.MOUSE_MOVE))
				sp_block.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			if(sp_block.root && sp_block.root.hasEventListener(MouseEvent.MOUSE_UP))
				sp_block.root.removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
		}
		
		protected function onMouseDown(event:MouseEvent):void
		{
			isMouseDown = true;	
			sp_block.startDrag(true,new Rectangle(0,0,0,h));
			if(sp_block.hasEventListener(MouseEvent.MOUSE_DOWN))
				sp_block.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			sp_block.addEventListener(MouseEvent.MOUSE_UP,onMouseUp,false,0,true);
			sp_block.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove,false,0,true);
			
			if(sp_block.root)
				sp_block.root.addEventListener(MouseEvent.MOUSE_UP,onMouseUp,false,0,true);
		}
		
		protected function moveScroll(event:MouseEvent):void
		{
			var toy:Number = globalToLocal(new Point(0,event.stageY)).y;
	//		trace("mouseY="+mouseY);
			toy = Math.min(toy,h);
			toy = Math.max(toy,0);
			persent = (toy/h);
			if(moveFun != null)
				moveFun();
		}
		
		public function setH(h:Number):void{
			this.h = h;
			draw();
			this.persent = _persent;
		}
		
		private var _persent:Number = 0;
		public function get persent():Number{
			return _persent;
		}
		
		public function set persent(_persent:Number):void{
			sp_block.y = h*_persent;
			this._persent = _persent;
		}
		
		public function draw():void{
			sp_block.graphics.clear();
			sp_block.graphics.beginFill(0x626262,1);
			sp_block.graphics.drawRect(-5,-10,10,20);
			sp_block.graphics.endFill();
			
			sp_back.graphics.clear();
			sp_back.graphics.beginFill(0xb5b5b5,1);
			sp_back.graphics.drawRect(-3,0,6,h);
			sp_back.graphics.endFill();
		}
		
		public function destroy():void{
			if(sp_block.hasEventListener(MouseEvent.MOUSE_DOWN))
				sp_block.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			if(sp_block.hasEventListener(MouseEvent.MOUSE_UP))
				sp_block.removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			if(sp_block.hasEventListener(MouseEvent.MOUSE_MOVE))
				sp_block.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			if(sp_block.root && sp_block.root.hasEventListener(MouseEvent.MOUSE_UP))
				sp_block.root.removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
		}
	}
}
package com.panozona.player.manager.data.panoramas.weather
{
	import com.panosalado.view.ManagedChild;
	import com.panozona.player.manager.Manager;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-3-20 下午2:39:38
	 * 功能描述:
	 */
	public class WeatherContainer extends ManagedChild
	{
		
		private var arr:Array = [];
		
		private var manager:Manager;
		
		private var INIT_NUM:int = 500;
		
		public function WeatherContainer(manager:Manager)
		{
			super();
			this.manager = manager;
			createSnows();
			
			this.addEventListener(Event.ENTER_FRAME,enterframeHandler);
			
//			graphics.beginFill(0xff0000,1);
//			graphics.drawCircle(0,0,50);
//			graphics.endFill();
		}
		
		private var zLen:Number = 500;
		
		private var speed:Number = 10;
		
		protected function enterframeHandler(event:Event):void
		{
			for(var i:int=0;i<arr.length;i++){
				var s:Weaher3dObject = arr[i];
				s.y += s.speed;
				if(s.y>manager._boundsWidth/2){
					s.x = Math.random() * manager._boundsWidth -  manager._boundsWidth/2;
					s.y = -500*Math.random();
					s.z = Math.random() * -2*zLen+zLen;
					s.speed = Math.random() * speed +1;
				}
				s.update(manager.fieldOfView,manager.pan,manager.tilt);
			}
	//		swap_depth(this);
		}
		
	
		// bubble sort algo
		private function swap_depth(container:Sprite):void
		{
			for (var i:int = 0; i < container.numChildren - 1; i++)
			{
				for (var j:int = container.numChildren - 1; j > 0; j--)
				{
					if (Object(container.getChildAt(j-1)).z < Object(container.getChildAt(j)).z)
					{
						container.swapChildren(container.getChildAt(j-1), container.getChildAt(j));
					}
				}
			}
		}
		
		private function createSnows():void{
			for(var i:int=0;i<INIT_NUM;i++){
				var s:Weaher3dObject = new Weaher3dObject();
				s.x = Math.random() * manager._boundsWidth -  manager._boundsWidth/2;
				s.y = -500*Math.random();
				s.z = Math.random() * -2*zLen+zLen;
				s.speed = Math.random() * speed +1;
				s.draw();
				this.addChild(s);
				arr.push(s);
			}
			
		}
	}
}
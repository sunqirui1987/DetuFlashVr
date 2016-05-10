package com.panozona.player.manager.data.panoramas.help
{
	
	import com.panosalado.events.ViewEvent;
	import com.panosalado.model.CameraKeyBindings;
	import com.panozona.player.manager.Manager;
	
	import flash.display.DisplayObject;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;

	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-4-23 下午5:30:38
	 * 功能描述:
	 */
	public class HelpView extends Sprite
	{
		
		private var manager:Manager;
		private var bg:Sprite;
		
		public function HelpView(path:String,manager:Manager)
		{
			this.manager = manager;
			SwfLoader.load(path,finishFun);
		}
		
		private var mcRoot:MovieClip;
		
		private var btn_close:SimpleButton;
		
		private var mc_shubiao:MovieClip;
		
		private function finishFun(loaderInfo:LoaderInfo):void{
			mcRoot = (loaderInfo.content as MovieClip).getChildByName("mcRoot") as MovieClip;
			btn_close = mcRoot.getChildByName("btn_close") as SimpleButton;
			mc_shubiao = mcRoot.getChildByName("mc_shubiao") as MovieClip;
			
			if(btn_close)
				btn_close.addEventListener(MouseEvent.CLICK,destroy,false,0,true);
			if(mc_shubiao){
				mc_shubiao.addEventListener("up",handlePlay,false,0,true);
				mc_shubiao.addEventListener("down",handlePlay,false,0,true);
				mc_shubiao.addEventListener("left",handlePlay,false,0,true);
				mc_shubiao.addEventListener("right",handlePlay,false,0,true);
				mc_shubiao.addEventListener("stay",handlePlay,false,0,true);
				mc_shubiao.addEventListener("scrollIn",handlePlay,false,0,true);
				mc_shubiao.addEventListener("scrollOut",handlePlay,false,0,true);
				mc_shubiao.addEventListener("destroy",handlePlay,false,0,true);
			}

			
			bg = new Sprite();
			bg.mouseChildren = bg.mouseEnabled = false;
			addChildAt(bg,0);
			
			manager.addEventListener(ViewEvent.BOUNDS_CHANGED, handleResize, false, 0, true);
			addChild(mcRoot);
			adjustAlign();
		}
		
		protected function handlePlay(event:Event):void
		{
			if(!stage)
				return;

			switch(event.type){
				case "up":
					stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, false, true, 0, CameraKeyBindings.UP));
					break;
				case "down":
					stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, false, true, 0, CameraKeyBindings.DOWN));
					break;
				case "left":
					stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, false, true, 0, CameraKeyBindings.LEFT));
					break;
				case "right":
					stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, false, true, 0, CameraKeyBindings.RIGHT));
					break;
				case "stay":
					stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP, false, true, 0, CameraKeyBindings.UP));
					stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP, false, true, 0, CameraKeyBindings.DOWN));
					stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP, false, true, 0, CameraKeyBindings.LEFT));
					stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP, false, true, 0, CameraKeyBindings.RIGHT));
					break;
				case "scrollIn":
					manager.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_WHEEL, true, false, manager.boundsWidth/2, manager.boundsHeight/2, null, false, false, false, false, 5));
					break;
				case "scrollOut":
					manager.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_WHEEL, true, false, manager.boundsWidth/2, manager.boundsHeight/2, null, false, false, false, false, -5));
					break;
				case "destroy":
					if(manager.managerData.allPanoramasData.isAutoCloseWhenEndHelp)
						destroy();
					break;
			}
		}
		
		private function destroy(e:MouseEvent=null):void{
			if(btn_close && btn_close.hasEventListener(MouseEvent.CLICK))
				btn_close.removeEventListener(MouseEvent.CLICK,destroy);
			mcRoot.stop();
			if(mc_shubiao){
				mc_shubiao.removeEventListener("up",handlePlay);
				mc_shubiao.removeEventListener("down",handlePlay);
				mc_shubiao.removeEventListener("left",handlePlay);
				mc_shubiao.removeEventListener("right",handlePlay);
				mc_shubiao.removeEventListener("stay",handlePlay);
				mc_shubiao.removeEventListener("scrollIn",handlePlay);
				mc_shubiao.removeEventListener("scrollOut",handlePlay);
				mc_shubiao.removeEventListener("destroy",handlePlay);
				
				//响应按上的事件，为了清除key_down状态
				stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP, false, true, 0, CameraKeyBindings.UP));
				stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP, false, true, 0, CameraKeyBindings.DOWN));
				stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP, false, true, 0, CameraKeyBindings.LEFT));
				stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP, false, true, 0, CameraKeyBindings.RIGHT));
				

			}
			if(this.parent)
				this.parent.removeChild(this);
			
			
			//向上PUSH一个事件
			manager.stage.dispatchEvent(new Event("helpdestory"));
		}
		
		private function handleResize(e:Event = null):void
		{
			adjustAlign(null);
		}
		
		private function adjustAlign(e:Event=null):void
		{
			if(stage || e){
				if(e)
					removeEventListener(Event.ADDED_TO_STAGE,adjustAlign);
				mcRoot.x = (manager.boundsWidth-mcRoot.width)*0.5;
				mcRoot.y = (manager.boundsHeight-mcRoot.height)*0.5;
				drawBg();
			}else{
				addEventListener(Event.ADDED_TO_STAGE,adjustAlign);
			}
		}		
		
		private function drawBg():void
		{

			bg.graphics.clear();
			bg.graphics.beginFill(1,0.5);
			bg.graphics.drawRect(0,0,manager.boundsWidth,manager.boundsHeight);
			bg.graphics.endFill();			
		}
		
	}
}
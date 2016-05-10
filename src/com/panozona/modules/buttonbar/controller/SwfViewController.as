package com.panozona.modules.buttonbar.controller
{
	import com.panozona.modules.buttonbar.model.structure.SwfViewDataItem;
	import com.panozona.modules.buttonbar.view.SwfView;
	import com.panozona.player.module.Module;
	import com.panozona.player.module.utils.ZLoader;
	
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.system.ApplicationDomain;

	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-8-20 上午9:06:06
	 * 功能描述:
	 */
	public class SwfViewController
	{
		
		private var _view:SwfView;
		
		private var module:Module;
		
		private var cameraKeyBindingsClass:Class;
		
		private var initPan:Number = -1;
		
		private var initTitl:Number;
		
		private var initFov:Number;
		
		private var inited:Boolean;
		
		public function SwfViewController(_view:SwfView,module:Module)
		{
			this._view = _view;
			this.module = module;
			
			cameraKeyBindingsClass = ApplicationDomain.currentDomain.getDefinition("com.panosalado.model.CameraKeyBindings") as Class;
			
			var panoramaEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.events.PanoramaEvent") as Class;
			module.qjPlayer.manager.addEventListener(panoramaEventClass.PANORAMA_LOADED, onPanoramaLoaded, false, 0, true);
			onPanoramaLoaded(null);
			
			module.stage.addEventListener(Event.ENTER_FRAME,enterframeHandler);
			
			new ZLoader().load(_view.buttonBarData.swfViewData.url,errFun,CmpFun);
		}
		
		protected function enterframeHandler(event:Event):void
		{
			if(_view.mc_back != null && module.qjPlayer.manager.currentPanoramaData != null && !viewaxix_down) { 
				_view.mc_back.rotationZ = module.qjPlayer.manager.pan + module.qjPlayer.manager.currentPanoramaData.direction;
			}	
			
			var obj:Object = module.qjPlayer.getModuleByName("BackgroundMusic") as Object;
			if(obj != null && _view.mc_music)
			{
				if(obj.isCurrentPlay == true)
				{
					_view.mc_music.gotoAndStop(1);
				}
				else
				{
					_view.mc_music.gotoAndStop(2);
				}
			}
			if(_view != null && _view.stage && _view.mc_fullScene)
			{
				if( _view.stage.displayState == StageDisplayState.NORMAL){
					_view.mc_fullScene.gotoAndStop(1);
				}else{
					_view.mc_fullScene.gotoAndStop(2);
				}
			}
		}
		
		private function onPanoramaLoaded(e:Event):void{
			if(module.qjPlayer.manager.currentPanoramaData){
				initPan = module.qjPlayer.manager.pan;
				initTitl = module.qjPlayer.manager.tilt;
				initFov = module.qjPlayer.manager.fieldOfView;
				inited = true;
			}
		}
		
		private function errFun(e:IOErrorEvent):void
		{
			module.printError(e.text);	
		}
		
		private function CmpFun(e:Event):void
		{
			_view.createUI(e.target.content);
			
			if(_view.mc_compass){
				if(_view.btn_up){
					_view.btn_up.addEventListener(MouseEvent.MOUSE_DOWN,mouseDown, false, 0, true);
					_view.btn_up.addEventListener(MouseEvent.MOUSE_UP,mouseUp, false, 0, true);
				}
				if(_view.btn_left){
					_view.btn_left.addEventListener(MouseEvent.MOUSE_DOWN,mouseDown, false, 0, true);
					_view.btn_left.addEventListener(MouseEvent.MOUSE_UP,mouseUp, false, 0, true);
				}
				if(_view.btn_right){
					_view.btn_right.addEventListener(MouseEvent.MOUSE_DOWN,mouseDown, false, 0, true);
					_view.btn_right.addEventListener(MouseEvent.MOUSE_UP,mouseUp, false, 0, true);
				}
				if(_view.btn_down){
					_view.btn_down.addEventListener(MouseEvent.MOUSE_DOWN,mouseDown, false, 0, true);
					_view.btn_down.addEventListener(MouseEvent.MOUSE_UP,mouseUp, false, 0, true);
				}
				if(_view.btn_reset){
					_view.btn_reset.addEventListener(MouseEvent.MOUSE_DOWN,mouseDown, false, 0, true);
					_view.btn_reset.addEventListener(MouseEvent.MOUSE_UP,mouseUp, false, 0, true);
				}
				if(_view.mc_back){
					_view.mc_back.addEventListener(MouseEvent.MOUSE_DOWN,mouseDown, false, 0, true);
					_view.mc_back.addEventListener(MouseEvent.MOUSE_UP,mouseUp, false, 0, true);
				}
			}
			
			if(_view.mc_mouseScroll){
				if(_view.btn_forward){
					_view.btn_forward.addEventListener(MouseEvent.MOUSE_DOWN,mouseDown, false, 0, true);
					_view.btn_forward.addEventListener(MouseEvent.MOUSE_UP,mouseUp, false, 0, true);
				}
				if(_view.btn_back){
					_view.btn_back.addEventListener(MouseEvent.MOUSE_DOWN,mouseDown, false, 0, true);
					_view.btn_back.addEventListener(MouseEvent.MOUSE_UP,mouseUp, false, 0, true);
				}
			}
			
			if(_view.mc_fullScene){
				_view.mc_fullScene.addEventListener(MouseEvent.MOUSE_DOWN,mouseDown, false, 0, true);
				_view.mc_fullScene.addEventListener(MouseEvent.MOUSE_UP,mouseUp, false, 0, true);
			}
			
			if(_view.mc_music){
				_view.mc_music.addEventListener(MouseEvent.MOUSE_DOWN,mouseDown, false, 0, true);
				_view.mc_music.addEventListener(MouseEvent.MOUSE_UP,mouseUp, false, 0, true);
			}
		}
		
		protected function mouseDown(event:MouseEvent):void
		{
			var s:String = "";
			switch(event.currentTarget){
				case _view.btn_up:
					module.stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, false, true, 0, cameraKeyBindingsClass.UP));
					break;
				case _view.btn_down:
					module.stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, false, true, 0, cameraKeyBindingsClass.DOWN));
					break;
				case _view.btn_left:
					module.stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, false, true, 0, cameraKeyBindingsClass.LEFT));
					break;
				case _view.btn_right:
					module.stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, false, true, 0, cameraKeyBindingsClass.RIGHT));
					break;
				case _view.btn_reset:
					break;
				case _view.btn_forward:
					module.stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, false, true, 0, cameraKeyBindingsClass.IN));
					break;
				case _view.btn_back:
					module.stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, false, true, 0, cameraKeyBindingsClass.OUT));
					break;
				case _view.mc_fullScene:
					break;
				case _view.mc_music:
					break;
				case _view.mc_back:
					viewaxis_x = module.qjPlayer.manager.mouseX;
					viewaxis_y = module.qjPlayer.manager.mouseY;
					
					viewaxis_direction = module.qjPlayer.manager.pan + module.qjPlayer.manager.currentPanoramaData.direction;
					
					viewaxix_down = true;
					
					rotationZ = _view.mc_back.rotationZ;
					
					_view.mc_back.addEventListener(MouseEvent.MOUSE_MOVE,mouseMove, true, 0, true);
					_view.mc_back.addEventListener(MouseEvent.ROLL_OUT,stopMove, true, 0, true);
					break;
			}
		}
		
		protected function stopMove(event:MouseEvent):void{
			if(_view.mc_back.hasEventListener(MouseEvent.MOUSE_MOVE))
				_view.mc_back.removeEventListener(MouseEvent.MOUSE_MOVE,mouseMove);
			if(_view.mc_back.hasEventListener(MouseEvent.ROLL_OUT))
				_view.mc_back.removeEventListener(MouseEvent.ROLL_OUT,stopMove);
			viewaxix_down = false;
		}
		
		protected function mouseMove(event:MouseEvent):void{
			if(viewaxix_down == true)
			{
				
				var tx:Number = module.qjPlayer.manager.mouseX;
				var ty:Number = module.qjPlayer.manager.mouseY;
				
				var pcore:Point = _view.mc_compass.localToGlobal(new Point(40,40));
//				var r:Number = 33.5;
//				var dx:Number = Math.abs(tx - pcore.x);
//				var dy:Number =  Math.abs(ty - pcore.y);
//				var angle1:Number = Math.atan2(dy,dx);
//				
//				var p1:Point = new Point(pcore.x+r/Math.cos(angle1),pcore.y+r/Math.sin(angle1));
				
//				var angle3:Number = Math.atan2(p1.y-viewaxis_y,p1.x-viewaxis_x);
				
				
//				var dx2:Number = Math.abs(tx - pcore.x);
//				var dy2:Number = Math.abs(ty - pcore.y);
//				
//				var angle2:Number = Math.atan2(dy2,dx2);
				

//				
//				var p1:Point = new Point(r/Math.sin(angle1),r/Math.cos(angle1));
//				var p2:Point = new Point(r/Math.sin(angle2),r/Math.cos(angle2));
//				
//				var angle3:Number = Math.atan2(p2.y-p1.y,p2.x-p1.x);
				var angle3:Number = Math.atan2(ty-pcore.y,tx-pcore.x);
//				var angle3:Number = Math.atan2(ty-pcore.y,tx-pcore.x);
				var arrowrotation:Number = (angle3)* 180/Math.PI;
//				if(viewaxis_x > tx)
//				{
//					module.qjPlayer.manager.pan = viewaxis_direction - arrowrotation;
//				}
//				else
//				{
//					module.qjPlayer.manager.pan = viewaxis_direction + arrowrotation;
//				}
				_view.mc_back.rotationZ = arrowrotation+90;
//				trace("arrowrotation="+arrowrotation+" angle3="+angle3);
				module.qjPlayer.manager.pan = _view.mc_back.rotationZ-module.qjPlayer.manager.currentPanoramaData.direction;
			}
		}
		
		private var viewaxis_x:Number = 0;
		private var viewaxis_y:Number = 0;
		private var viewaxis_direction:Number = 0;
		private var viewaxix_down:Boolean= false;
		private var rotationZ:Number = 0;
		
		protected function mouseUp(event:MouseEvent):void
		{
			switch(event.currentTarget){
				case _view.btn_up:
					module.stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP, false, true, 0, cameraKeyBindingsClass.UP));
					break;
				case _view.btn_down:
					module.stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP, false, true, 0, cameraKeyBindingsClass.DOWN));
					break;
				case _view.btn_left:
					module.stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP, false, true, 0, cameraKeyBindingsClass.LEFT));
					break;
				case _view.btn_right:
					module.stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP, false, true, 0, cameraKeyBindingsClass.RIGHT));
					break;
				case _view.btn_reset:
					if(inited)
						module.qjPlayer.manager.swingTo(initPan,initTitl,initFov,60);
					break;
				case _view.btn_forward:
					module.stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP, false, true, 0, cameraKeyBindingsClass.IN));
					break;
				case _view.btn_back:
					module.stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP, false, true, 0, cameraKeyBindingsClass.OUT));
					break;
				case _view.mc_fullScene:
					module.qjPlayer.stage.displayState = (module.qjPlayer.stage.displayState == StageDisplayState.NORMAL) ?
					StageDisplayState.FULL_SCREEN :
					StageDisplayState.NORMAL;
					break;
				case _view.mc_music:
					var item:SwfViewDataItem = _view.buttonBarData.swfViewData.getSwfViewDataItemById("mc_music");
					if(item)
						module.qjPlayer.manager.runAction(item.actionId);
					break;
				case _view.mc_back:
					stopMove(null);
					break;
			}
		}
	}
}
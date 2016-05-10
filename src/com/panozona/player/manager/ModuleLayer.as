package com.panozona.player.manager
{
	import com.panozona.player.module.Module;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	
	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-8-13 下午3:59:31
	 * 功能描述:
	 */
	public class ModuleLayer extends Sprite
	{
		
		private var _mask:Sprite;
		
		private var _manager:Manager;
		
		private var layer:Sprite;
		
		public function ModuleLayer(_manager:Manager)
		{
			super();

			this.mouseEnabled = false;
			
			layer = new Sprite();
			layer.mouseEnabled = false;
			addChild(layer);
			
			this._manager = _manager;
			var ViewEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panosalado.events.ViewEvent") as Class;
			_manager.addEventListener(ViewEventClass.BOUNDS_CHANGED, drawMask, false, 0, true);
			drawMask();
		}
		
		private function drawMask(e:Event=null):void{
			if(!_mask){
				_mask = new Sprite();
				_mask.mouseEnabled = false;
				addChild(_mask);
			}
			_mask.graphics.clear();
			_mask.graphics.beginFill(1,0);
			_mask.graphics.drawRect(0,0,_manager.boundsWidth,_manager.boundsHeight);
			_mask.graphics.endFill();
			_mask.visible = !_canMouse;
		}
		
		
		private var _canMouse:Boolean = true;
		public function get canMouse():Boolean{
			return _canMouse;
		}
		
		public function set canMouse(_canMouse:Boolean):void{
			this._canMouse = _canMouse;
			if(_mask)
				_mask.visible = !_canMouse;
		}
		
		public var modules:Dictionary = new Dictionary();
		public function addModule(module:*):void{
			layer.addChild(module);
			modules[module.moduleDescription.name] = module;
		}
		
		private var restoreList:Array = [];
		
		public function hideOtherModules(names:Array):void{
			for each(var m:* in modules){
				if(names.indexOf(m.moduleDescription.name) >= 0)
					continue;
				hideModule(m.moduleDescription.name);
			}
		}
		
		public function hideModules(names:Array):void{
			for(var i:int=0,n:int=names.length;i<n;i++){
				hideModule(name);
			}
		}
		
		public function hideModule(name:String):void{
			var module:DisplayObject = modules[name] as DisplayObject;
			if(module && module.visible){
				restoreList[name] = name;
				module.visible = false;
			}
		}
		
		public function removeModule(name:String):void{
			var module:DisplayObject = modules[name] as DisplayObject;
			if(module){
				this.layer.removeChild(module);
				delete  modules[name];
			}
		}
		public function removeModules():void
		{
			while(this.layer.numChildren)
			{
				this.layer.removeChildAt(0);
			}
			modules = new Dictionary();
		}
		
		public function restoreModules():void{
			for each(var name:String in restoreList){
				modules[name].visible = true;
			}
			restoreList = [];
		}
	}
}
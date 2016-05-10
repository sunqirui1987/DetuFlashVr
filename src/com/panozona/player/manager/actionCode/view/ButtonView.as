package com.panozona.player.manager.actionCode.view
{
	import com.panozona.player.manager.actionCode.Actioncode;
	import com.panozona.player.module.data.property.Align;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-9-18 上午10:25:28
	 * 功能描述:
	 */
	public class ButtonView extends Sprite
	{
		
		private var _horizontal:String;
		private var _vertical:String;
		
		private var _moveHorizontal:Number;
		private var _moveVertical:Number;
		
		private var _path:String;
		
		private var _click:String;
		
		public var loadCmpToNext:Boolean = true;
		
		private var isLoaded:Boolean;
		
		private var loader:Loader;
		
		private var ac:Actioncode;
		
		public function ButtonView(ac:Actioncode)
		{
			super();
			this.ac = ac;
		}
		
		//-----------------------get set----------------------
		public function get path():String{
			return this._path;
		}
		public function set path(_path:String):void{
			if(this._path == _path)
				return;
			this._path = _path;
			isLoaded = false;
			if(loader){
				loader.unload();
			}else{
				loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onCmp);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onErr);
				addChild(loader);
			}
			loader.load(new URLRequest(_path),new LoaderContext(true));
		}
		
		public function get horizontal():String{
			return this._horizontal;
		}
		public function set horizontal(_horizontal:String):void{
			this._horizontal = _horizontal;
		}
		
		public function get vertical():String{
			return this._vertical;
		}
		public function set vertical(_vertical:String):void{
			this._vertical = _vertical;
		}
		
		public function get moveHorizontal():Number{
			return this._moveHorizontal;
		}
		public function set moveHorizontal(_moveHorizontal:Number):void{
			this._moveHorizontal = _moveHorizontal;
		}
		
		public function get moveVertical():Number{
			return this._moveVertical;
		}
		public function set moveVertical(_moveVertical:Number):void{
			this._moveVertical = _moveVertical;
		}
		
		public function get click():String{
			return this._click;
		}
		public function set click(_click:String):void{
			if(this._click == _click)
				return;
			this._click = _click;
			buttonMode = _click;
			if(_click){
				addEventListener(MouseEvent.CLICK,onClick);
			}else{
				if(hasEventListener(MouseEvent.CLICK))
					removeEventListener(MouseEvent.CLICK,onClick);
			}
		}
		
		//--------------------
		
		public function showAlign():void{
			this.x = getX();
			this.y = getY();
		}
		
		private function getX():Number {
			var result:Number = 0;
			switch(horizontal) {
				case Align.RIGHT:
					result += ac.qjPlayer.manager.boundsWidth
					- width 
					+ moveHorizontal;
					break;
				case Align.LEFT:
					result += moveHorizontal;
					break;
				default: // CENTER
					result += (ac.qjPlayer.manager.boundsWidth
						- width) * 0.5 
					+ moveHorizontal;
			}
			return result;
		}
		
		private function getY():Number{
			var result:Number = 0;
			switch(vertical) {
				case Align.TOP:
					result += moveVertical;
					break;
				case Align.BOTTOM:
					result += ac.qjPlayer.manager.boundsHeight 
					- height
					+ moveVertical;
					break;
				default: // MIDDLE
					result += (ac.qjPlayer.manager.boundsHeight
						- height) * 0.5
					+ moveVertical;
			}
			return result;
		}
		
		protected function onErr(event:IOErrorEvent):void
		{
			trace(event.text);
			ac.playNextCommand();
		}
		
		protected function onCmp(event:Event):void
		{
			isLoaded = true;
			showAlign();
			if(loadCmpToNext)
				ac.playNextCommand();
		}
		
		protected function onClick(event:Event):void
		{
			ac.runById(click);
		}
		
		public function destroy():void{
			if(loader && loader.contentLoaderInfo){
				if(loader.contentLoaderInfo.hasEventListener(Event.COMPLETE))
					loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onCmp);
				if(loader.contentLoaderInfo.hasEventListener(IOErrorEvent.IO_ERROR))
					loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onErr);
			}
			if(parent){
				parent.removeChild(this);
			}
			if(hasEventListener(MouseEvent.CLICK))
				removeEventListener(MouseEvent.CLICK,onClick);
		}
	}
}
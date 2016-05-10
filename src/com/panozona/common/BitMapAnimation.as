package com.panozona.common
{
	import com.panosalado.view.ManagedChild;
	import com.panozona.modules.inteltool.event.IntertoolEvent;
	import com.panozona.player.manager.Manager;
	import com.panozona.player.manager.utils.ImageCutter;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.getTimer;
	
	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-5-9 下午5:37:16
	 * 功能描述:
	 */
	public class BitMapAnimation extends Sprite
	{
		public var row:int;
		public var column:int;
		public var s_path:String;
		public var interval:int;
		
		private var bmdArr:Array;
		private var showBmdArr:Array;
		
		private var bmp:Bitmap;
		
		private var index:int = -1;
		private var len:int = 0;
		
		private var states:Array;
		private var _state:String;
		
		public function BitMapAnimation(row:int,column:int,path:String,interval:int,states:Array,_showState:String)
		{
			super();
			this.row = row;
			this.column = column;
			this.s_path = path;
			this.interval = interval;
			this.states = states;
			this._state = _showState;
			
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, imageLost);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoaded);
			loader.load(new URLRequest(this.s_path),new flash.system.LoaderContext(true));
		}
		
		public function imageLost(e:IOErrorEvent):void {
			(e.target as LoaderInfo).removeEventListener(IOErrorEvent.IO_ERROR, imageLost);
			(e.target as LoaderInfo).removeEventListener(Event.COMPLETE, imageLoaded);
		}
		
		public function imageLoaded(e:Event):void {
			(e.target as LoaderInfo).removeEventListener(IOErrorEvent.IO_ERROR, imageLost);
			(e.target as LoaderInfo).removeEventListener(Event.COMPLETE, imageLoaded);
			bmdArr = ImageCutter.cut(e.target.content.bitmapData,column,row);
			bmp = new Bitmap();
			addChild(bmp);
			state = _state;
			star();
			onRender(null);
			dispatchEvent(new IntertoolEvent(IntertoolEvent.SOURCE_LOADED));
		}
		
		private var t:Number;
		
		protected function onRender(event:Event):void
		{
			if(interval > 0){
				if(getTimer()-t<interval)
					return;
				t = getTimer();
			}
			index++;
			if(index >= len){
				index = 0;
			}
			if(showBmdArr.length > index)
				bmp.bitmapData = showBmdArr[index];
		}
		
		private var isPlaying:Boolean;
		public function stop():void{
			if(!isPlaying)
				return;
			isPlaying = false;
			if(hasEventListener(Event.ENTER_FRAME))
				removeEventListener(Event.ENTER_FRAME,onRender);
		}
		
		public function star():void{
			if(isPlaying)
				return;
			isPlaying = true;
			addEventListener(Event.ENTER_FRAME,onRender);
		}
		
		public function set state(_state:String):void{
			if(!states)
				return;
			this._state = _state;
			var rang:Ranger = states[_state] as Ranger;
			if(rang){
				stop();
				t = 0;
				index = 0;
				showBmdArr = bmdArr.slice(rang.begin,rang.end);
				len = showBmdArr.length;
				trace(this._state+" --- "+len);
				star();
			}
		}
		
		public function get state():String{
			return _state;
		}
	}
}
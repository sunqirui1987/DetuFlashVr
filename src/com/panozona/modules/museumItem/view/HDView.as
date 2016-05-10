package com.panozona.modules.museumItem.view
{
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-6-11 下午2:45:39
	 * 功能描述:
	 */
	public class HDView extends Sprite
	{
		public var w:Number;
		
		public var h:Number;
		
		private var _mask:Sprite;
		
		public function HDView(url:String,w:Number,h:Number)
		{
			super();
			if(!url)
				return;
			
			_mask = new Sprite();
			addChild(_mask);
			
			setWh(w,h);
			reload(url);
		//	loader.load(new URLRequest("hd.swf?xml=http://fwhd50.img.detuyun.cn/138785260752b8f33fa48c8/oper/52b8f33e25b18.xml&zzzxml=&chazi=10"+"&width="+w+"&height="+h+"&isSetWH=true"));
		}
		
		public function setWh(w:Number,h:Number):void{
			this.w = w;
			this.h = h;
			_mask.graphics.clear();
			_mask.graphics.beginFill(0xFFFFFF,0);
			_mask.graphics.drawRect(0,0,w,h);
			_mask.graphics.endFill();	
			if(isloaded){
				if(obj && obj.hasOwnProperty("setWH"))
					(obj as Object).setWH(w,h);
			}
		}
		
		private var isloaded:Boolean;
		
		private var obj:DisplayObject;
		
		protected function onCmp(event:Event):void
		{
			event.target.removeEventListener( Event.COMPLETE, onCmp );
			event.target.removeEventListener( IOErrorEvent.IO_ERROR, onErr );
			try{
			obj = event.target.content as DisplayObject;
			if(obj)
				addChild(obj);	
			isloaded = true;
			setWh(w,h); //设置
			}catch(error:Error) {
				trace(error.message);
			}
		}
		
		public function reload(url:String):void{
			try{
				destroy();
				loader = new Loader();
				loader.contentLoaderInfo.addEventListener( Event.COMPLETE, onCmp );
				loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, onErr );
				loader.load(new URLRequest(url+"&width="+w+"&height="+h+"&isSetWH=true"),new LoaderContext(true));
			}catch(error:Error) {
				trace(error.message);
			}
		}
		
		private var loader:Loader;
		
		protected function onErr(event:IOErrorEvent):void
		{
			// TODO Auto-generated method stub
			event.target.removeEventListener( Event.COMPLETE, onCmp );
			event.target.removeEventListener( IOErrorEvent.IO_ERROR, onErr );
		}
		
		public function destroy():void{
			if(loader)
				loader.unload();
			loader = null;
			if(obj && contains(obj))
				removeChild(obj);
			obj = null;
			isloaded = false;
		}
		
	}
}
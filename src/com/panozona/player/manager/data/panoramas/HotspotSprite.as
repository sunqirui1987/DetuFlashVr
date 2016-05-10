package  com.panozona.player.manager.data.panoramas
{
	
	import com.panosalado.view.Hotspot;

	import flash.display.DisplayObject;

	import flash.display.Loader;
	import flash.display.LoaderInfo;

	import flash.events.Event;
	import flash.events.IOErrorEvent;

	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	
	public class HotspotSprite extends Hotspot
	{
		private var _path:String;

		public function HotspotSprite(displayObject:DisplayObject=null):void 
		{
			super(displayObject);
		}
		public function set path(str:String):void
		{
			
			this._path = str;
			
			this.draw();
		}

		public function draw():void
		{
			var buttonLoader:Loader = new Loader();
			buttonLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, buttonImageLost);
			buttonLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, buttonImageLoaded);
			buttonLoader.load(new URLRequest(this._path),new flash.system.LoaderContext(true));
		}
		
		public function buttonImageLost(e:IOErrorEvent):void {
			(e.target as LoaderInfo).removeEventListener(IOErrorEvent.IO_ERROR, buttonImageLost);
			(e.target as LoaderInfo).removeEventListener(Event.COMPLETE, buttonImageLoaded);
			
		}
		
		public function buttonImageLoaded(e:Event):void {
			(e.target as LoaderInfo).removeEventListener(IOErrorEvent.IO_ERROR, buttonImageLost);
			(e.target as LoaderInfo).removeEventListener(Event.COMPLETE, buttonImageLoaded);
			
			if(lastContent && contains(lastContent))
				removeChild(lastContent);
			
			lastContent = (e.target as LoaderInfo).content;
			lastContent.x = -lastContent.width/2;
			lastContent.y = -lastContent.height/2;
			
			
			this.addChild(lastContent);
		}
		
		private var lastContent:DisplayObject;
	}
}


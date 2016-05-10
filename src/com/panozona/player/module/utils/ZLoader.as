package   com.panozona.player.module.utils
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;

	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-6-26 下午1:36:44
	 * 功能描述:
	 */
	public class ZLoader
	{
		
		private var errfun:Function;
		
		private var cmpFun:Function;
		
		public function ZLoader()
		{
		}
		
		public function load(path:String,errfun:Function=null,cmpFun:Function=null):void{
			
			this.errfun = errfun;
			this.cmpFun = cmpFun;
			
			var imageLoader:Loader = new Loader();
			imageLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, imageLost);
			imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoaded);
			imageLoader.load(new URLRequest(path),new LoaderContext(true));
		}
		
		protected function imageLoaded(event:Event):void
		{
			event.target.removeEventListener(IOErrorEvent.IO_ERROR, imageLost);
			event.target.removeEventListener(Event.COMPLETE, imageLoaded);
			if(this.cmpFun != null){
				this.cmpFun(event);
				this.errfun = null;
				this.cmpFun = null;
			}
		}
		
		protected function imageLost(event:IOErrorEvent):void
		{
			event.target.removeEventListener(IOErrorEvent.IO_ERROR, imageLost);
			event.target.removeEventListener(Event.COMPLETE, imageLoaded);
			if(this.errfun != null){
				this.errfun(event);
				this.errfun = null;
				this.cmpFun = null;
			}
		}
	}
}
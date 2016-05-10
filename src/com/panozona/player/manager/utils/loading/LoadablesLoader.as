/*
 OuWei Flash3DHDView 
*/
package com.panozona.player.manager.utils.loading{
	
	import com.panosalado.view.Hotspot;
	import com.panozona.player.manager.data.panoramas.HotspotBitmapAnimation;
	import com.panozona.player.manager.data.panoramas.HotspotPolygonal;
	import com.panozona.player.manager.events.LoadLoadableEvent;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	public class LoadablesLoader extends EventDispatcher{
		
		private var loaders:Vector.<Loader>;
		private var loadables:Vector.<ILoadable>;
		private var _extraobj:Object;
		

		
		public function load(loadables:Vector.<ILoadable>):void {
			this.loadables = loadables;
			loaders = new Vector.<Loader>();
			var context:LoaderContext = new LoaderContext(true, ApplicationDomain.currentDomain);
			context.checkPolicyFile = true;//新增
			for (var i:int = 0; i < loadables.length; i++) {
				if (loadables[i].path == null || !loadables[i].path.match(/^.+(.jpg|.jpeg|.png|.gif|.swf|__innerDisplayObj)$/i)) {
					dispatchEvent(new LoadLoadableEvent(LoadLoadableEvent.LOST, loadables[i]));
					loaders[i] = null;
					continue;
				}
				if(loadables[i].path.indexOf("hotspot__innerDisplayObj") == 0)
				{
					var shot:Hotspot = new Hotspot();
					loaders[i] = null;
					dispatchEvent(new LoadLoadableEvent(LoadLoadableEvent.LOADED, loadables[i],shot));
					continue;
				}
				//得到Object
				if(loadables[i].path.indexOf("hotspotPolygonal__innerDisplayObj") == 0)
				{
					var hot:HotspotPolygonal = loadables[i] as HotspotPolygonal;
					var hotsprite:Sprite =hot.render(_extraobj);
					loaders[i] = null;
					if(hotsprite == null)
					{
						continue;
					}
					dispatchEvent(new LoadLoadableEvent(LoadLoadableEvent.LOADED, loadables[i],hotsprite));
					continue;
				}
				
				//得到Object
				if(loadables[i].path.indexOf("animation__innerDisplayObj") == 0)
				{
					var hotAnj:HotspotBitmapAnimation = loadables[i] as HotspotBitmapAnimation;
					hotsprite =hotAnj.render(_extraobj);
					loaders[i] = null;
					if(hotsprite == null)
					{
						continue;
					}
					dispatchEvent(new LoadLoadableEvent(LoadLoadableEvent.LOADED, loadables[i],hotsprite));
					continue;
				}

				loaders[i] = new Loader();
				loaders[i].contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loadableLost);
				loaders[i].contentLoaderInfo.addEventListener(Event.COMPLETE, loadableLoaded);
				loaders[i].load(new URLRequest(loadables[i].path), context);
			}
			checkLoadingState(); // perhaps there is nothing to load 
		}
		
		public function set extraobj(obj:Object):void	
		{
			this._extraobj = obj;
		}
	
		
		public function abort():void{
			for (var i:int = 0; i < loaders.length; i++) {
				if (loaders[i] != null) {
					loaders[i].unload();
					loaders[i] = null;
				}
			}
			dispatchEvent(new LoadLoadableEvent(LoadLoadableEvent.ABORTED));
		}
		
		private function loadableLost(e:IOErrorEvent):void {
			for(var i:int = 0; i < loaders.length; i++) {
				if (loaders[i] != null && loaders[i].contentLoaderInfo === e.target) {
					dispatchEvent(new LoadLoadableEvent(LoadLoadableEvent.LOST, loadables[i]));
					loaders[i].contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loadableLost);
					loaders[i].contentLoaderInfo.removeEventListener(Event.COMPLETE, loadableLoaded);
					loaders[i] = null;
					checkLoadingState();
					return;
				}
			}
		}
		
		private function loadableLoaded(e:Event):void {
			for(var i:int = 0; i < loaders.length; i++){
				if (loaders[i] != null && loaders[i].contentLoaderInfo === e.target) {
					dispatchEvent(new LoadLoadableEvent(LoadLoadableEvent.LOADED, loadables[i], loaders[i].content));
					loaders[i].contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loadableLost);
					loaders[i].contentLoaderInfo.removeEventListener(Event.COMPLETE, loadableLoaded);
					loaders[i] = null;
					checkLoadingState();
					return;
				}
			}
		}
		
		private function checkLoadingState():void {
			for (var i:int = 0; i < loaders.length; i++) {
				if (loaders[i] != null) {
					return;
				}
			}
			dispatchEvent(new LoadLoadableEvent(LoadLoadableEvent.FINISHED));
		}
	}
}

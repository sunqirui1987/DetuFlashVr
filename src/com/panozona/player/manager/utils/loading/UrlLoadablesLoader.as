/*
 OuWei Flash3DHDView 
*/
package com.panozona.player.manager.utils.loading{
	
	//import cmodule.Decryptor.CLibInit;
	
//	import cmodule.Decryptor.CLibInit;

	import com.panozona.modules.backgroundmusic.BackgroundMusic;
	import com.panozona.modules.baiduMap.BaiduMap;
	import com.panozona.modules.buttonbar.ButtonBar;
	import com.panozona.modules.compass.Compass;
	import com.panozona.modules.dropdown.DropDown;
	import com.panozona.modules.guide.Guide;
	import com.panozona.modules.imagebutton.ImageButton;
	import com.panozona.modules.imagemap.ImageMap;
	import com.panozona.modules.infobubble.InfoBubble;
	import com.panozona.modules.inteltool.IntelTool;
	import com.panozona.modules.jsgateway.JSGateway;
	import com.panozona.modules.linkopener.LinkOpener;
	import com.panozona.modules.menuscroller.MenuScroller;
	import com.panozona.modules.mousecursor.MouseCursor;
	import com.panozona.modules.museumItem.MuseumItemModule;
	import com.panozona.modules.openMovie.OpenMovie;
	import com.panozona.modules.openhd.OpenHD;
	import com.panozona.modules.ouweijt.OuweiJt;
	import com.panozona.modules.panoramaTitleAndDes.PanoramaTitleAndDes;
	import com.panozona.modules.storyScript.StoryScript;
	import com.panozona.modules.swfobject.SwfObject;
	import com.panozona.modules.viewfinder.ViewFinder;
	import com.panozona.player.manager.events.LoadLoadableEvent;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	public class UrlLoadablesLoader extends EventDispatcher{
		
	
		private var loaders:Vector.<URLLoader>;
		private var loadables:Vector.<ILoadable>;
		
		public function load(loadables:Vector.<ILoadable>):void {
			this.loadables = loadables;
			loaders = new Vector.<URLLoader>();
	
			var context:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
			context.checkPolicyFile = true;//新增
			for (var i:int = 0; i < loadables.length; i++) {
				if (loadables[i].path == null || !loadables[i].path.match(/^.+(.jpg|.jpeg|.png|.gif|.swf)$/i)) {
					dispatchEvent(new LoadLoadableEvent(LoadLoadableEvent.LOST, loadables[i]));
					loaders[i] = null;
					continue;
				}
				

				//自加载
				if(loadables[i].path.toLocaleLowerCase().indexOf("mousecursor") > 0)
				{
					var mousecursor:MouseCursor=new com.panozona.modules.mousecursor.MouseCursor();
					mousecursor.mouseEnabled=false;
					dispatchEvent(new LoadLoadableEvent(LoadLoadableEvent.LOADED, loadables[i],mousecursor));
					loaders[i]=null;
					
					continue;
				}		
				else if(loadables[i].path.toLocaleLowerCase().indexOf("buttonbar") > 0)
				{
					var btn:ButtonBar=new ButtonBar();
					dispatchEvent(new LoadLoadableEvent(LoadLoadableEvent.LOADED, loadables[i],btn));
					loaders[i]=null;
				
					continue;
				}		
				
				else if(loadables[i].path.toLocaleLowerCase().indexOf("imagebutton") > 0)
				{
					var imgbtn:ImageButton=new ImageButton();
					dispatchEvent(new LoadLoadableEvent(LoadLoadableEvent.LOADED, loadables[i],imgbtn));
					loaders[i]=null;
			
					continue;
				}
				else if(loadables[i].path.toLocaleLowerCase().indexOf("dropdown") > 0)
				{
					var dd:DropDown=new  DropDown();
					dispatchEvent(new LoadLoadableEvent(LoadLoadableEvent.LOADED, loadables[i],dd));
					loaders[i]=null;
		
					continue;
				}
				else if(loadables[i].path.toLocaleLowerCase().indexOf("imagemap") > 0)
				{
					var im:ImageMap=new ImageMap();
					dispatchEvent(new LoadLoadableEvent(LoadLoadableEvent.LOADED, loadables[i],im));
					loaders[i]=null;
				
					continue;
				}
				else if(loadables[i].path.toLocaleLowerCase().indexOf("openhd") > 0)
				{
					var op:OpenHD=new OpenHD();
					dispatchEvent(new LoadLoadableEvent(LoadLoadableEvent.LOADED, loadables[i],op));
					loaders[i]=null;
				
					continue;
				}
				else if(loadables[i].path.toLocaleLowerCase().indexOf("swfobject") > 0)
				{
					var sb:SwfObject = new SwfObject();
					dispatchEvent(new LoadLoadableEvent(LoadLoadableEvent.LOADED, loadables[i],sb));
					loaders[i]=null;
					
					continue;
				}
				else if(loadables[i].path.toLocaleLowerCase().indexOf("jsgateway") > 0)
				{
					var jg:JSGateway=new JSGateway();
					dispatchEvent(new LoadLoadableEvent(LoadLoadableEvent.LOADED, loadables[i],jg));
					loaders[i]=null;
					
					continue;
				}
				else if(loadables[i].path.toLocaleLowerCase().indexOf("infobubble") > 0)
				{
					var ibb:InfoBubble = new  InfoBubble();
					dispatchEvent(new LoadLoadableEvent(LoadLoadableEvent.LOADED, loadables[i],ibb));
					loaders[i]=null;
					
					continue;
				}
				else if(loadables[i].path.toLocaleLowerCase().indexOf("linkopener") > 0)
				{
					var lo:LinkOpener = new LinkOpener();
					dispatchEvent(new LoadLoadableEvent(LoadLoadableEvent.LOADED, loadables[i],lo));
					loaders[i]=null;
					
					continue;
				}
				else if(loadables[i].path.toLocaleLowerCase().indexOf("backgroundmusic") > 0)
				{
					var lbm:BackgroundMusic = new BackgroundMusic();
					dispatchEvent(new LoadLoadableEvent(LoadLoadableEvent.LOADED, loadables[i],lbm));
					loaders[i]=null;
					continue;
				}
				else if(loadables[i].path.toLocaleLowerCase().indexOf("inteltool") > 0)
				{
					var ti:IntelTool = new IntelTool()
					dispatchEvent(new LoadLoadableEvent(LoadLoadableEvent.LOADED, loadables[i],ti));
					loaders[i]=null;
					continue;	
					
				}
				else if(loadables[i].path.toLocaleLowerCase().indexOf("menuscroller") > 0)
				{
					var mti:MenuScroller = new MenuScroller()
					dispatchEvent(new LoadLoadableEvent(LoadLoadableEvent.LOADED, loadables[i],mti));
					loaders[i]=null;
					continue;	
					
				}
				else if(loadables[i].path.toLocaleLowerCase().indexOf("ouweijt") > 0)
				{
					var tmti:OuweiJt = new OuweiJt();
					dispatchEvent(new LoadLoadableEvent(LoadLoadableEvent.LOADED, loadables[i],tmti));
					loaders[i]=null;
					continue;	
					
				}
				else if(loadables[i].path.toLocaleLowerCase().indexOf("viewfinder") > 0)
				{
					var vmti:ViewFinder = new ViewFinder();
					dispatchEvent(new LoadLoadableEvent(LoadLoadableEvent.LOADED, loadables[i],vmti));
					loaders[i]=null;
					continue;	
					
				}
				else if(loadables[i].path.toLocaleLowerCase().indexOf("compass") > 0)
				{
					var cmti:Compass = new Compass();
					dispatchEvent(new LoadLoadableEvent(LoadLoadableEvent.LOADED, loadables[i],cmti));
					loaders[i]=null;
					continue;	
					
				}
				
			
				
				//>>>>>>>>>>>新增模块 片头动画>>>>>>>>>>>>>>>>
				else if(loadables[i].path.toLocaleLowerCase().indexOf("openmovie") > 0)
				{
					var om:OpenMovie = new OpenMovie();
					dispatchEvent(new LoadLoadableEvent(LoadLoadableEvent.LOADED, loadables[i],om));
					loaders[i]=null;
					continue;	
					
				}
				//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	
				//>>>>>>>>>>>新增模块  百度地图>>>>>>>>>>>>>>>>
				/*	else if(loadables[i].path.toLocaleLowerCase().indexOf("baidumap") > 0)
				{
					var bdmap:BaiduMap = new BaiduMap();
					dispatchEvent(new LoadLoadableEvent(LoadLoadableEvent.LOADED, loadables[i],bdmap));
					loaders[i]=null;
					continue;	
					
				}
				else if(loadables[i].path.toLocaleLowerCase().indexOf("guestbook") > 0)
				{
				var gbti:GuestBook = new GuestBook();
				dispatchEvent(new LoadLoadableEvent(LoadLoadableEvent.LOADED, loadables[i],gbti));
				loaders[i]=null;
				continue;	
				
				} */
				//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
				
				//>>>>>>>>>>>新增模块 博物馆物品>>>>>>>>>>>>>>>>
				else if(loadables[i].path.toLocaleLowerCase().indexOf("museumitem") > 0)
				{
					var mi:MuseumItemModule = new MuseumItemModule();
					dispatchEvent(new LoadLoadableEvent(LoadLoadableEvent.LOADED, loadables[i],mi));
					loaders[i]=null;
					continue;	
				}
				
					//>>>>>>>>>>>新增模块  全景名称和描述>>>>>>>>>>>>>>>>
				else if(loadables[i].path.toLocaleLowerCase().indexOf("panoramatitleanddes") > 0)
				{
					var ptd:PanoramaTitleAndDes = new PanoramaTitleAndDes();
					dispatchEvent(new LoadLoadableEvent(LoadLoadableEvent.LOADED, loadables[i],ptd));
					loaders[i]=null;
					continue;	
				}
				
					//>>>>>>>>>>>新增模块  剧本>>>>>>>>>>>>>>>>
				else if(loadables[i].path.toLocaleLowerCase().indexOf("storyscript") > 0)
				{
					var ss:StoryScript = new StoryScript();
					dispatchEvent(new LoadLoadableEvent(LoadLoadableEvent.LOADED, loadables[i],ss));
					loaders[i]=null;
					continue;	
				}
				
					//>>>>>>>>>>>新增模块  引导>>>>>>>>>>>>>>>>
				else if(loadables[i].path.toLocaleLowerCase().indexOf("guide") > 0)
				{
					var gd:Guide = new Guide();
					dispatchEvent(new LoadLoadableEvent(LoadLoadableEvent.LOADED, loadables[i],gd));
					loaders[i]=null;
					continue;	
				}
				trace("><>>>>"+loadables[i].path);
				loaders[i] = new URLLoader();
				//loaders[i].dataFormat = URLLoaderDataFormat.BINARY;
				loaders[i].addEventListener(IOErrorEvent.IO_ERROR, loadableLost);
				loaders[i].addEventListener(Event.COMPLETE, loadableLoaded);
				loaders[i].load(new URLRequest(loadables[i].path));
				
			}
			checkLoadingState(); // perhaps there is nothing to load 
		}
		
		public function abort():void{
			for (var i:int = 0; i < loaders.length; i++) {
				if (loaders[i] != null) {
					
					loaders[i] = null;
				}
			}
			dispatchEvent(new LoadLoadableEvent(LoadLoadableEvent.ABORTED));
		}
		
		private function loadableLost(e:IOErrorEvent):void {
			for(var i:int = 0; i < loaders.length; i++) {
				if (loaders[i] != null) {
					dispatchEvent(new LoadLoadableEvent(LoadLoadableEvent.LOST, loadables[i]));
					loaders[i].removeEventListener(IOErrorEvent.IO_ERROR, loadableLost);
					loaders[i].removeEventListener(Event.COMPLETE, loadableLoaded);
					loaders[i] = null;
					checkLoadingState();
					return;
				}
			}
		}
		
		private function loadableLoaded(e:Event):void {
			for(var i:int = 0; i < loaders.length; i++){
				
				if (loaders[i] != null && loaders[i].data != null ) {
				
					var loader:Loader = e.target.loader as Loader;
					dispatchEvent(new LoadLoadableEvent(LoadLoadableEvent.LOADED, loadables[i],loader.content ));
					loaders[i].removeEventListener(IOErrorEvent.IO_ERROR, loadableLost);
					loaders[i].removeEventListener(Event.COMPLETE, loadableLoaded);
					loaders[i].data = null;
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
			trace("完 ");
			dispatchEvent(new LoadLoadableEvent(LoadLoadableEvent.FINISHED));
		}
	}
}

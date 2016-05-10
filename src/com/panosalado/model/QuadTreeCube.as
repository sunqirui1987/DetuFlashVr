
package com.panosalado.model {
	
	import com.panosalado.events.ReadyEvent;
	import com.panosalado.loading.IOErrorEventHandler;
	import com.panozona.player.manager.taobao.Service;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Vector3D;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.getQualifiedClassName;
	
	public class QuadTreeCube extends Tile {
		
		public var tilePyramids:Vector.<TilePyramid>;
		public var paths:Vector.<String>;
		public var displayingTile:Tile;
		
		protected var bitmapsLoaded:int;
		protected var previewbitmapdata:BitmapData;
		protected var path:String;
		protected var isNewPreview:Boolean = false;//是否新版的显示方式
		
		public function QuadTreeCube(path:String,previewpath:String = ""){
			super();
			
			
			
			bitmapsLoaded = 0;
			this.path = path;
			
			if(previewpath != "" && previewpath != "null" && previewpath !=  null)
			{
				//历史命名的原因
				if(previewpath.lastIndexOf("_preview_detunew.jpg") > 0  || previewpath.lastIndexOf("_preview__detunew.jpg") > 0 || previewpath.lastIndexOf("preview__detunew__.jpg") > 0)
				{
					 this.isNewPreview = true; // 新版缩略图方式，为了兼容krpano
				}
				previewpath = com.panozona.player.manager.taobao.Service.getInstance().filterpathurl(previewpath);
	
				var urlRequest:URLRequest = new URLRequest(previewpath);
				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadpreviewpath);
				loader.load(urlRequest,new LoaderContext(true));
			}
			else
			{
				loadpreviewpath(null);
			}
			
		}
		private function loadpreviewpath(event:Event=null):void
		{
			if(event != null)
			{
				this.previewbitmapdata = Bitmap(LoaderInfo(event.target).content).bitmapData;
			}
			var tilePyramidClass:Class = TilePyramid.guessSubClassFromURL(path);
			var tilePyramid:TilePyramid = new tilePyramidClass();
			tilePyramid.path = path;
			this.paths = predictPaths(tilePyramid.disassembleDescriptorURL(path));
			this.tilePyramids = Vector.<TilePyramid>([tilePyramid]);
			//add listener first in case event is dispatched synchronously.
			tilePyramid.addEventListener( ReadyEvent.READY, tilePyramidReady, false, 0, false); //NB: use strong references.
			tilePyramid.loadDescriptor(path);
		}
		
		
		protected function tilePyramidReady(event:ReadyEvent):void {
			(event.target as TilePyramid).removeEventListener(ReadyEvent.READY,tilePyramidReady); //NB: strong referenced, must remove.
		
			
			var tilePyramid:TilePyramid = tilePyramids[0];
			for (var i:int = 1; i < 6; i++) {
				var into:TilePyramid = (i < tilePyramids.length) ? tilePyramids[i] as TilePyramid : null;
				tilePyramids[i] = tilePyramid.clone(into);
				tilePyramids[i].path = paths[i]; 
			}
			
			var ct:Tile;
			var v:Vector.<Vector3D>;
			var across:Number;
			var at:Number;
			var w:int = tilePyramids[0].width;
			
			across = w * 0.5;
			at = w * 0.5;
			ct = this;
			
			//front
			v = new Vector.<Vector3D>(4,true);
			v[0] = new Vector3D(-across,-across,at); //tl
			v[1] = new Vector3D(across,-across,at); //tr
			v[2] = new Vector3D(-across,across,at); //bl
			v[3] = new Vector3D(across,across,at); //br
			addEventListener(ReadyEvent.READY, waitForBitmaps, false, 0, true);
			Tile.init(super, tilePyramids[0], v, "x", "y", "z","_f",previewbitmapdata,isNewPreview);
			
			//right
			ct.n = new Tile();
			ct = ct.n;
			v = new Vector.<Vector3D>(4,true);
			v[0] = new Vector3D(at,-across,across);
			v[1] = new Vector3D(at,-across,-across);
			v[2] = new Vector3D(at,across,across);
			v[3] = new Vector3D(at,across,-across);
			ct.addEventListener(ReadyEvent.READY, waitForBitmaps, false, 0, true);
			Tile.init(ct, tilePyramids[1], v, "z", "y", "x","_r",previewbitmapdata,isNewPreview);
			
			//back
			ct.n = new Tile();
			ct = ct.n;
			v = new Vector.<Vector3D>(4,true);
			v[0] = new Vector3D(across,-across,-at);
			v[1] = new Vector3D(-across,-across,-at);
			v[2] = new Vector3D(across,across,-at);
			v[3] = new Vector3D(-across,across,-at);
			ct.addEventListener(ReadyEvent.READY, waitForBitmaps, false, 0, true);
			Tile.init(ct, tilePyramids[2], v, "x", "y", "z","_b",previewbitmapdata,isNewPreview);
			
			//left
			ct.n = new Tile();
			ct = ct.n;
			v = new Vector.<Vector3D>(4,true);
			v[0] = new Vector3D(-at,-across,-across);
			v[1] = new Vector3D(-at,-across,across);
			v[2] = new Vector3D(-at,across,-across);
			v[3] = new Vector3D(-at,across,across);
			ct.addEventListener(ReadyEvent.READY, waitForBitmaps, false, 0, true);
			Tile.init(ct, tilePyramids[3], v, "z", "y", "x","_l",previewbitmapdata,isNewPreview);
			
			//up
			ct.n = new Tile();
			ct = ct.n;
			v = new Vector.<Vector3D>(4,true);
			v[0] = new Vector3D(-across,-at,-across);
			v[1] = new Vector3D(across,-at,-across);
			v[2] = new Vector3D(-across,-at,across);
			v[3] = new Vector3D(across,-at,across);
			ct.addEventListener(ReadyEvent.READY, waitForBitmaps, false, 0, true);
			Tile.init(ct, tilePyramids[4], v, "x", "z", "y","_u",previewbitmapdata,isNewPreview);
			
			//down
			ct.n = new Tile();
			ct = ct.n;
			v = new Vector.<Vector3D>(4,true);
			v[0] = new Vector3D(-across,at,across);
			v[1] = new Vector3D(across,at,across);
			v[2] = new Vector3D(-across,at,-across);
			v[3] = new Vector3D(across,at,-across);
			ct.addEventListener(ReadyEvent.READY, waitForBitmaps, false, 0, true);
			Tile.init(ct,tilePyramids[5],v,"x","z","y","_d",previewbitmapdata,isNewPreview);
			ct.n = null;
		}
		
		protected function waitForBitmaps(event:ReadyEvent):void {
			bitmapsLoaded++;
			(event.target as EventDispatcher).removeEventListener(ReadyEvent.READY, this.waitForBitmaps); //NB: must remove or infinite loop with this and super
			if (bitmapsLoaded < 6) return;
			ready = true;
			dispatchEvent( new ReadyEvent(ReadyEvent.READY, tilePyramid));
		}
		
		protected function predictPaths(input:DisassembledDescriptorURL):Vector.<String>{
			var ret:Vector.<String> = new Vector.<String>(6,true);
			switch (input.id) {
			case "_f":
				ret[0] = input.base + "_f" + "." + input.extension;
				ret[1] = input.base + "_r" + "." + input.extension;
				ret[2] = input.base + "_b" + "." + input.extension;
				ret[3] = input.base + "_l" + "." + input.extension;
				ret[4] = input.base + "_u" + "." + input.extension;
				ret[5] = input.base + "_d" + "." + input.extension;
				break;
			case "front":
				ret[0] = input.base + "front" + "." + input.extension;
				ret[1] = input.base + "right" + "." + input.extension;
				ret[2] = input.base + "back" + "." + input.extension;
				ret[3] = input.base + "left" + "." + input.extension;
				ret[4] = input.base + "top" + "." + input.extension;
				ret[5] = input.base + "bottom" + "." + input.extension;
				break;
			default:
				throw new Error(getQualifiedClassName(this) +
					": Can't predict face paths from given path" +
					" base:" + input.base +
					" face id:" + input.id +
					" extension:" + input.extension);
			}
			return ret;
		}
		
		override public function toString():String {
			return "[QuadTreeCube] " + url;
		}
	}
}
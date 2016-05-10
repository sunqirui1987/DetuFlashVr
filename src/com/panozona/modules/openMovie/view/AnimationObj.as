package com.panozona.modules.openMovie.view
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;

	public class AnimationObj extends Sprite
	{
		
		private var t:int;
		
		private var loader:Loader;
		
		private var isSelfRender:Boolean;
		
		private var dx:int = 0;
		
		private var dy:int = 0;
		
		private var destroyFun:Function;
		
		private var loadCmpFun:Function;
		
		private var progressFun:Function;
		
		private var url:String;
		
		private var isAutoDestroy:Boolean;
		
		public function AnimationObj(url:String,repeatTime:int=1,progressFun:Function=null,isSelfRender:Boolean=false,dx:int=0,dy:int=0,destroyFun:Function=null,loadCmpFun:Function=null,isAutoDestroy:Boolean=true)
		{
			super();
			
			needReatTimes = repeatTime;
			
			this.isSelfRender = isSelfRender;
			this.isAutoDestroy = isAutoDestroy;
			
			this.dx = dx;
			this.dy = dy;
			
			this.destroyFun = destroyFun;
			this.loadCmpFun = loadCmpFun;
			this.progressFun = progressFun;
			
			this.url = url;
			
			
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onCmp);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,onProgress);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onErr);
			loader.load(new URLRequest(url),new LoaderContext(true));
			
			addRender();
		}
		
		private function onProgress(e:ProgressEvent):void{
			if(progressFun != null)
				progressFun(e);
		}
		
		public function play():void{
			addRender();
		}
		
		public function stop():void{
			removeRender();
		}
		
		private var isAddRender:Boolean;
		
		public function get canPlay():Boolean{
			return !isAddRender;
		}
		
		protected function addRender():void{
			if(isAddRender)
				return;
			addEventListener(Event.ENTER_FRAME,render);
			isAddRender = true;
		}
		
		protected function removeRender():void{
			if(!isAddRender)
				return;
			removeEventListener(Event.ENTER_FRAME,render);
			isAddRender = false;
		}
		
		
		private function onErr(e:IOErrorEvent):void{
			destroy();
		}
		
		protected function reinit():void{
			index = 0;
			repeatTime = 0;
			if(mc)
				mc.gotoAndStop(1);
		}
		
		public function destroy():void{
			if(loader)
				loader.unload();
			if(isSelfRender){
				removeRender();
			}
//			while(bitmapdataArr.length>0){
//				var bit:BitmapData = bitmapdataArr.splice(0,1) as BitmapData;
//				if(bit)
//					bit.dispose();
//			}
			while(this.numChildren>0)
				this.removeChildAt(0);
			if(destroyFun != null){
				destroyFun();
				destroyFun = null;
			}
			if(this.parent)
				this.parent.removeChild(this);
		}
		
		
		private var index:int;
		
		private var mc:MovieClip;
		
		private function onCmp(e:Event):void{
			mc = loader.content as MovieClip;
			//	this.addChild(mc);
			if(mc){
				addChild(mc);
				mc.x = -dx;
				mc.y = -dy;
				mc.gotoAndStop(1);
			//	mc.play();
			//	mc.mouseEnabled = false;
			}
			
			if(loadCmpFun != null){
				loadCmpFun();
				loadCmpFun = null;
			}
		}
		
		private var repeatTime:int=0;
		
		private var needReatTimes:int;
		
		public function render(e:Event=null):void{
			if(!mc)
				return;
			if(mc.currentFrame >= mc.totalFrames){//播放完一次
				if(needReatTimes != -1){
					repeatTime ++;
					if(repeatTime>=needReatTimes){
						mc.gotoAndStop(mc.totalFrames);
						if(isAutoDestroy)
							destroy();
						else
							stop();
						return;
					}
				}
				mc.gotoAndStop(1);
				return;
			}
			mc.gotoAndStop(mc.currentFrame+1);
		}
		
		public function reset():void{
			if(mc)
				mc.gotoAndStop(1);
			index = 0;
			repeatTime = 0;
		}
		
		override public function get width():Number{
			return  mc?mc.loaderInfo.width:super.width;
		}
		
		override public function get height():Number{
			return  mc?mc.loaderInfo.height:super.height;
		}
	}
}
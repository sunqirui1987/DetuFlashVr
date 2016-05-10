package com.panozona.modules.swfobject
{
	import com.panozona.modules.swfobject.data.SwfInfo;
	import com.panozona.modules.swfobject.data.SwfObjectData;
	import com.panozona.player.module.Module;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.data.property.Align;
	import com.panozona.player.module.data.property.Move;
	import com.robertpenner.easing.*;
	
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.text.TextField;
	

	public class SwfObject extends Module
	{
		private var swfobjectData:SwfObjectData;
		
		private var panoramaEventClass:Class;
		
		private var sprite_list:Array;
		
		public function SwfObject()
		{
			super("SwfObject", "1.0", "http://ouwei.cn/wiki/Module:SwfObject");
			
			
		}
		
		override protected function moduleReady(moduleData:ModuleData):void {
			
			sprite_list = new Array();
	
			swfobjectData = new SwfObjectData(moduleData, qjPlayer); // allways read data first 
			
			panoramaEventClass = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.events.PanoramaEvent") as Class;
			
			// add listeners 
		
			qjPlayer.manager.addEventListener(panoramaEventClass.PANORAMA_STARTED_LOADING, onPanoramaStartedLoading, false, 0 , true);
			qjPlayer.manager.addEventListener(panoramaEventClass.PANORAMA_LOADED, onPanoramaLoaded, false, 0 , true);
			qjPlayer.manager.addEventListener(panoramaEventClass.TRANSITION_ENDED, onTransitionEnded, false, 0 , true);
			
			
			for each(var pa:SwfInfo in swfobjectData.settings.getChildrenOfGivenClass(SwfInfo)) 
			{
			
				printInfo("AAA"+pa.align.horizontal+":"+pa.align.vertical);
				var buttonLoader:Loader = new Loader();
				buttonLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, buttonImageLost);
				buttonLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, OuWeiEventDelegate.create(buttonImageLoaded,pa));// function(e:Event):void { buttonImageLoaded(e,pa) });
				buttonLoader.load(new URLRequest(pa.path),new LoaderContext(true));
				
			}
			
			
			
			//	
			var ViewEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panosalado.events.ViewEvent") as Class;
			qjPlayer.manager.addEventListener(ViewEventClass.BOUNDS_CHANGED, handleResize, false, 0, true);
			
			//	
			
		}
		
		public function buttonImageLost(e:IOErrorEvent):void {
			(e.target as LoaderInfo).removeEventListener(IOErrorEvent.IO_ERROR, buttonImageLost);
		
			printError(e.toString());
		}
		
		public function buttonImageLoaded(e:Event,...arg):void {
			(e.target as LoaderInfo).removeEventListener(IOErrorEvent.IO_ERROR, buttonImageLost);
			
			var pa:SwfInfo = arg[0];
			
			var swfsprite:Sprite = new Sprite();
			swfsprite.addChildAt((e.target as LoaderInfo).content, 0);
			
			this.addChild(swfsprite);
		
			var obj:Object=new Object();
			obj.swfsprite =swfsprite;
			obj.pa = pa;	
			sprite_list.push(obj);
			
			swfsprite.x = this.getWindowOpenX(swfsprite,pa);
			swfsprite.y = this.getWindowOpenY(swfsprite,pa);
			
			printInfo(pa.align.horizontal+":"+pa.align.vertical+":"+swfsprite.x+":"+swfsprite.y);
		}
		
		/**
		 * If this is not first panorama, this event is dispatched whenever 
		 * user is leaving to other panorama.
		 */
		private function onPanoramaStartedLoading(e:Event):void {
			//printInfo("Started loading: " + qjPlayer.manager.currentPanoramaData.id);
		}
		
		/**
		 * At this point new panorama is loaded, old panorama is removed
		 * but transition effect (if there is any) has not finished yet.
		 */
		private function onPanoramaLoaded(e:Event):void {
			//	printInfo("Done loading: " + qjPlayer.manager.currentPanoramaData.id);
		}
		
		/**
		 * panorama was loaded, and transition effect has finished 
		 * This can be considered entry point in new panorama.
		 */
		private function onTransitionEnded(e:Event):void {
			//	printInfo("Transition ended: " + qjPlayer.manager.currentPanoramaData.id);
		}
		
		/** 
		 * One shuold use bounds size and not stage.stageHeight and stage.stageWidth
		 * when Saladolayer is embeded into other application, module will remain 
		 * inside panorama window. 
		 */
		private function handleResize(e:Event = null):void {
			
			for(var i:int;i<sprite_list.length;i++)
			{
				var obj:Object =sprite_list[i];
				
				var swfsprite:Sprite = obj.swfsprite;
				var pa:SwfInfo = obj.pa;
				
				swfsprite.x = this.getWindowOpenX(swfsprite,pa);
				swfsprite.y = this.getWindowOpenY(swfsprite,pa);
				
				printInfo(pa.align.horizontal+":"+pa.align.vertical+":"+swfsprite.x+":"+swfsprite.y);
			}
			
		}
		
		private function getWindowOpenX(swfs:Sprite,pa:SwfInfo):Number {
			var result:Number = 0;
			
			switch(pa.align.horizontal) {
				case Align.RIGHT:
					result += qjPlayer.manager.boundsWidth 
					- swfs.width
					+pa.move.horizontal;
					break;
				case Align.LEFT:
					result += pa.move.horizontal;
					break;
				default: // CENTER
					result += (qjPlayer.manager.boundsWidth 
						- swfs.width) * 0.5 
					+ pa.move.horizontal;
			}
			return result;
		}
		
		private function getWindowOpenY(swfs:Sprite,pa:SwfInfo):Number{
			var result:Number = 0;
		
			switch(pa.align.vertical) {
				case Align.TOP:
					result +=pa.move.vertical;
					break;
				case Align.BOTTOM:
					result += qjPlayer.manager.boundsHeight 
					- swfs.height
					+ pa.move.vertical;
					break;
				default: // MIDDLE
					result += (qjPlayer.manager.boundsHeight 
						- swfs.height) * 0.5
					+ pa.move.vertical;
			}
			return result;
		}
		
	
	}
}
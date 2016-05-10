package com.panozona.modules.swfload
{
	
	import caurina.transitions.Tweener;
	
	import com.panozona.modules.examplemodule.data.*;
	import com.panozona.modules.swfload.data.SwfLoadData;
	import com.panozona.player.module.Module;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.data.property.Align;
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
	
	
	public class SwfLoad extends Module{
		
		private var window:Sprite;
		private var btnClose:Sprite;
		private var swfSprite:Sprite;
		private var bgSprite:Sprite;
		private var loaderInfo_arr:Array = new Array();
		private var path_arr:Array=new Array();
		private var buttonLoader:Loader=null;
		
		private var panoramaEventClass:Class;
		
		private var swfLoadData:SwfLoadData;
		
		[Embed(source="assert/close.png")]
		private static var Bitmap_close:Class;
		
		
		public function SwfLoad() {
			super("SwfLoad", "1.0", "http://ouwei.cn/wiki/Module:SwfLoad");
			
			moduleDescription.addFunctionDescription("toggleOpen");
			moduleDescription.addFunctionDescription("setOpen", Boolean);
			moduleDescription.addFunctionDescription("loadswf",String,Number,Number,Number,Number);
		

		}
		
		/**
		 * Entry point - module is added to stage qjPlayer reference is set. 
		 * moduleReady is surrounded with try/cacth in case of any error here, 
		 * module will be removed. ModuleData object contains DataNode tree 
		 * with module configuration obtained by QjPlayer. 
		 * 
		 * @param	moduleData
		 */
		override protected function moduleReady(moduleData:ModuleData):void {
			
			swfLoadData = new SwfLoadData(moduleData, qjPlayer); // allways read data first 
			
			panoramaEventClass = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.events.PanoramaEvent") as Class;
			
			// add listeners 
			qjPlayer.manager.addEventListener(panoramaEventClass.PANORAMA_STARTED_LOADING, onFirstPanoramaStartedLoading, false, 0 , true);
			qjPlayer.manager.addEventListener(panoramaEventClass.PANORAMA_STARTED_LOADING, onPanoramaStartedLoading, false, 0 , true);
			qjPlayer.manager.addEventListener(panoramaEventClass.PANORAMA_LOADED, onPanoramaLoaded, false, 0 , true);
			qjPlayer.manager.addEventListener(panoramaEventClass.TRANSITION_ENDED, onTransitionEnded, false, 0 , true);
			
			
			
			buildModule();
	
			
		//	
			var ViewEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panosalado.events.ViewEvent") as Class;
			qjPlayer.manager.addEventListener(ViewEventClass.BOUNDS_CHANGED, handleResize, false, 0, true);
			
		//	
	
		}
		
		private function buildModule():void {
			
			bgSprite  = new Sprite();
			
			
			swfSprite = new Sprite();
			swfSprite.buttonMode = true;
		
			btnClose = new Sprite();
			btnClose.addChild(new Bitmap(new Bitmap_close().bitmapData, "auto", true));
			btnClose.buttonMode = true;
			btnClose.addEventListener(MouseEvent.CLICK, btnCloseClick, false, 0 , true);
            
		   
			
			window = new Sprite();
			window.addChild(swfSprite);
			window.addChild(btnClose);
			window.addChildAt(bgSprite,0);
			addChild(window);
			
			handleResize();

			

		
			var url:String =swfLoadData.settings.path;
			buttonLoader = new Loader();
			buttonLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,buttonImageLost);
			buttonLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,  buttonImageLoaded);
			buttonLoader.load(new URLRequest(url));
			
			
	
		}
		
		
		public function buttonImageLost(e:IOErrorEvent):void {
			(e.target as LoaderInfo).removeEventListener(IOErrorEvent.IO_ERROR, buttonImageLost);
			(e.target as LoaderInfo).removeEventListener(Event.COMPLETE, buttonImageLoaded);
			
		}
		
		public function buttonImageLoaded(e:Event):void {
			
			(e.target as LoaderInfo).removeEventListener(IOErrorEvent.IO_ERROR, buttonImageLost);
			(e.target as LoaderInfo).removeEventListener(Event.COMPLETE, buttonImageLoaded);
	
			
			if(swfSprite.numChildren > 0)
			{
				swfSprite.removeChildAt(0);
			}
			swfSprite.scaleX = swfLoadData.settings.swfscalex;
			swfSprite.scaleY = swfLoadData.settings.swfscaley;
	
		//	btnClose.y = 1;
		//	btnClose.x = (e.target as LoaderInfo).width - btnClose.width - 1;
			
			var scale:Number = Math.min(
				swfLoadData.settings.swfwidth/(e.target as LoaderInfo).content.width,
				swfLoadData.settings.swfheight/(e.target as LoaderInfo).content.height);
			
			(e.target as LoaderInfo).content.scaleX = (e.target as LoaderInfo).content.scaleY = scale;
			
			swfSprite.addChildAt((e.target as LoaderInfo).content, 0);
			

		}
		
		
		private function btnCloseClick(e:Event):void {
			//toggleOpen();
			this.alpha = 0;
			this.visible = false;
			
			if(buttonLoader != null)
			{
				buttonLoader.unloadAndStop(true);
			}
			
		}
		
		/**
		 * First panorama started loading, so all modules are loaded and added to stage
		 * now you can call other modules either directly or by executing proper actions
		 * each module must be ready to execute exposed functions after first panorama started loading;
		 */
		private function onFirstPanoramaStartedLoading(e:Event):void {
			qjPlayer.manager.removeEventListener(panoramaEventClass.PANORAMA_STARTED_LOADING, onFirstPanoramaStartedLoading);
			if (!swfLoadData.settings.open) {
				this.alpha = 0;
				this.visible = false;
				
			}
			if (swfLoadData.settings.open) {
				qjPlayer.manager.runAction(swfLoadData.settings.onOpen);
			}else {
				qjPlayer.manager.runAction(swfLoadData.settings.onClose);
			}
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
		
	
		private function handleResize(e:Event = null):void {

			bgSprite.graphics.clear();
			var g:Graphics= bgSprite.graphics
			g.beginFill(0x000000,swfLoadData.settings.alpha)
			g.drawRect(0, 0, qjPlayer.manager.boundsWidth, qjPlayer.manager.boundsHeight)
			g.endFill()
			bgSprite.x=0;
			bgSprite.y=0;
		
			
			
			swfSprite.x = (qjPlayer.manager.boundsWidth - swfLoadData.settings.swfwidth) * 0.5;
			swfSprite.y = (qjPlayer.manager.boundsHeight - swfLoadData.settings.swfheight) * 0.5;
			
			swfSprite.x += swfLoadData.settings.move.horizontal;
			swfSprite.y += swfLoadData.settings.move.vertical;
			
			btnClose.x = swfSprite.x - btnClose.width/2;
			btnClose.y = swfSprite.y - btnClose.height/2;
			
			printInfo("Transition ended: " +btnClose.x+","+btnClose.y+","+btnClose.width+"."+btnClose.height);
		}
		
		
		
		private function onClosingFinish():void {
			this.visible = false;
			qjPlayer.manager.runAction(swfLoadData.settings.onClose);
		}
		
		///////////////////////////////////////////////////////////////////////////////
		//  Exposed functions 
		///////////////////////////////////////////////////////////////////////////////
		
		public function toggleOpen():void {
			if (swfLoadData.settings.open) {
				swfLoadData.settings.open = false;
				Tweener.addTween(this, {alpha:0, transition:swfLoadData.settings.tween.transition, time:swfLoadData.settings.tween.time, onComplete:onClosingFinish});
			}else {
				swfLoadData.settings.open = true;
				this.visible = true;
				Tweener.addTween(this, { alpha:1, transition:swfLoadData.settings.tween.transition, time:swfLoadData.settings.tween.time } );
				
				qjPlayer.manager.runAction(swfLoadData.settings.onOpen);
			}
		}
		
		public function setOpen(value:Boolean):void {
			if (swfLoadData.settings.open != value) {
				toggleOpen();
			}
		}
		public function loadswf(path:String,w:Number,h:Number,sx:Number,sy:Number):void {

		//	printInfo("swfLoadData.settings.index"+swfLoadData.settings.index+":index"+index);

			if(swfLoadData.settings.path != path)
			{
				if(window != null)
				{
					this.removeChild(window);
				}
				swfLoadData.settings.path = path;
				if(w < 1 )
				{
					swfLoadData.settings.swfwidth = int(qjPlayer.manager.boundsWidth * w);
				}
				else
				{
					swfLoadData.settings.swfwidth = w;
				}
				
				if(h < 1 )
				{
					swfLoadData.settings.swfheight = int(qjPlayer.manager.boundsHeight *  h);
				}
				else
				{
					swfLoadData.settings.swfheight =  h;
				}
				
				swfLoadData.settings.swfscalex = sx;
				swfLoadData.settings.swfscaley = sy;
				
				this.alpha = 1;
				this.visible = true;
				buildModule();
			}
			else
			{
				//toggleOpen();
				this.visible = true;
				Tweener.addTween(this, { alpha:1, transition:swfLoadData.settings.tween.transition, time:swfLoadData.settings.tween.time } );
				
			}
		}

	}

}
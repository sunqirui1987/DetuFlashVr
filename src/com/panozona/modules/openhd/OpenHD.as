package com.panozona.modules.openhd
{
	import com.panozona.modules.openhd.data.OpenHDData;
	import com.panozona.modules.openhd.data.StyleContent;
	import com.panozona.modules.swfload.data.SwfLoadData;
	import com.panozona.player.module.Module;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.data.property.Align;
	
	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import caurina.transitions.Tweener;
	
	public class OpenHD extends Module{
		 
		
		private var bgSprite:Sprite = new Sprite();
		private var btnClose:Sprite = new Sprite();
		private var textSprite:Sprite = new Sprite();
		private var swfSprite:Sprite = new Sprite();
		private var titleSprite:Sprite = new Sprite();
		private var detailSprite:Sprite = new Sprite();
		private var shusprite:Sprite=new Sprite();
		
		private var loaderInfo_arr:Array = new Array();
		private var path_arr:Array=new Array();
		private var buttonLoader:Loader= new Loader();
		
		private var panoramaEventClass:Class;
		
		private var textField:TextField = new TextField();
		private var textFormat:TextFormat = new TextFormat();
		
		private var d_textField:TextField = new TextField();
		private var d_textFormat:TextFormat = new TextFormat();
		
		
		private var openHDData:OpenHDData;
		
		[Embed(source="assert/close.png")]
		private static var Bitmap_close:Class;
		
		
		private var str_title:String="";
		private var str_detail:String="";
		
		public function  OpenHD() {
			super("OpenHD", "1.0", "http://ouwei.cn/wiki/Module:OpenHD");
			
			moduleDescription.addFunctionDescription("toggleOpen");
			moduleDescription.addFunctionDescription("setOpen", Boolean);
			moduleDescription.addFunctionDescription("loadswf",String);
			moduleDescription.addFunctionDescription("loadswf_t_d",String,String,String);
			
	    	
			
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
			
			openHDData = new OpenHDData(moduleData, qjPlayer); // allways read data first 

			panoramaEventClass = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.events.PanoramaEvent") as Class;
			
			// add listeners 
			qjPlayer.manager.addEventListener(panoramaEventClass.PANORAMA_STARTED_LOADING, onFirstPanoramaStartedLoading, false, 0 , true);
			qjPlayer.manager.addEventListener(panoramaEventClass.PANORAMA_STARTED_LOADING, onPanoramaStartedLoading, false, 0 , true);
			qjPlayer.manager.addEventListener(panoramaEventClass.PANORAMA_LOADED, onPanoramaLoaded, false, 0 , true);
			qjPlayer.manager.addEventListener(panoramaEventClass.TRANSITION_ENDED, onTransitionEnded, false, 0 , true);
			
			onFirstPanoramaStartedLoading(null);
			
			textField.defaultTextFormat = textFormat;
			textField.multiline = true;
			textField.selectable = false;
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.blendMode = BlendMode.LAYER;
			textField.background = false;
			textField.mouseEnabled = false;
			textField.antiAliasType = AntiAliasType.ADVANCED;
			
			d_textField.defaultTextFormat = textFormat;
			d_textField.multiline = true;
			d_textField.selectable = false;
			d_textField.autoSize = TextFieldAutoSize.LEFT;
			d_textField.blendMode = BlendMode.LAYER;
			d_textField.background = false;
			d_textField.antiAliasType = AntiAliasType.ADVANCED;
			d_textField.mouseEnabled = false;
			
			
			buildModule();
			
			
			//	
			var ViewEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panosalado.events.ViewEvent") as Class;
			qjPlayer.manager.addEventListener(ViewEventClass.BOUNDS_CHANGED, handleResize, false, 0, true);
			
			//	
			
			this.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
			

			
		}
		
		
		
		private function buildModule():void {
			
		
			btnClose.addChild(new Bitmap(new Bitmap_close().bitmapData, "auto", true));
			btnClose.buttonMode = true;
			btnClose.addEventListener(MouseEvent.CLICK, btnCloseClick, false, 0 , true);
			
		
			
			bgSprite.addChild(textSprite);
			bgSprite.addChild(swfSprite);
			bgSprite.addChild(btnClose);
			bgSprite.addChild(shusprite);
			
			addChild(bgSprite);
			
			

			textSprite.addChild(titleSprite);
			textSprite.addChild(detailSprite);
			
		
			handleResize();
			
			
			loadtitle();
			loaddetail();
			
		}
		
		private function loadtitle():void
		{
			if(openHDData.settings.title != "")
			{
				var lo:URLLoader=new URLLoader();
				lo.addEventListener(Event.COMPLETE,titleCompleteHandler);
				lo.load(new URLRequest(openHDData.settings.title));
			}
			
		}
		
		private function loaddetail():void
		{
			if(openHDData.settings.detail != "")
			{
				var lo2:URLLoader=new URLLoader();
				lo2.addEventListener(Event.COMPLETE,detailCompleteHandler);
				lo2.load(new URLRequest(openHDData.settings.detail));
			}
		}
		
		private function titleCompleteHandler(e:Event):void
		{
			str_title = e.target.data;

			createtitle();
		}
		
		private function detailCompleteHandler(e:Event):void
		{
			str_detail = e.target.data;

			createdetail()
		}
		
		private function createbgsprite():void
		{
			
			var g:Graphics= bgSprite.graphics
			bgSprite.graphics.clear()
			g.beginFill(0x000000,openHDData.settings.alpha)
			g.drawRect(0, 0, qjPlayer.manager.boundsWidth, qjPlayer.manager.boundsHeight)
			g.endFill();
			
			
			g=shusprite.graphics;
			g.clear();
			g.lineStyle(1,openHDData.settings.shucolor,openHDData.settings.shualpha);
			g.moveTo(openHDData.settings.leftwidth - 1 ,0);
			g.lineTo(openHDData.settings.leftwidth - 1, qjPlayer.manager.boundsHeight);
			g.endFill();
			

			

		
			
		}
		
		private function createtextsprite():void
		{
			var g:Graphics = textSprite.graphics;
			textSprite.graphics.clear();
			g.beginFill(0x000000,0)
			g.drawRect(0, 0, openHDData.settings.leftwidth, qjPlayer.manager.boundsHeight)
			g.endFill();

		}
		private function createswfsprite():void
		{
		
			var swfw:Number = qjPlayer.manager.boundsWidth - openHDData.settings.leftwidth - 10;
			var swfh:Number =  qjPlayer.manager.boundsHeight - 10;
			var g:Graphics =swfSprite.graphics;
			swfSprite.graphics.clear();
			g.beginFill(0x000000,0)
			
			g.drawRect(0, 0,swfw , swfh)
			g.endFill();
			
			swfSprite.x = openHDData.settings.leftwidth + 5;
			swfSprite.y = 5;
			
			buttonLoader.x =0;
			buttonLoader.y =0;

			
			
		}
		
		private var old_swf_w:Number = 0;
		private var old_swf_h:Number = 0;
		
		private function onEnterFrame(e:Event = null):void 
		{
			if(openHDData.settings.open == true)
			{
				
				if(openHDData.settings.path != "")
				{
					var swfw:Number = qjPlayer.manager.boundsWidth - openHDData.settings.leftwidth - 10;
					var swfh:Number =  qjPlayer.manager.boundsHeight - 10;
					
					if(buttonLoader.numChildren > 0)
					{
						var sp1:Sprite = buttonLoader.getChildAt(0) as Sprite;
						if(sp1 != null)
						{
							if(sp1.numChildren > 0)
							{
								var sp2:Sprite = sp1.getChildAt(0) as Sprite;
								if(sp2 != null)
								{
									if(swfw != old_swf_w || swfh != old_swf_h)
									{
										sp2.width = swfw;
										sp2.height = swfh;
										
										old_swf_w = swfw;
										old_swf_h = swfh;
									}
									
									
								}
								
							}
							
						}
					}
				}
			}
			
		}
		
		private function createbgclose():void
		{
			btnClose.x= qjPlayer.manager.boundsWidth - 35;
			btnClose.y=0;
		}
		
		private function createtitle():void
		{
			
			if(titleSprite.numChildren > 0)
			{
				titleSprite.removeChildAt(0);
			}
			
			var styleContent:StyleContent= openHDData.settings.titlestyle;
			
			textFormat.font = styleContent.fontFamily;
			textFormat.size = styleContent.fontSize;
			textFormat.color = styleContent.fontColor;
			textFormat.bold = styleContent.fontBold;
			textField.defaultTextFormat = textFormat;
			textField.x = styleContent.bubblePadding;
			textField.y = styleContent.bubblePadding;
			
			textField.text = str_title;
			
			textField.wordWrap=true;
			textField.multiline=false;
			textField.width = openHDData.settings.leftwidth - openHDData.settings.t_x  - 10;
			textField.height =  openHDData.settings.d_y - 10;
			
		
			titleSprite.alpha=styleContent.alpha;
			
			
			titleSprite.blendMode = BlendMode.LAYER;
			titleSprite.addChild(textField);
			
			titleSprite.x= openHDData.settings.t_x;
			titleSprite.y= openHDData.settings.t_y;
			
	
		
		}
		
		private function createdetail():void
		{
			if(detailSprite.numChildren > 0)
			{
				detailSprite.removeChildAt(0);
			}
			
		
			
			var styleContent:StyleContent= openHDData.settings.detailstyle;
			d_textFormat.leading = 10;
			d_textFormat.letterSpacing=2;
			d_textFormat.font = styleContent.fontFamily;
			d_textFormat.size = styleContent.fontSize;
			d_textFormat.color = styleContent.fontColor;
			d_textFormat.bold = styleContent.fontBold;
			d_textField.defaultTextFormat = d_textFormat;
			d_textField.x = styleContent.bubblePadding;
			d_textField.y = styleContent.bubblePadding;
			d_textField.wordWrap=true;
			d_textField.multiline=true;
			d_textField.width = openHDData.settings.leftwidth - openHDData.settings.d_x - openHDData.settings.d_x - 10;
			d_textField.height = qjPlayer.manager.boundsHeight -  openHDData.settings.d_y;
			
	
			//d_textField.wordWrap = true;
			d_textField.text = "";
			
			var array:Array = str_detail.split("[n]");
			for (var i:int = 0; i < array.length; i++) {
				d_textField.appendText(array[i]);
				if (i < array.length - 1) {
					d_textField.appendText("\n");
				}
			}
			
			detailSprite.alpha=styleContent.alpha;
			
			
			detailSprite.blendMode = BlendMode.LAYER;
			detailSprite.addChild(d_textField);
			
			detailSprite.x= openHDData.settings.d_x;
			detailSprite.y= openHDData.settings.d_y;
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
		
			swfSprite.addChild(buttonLoader);
			
			qjPlayer.stage.dispatchEvent(new Event(Event.RESIZE));
			buttonLoader.stage.dispatchEvent(new Event(Event.RESIZE));
			
			onEnterFrame();
			
	
			
		}
		
		
		private function btnCloseClick(e:Event):void {
			openHDData.settings.open=false;
			var num:Number = this.width;
			Tweener.addTween(this, {x:-num,alpha:0, transition:openHDData.settings.tween.transition, time:openHDData.settings.tween.time, onComplete:onClosingFinish});
		}
		
		/**
		 * First panorama started loading, so all modules are loaded and added to stage
		 * now you can call other modules either directly or by executing proper actions
		 * each module must be ready to execute exposed functions after first panorama started loading;
		 */
		private function onFirstPanoramaStartedLoading(e:Event):void {
			qjPlayer.manager.removeEventListener(panoramaEventClass.PANORAMA_STARTED_LOADING, onFirstPanoramaStartedLoading);
			if (!openHDData.settings.open) {
				this.alpha = 0;
				this.visible = false;
				
			}
			if (openHDData.settings.open) {
				qjPlayer.manager.runAction(openHDData.settings.onOpen);
			}else {
				qjPlayer.manager.runAction(openHDData.settings.onClose);
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
			setOpen(false);//先隐藏
		}
		
		/**
		 * panorama was loaded, and transition effect has finished 
		 * This can be considered entry point in new panorama.
		 */
		private function onTransitionEnded(e:Event):void {
			//	printInfo("Transition ended: " + qjPlayer.manager.currentPanoramaData.id);
		}
		
		
		private function handleResize(e:Event = null):void {
			
			createbgsprite();
			createtextsprite();
			createswfsprite();
			createbgclose();
			createtitle();
			createdetail();
			
		
		}
		
		
		
		private function onClosingFinish():void {
		
			this.visible=false;
		}
		
		///////////////////////////////////////////////////////////////////////////////
		//  Exposed functions 
		///////////////////////////////////////////////////////////////////////////////
		
		public function toggleOpen():void {
			var num:Number = this.width;
			if (openHDData.settings.open) {
				openHDData.settings.open = false;
				this.x = 0;
				trace(num+":num");
				Tweener.addTween(this, {x:-num,alpha:0, transition:openHDData.settings.tween.transition, time:openHDData.settings.tween.time, onComplete:onClosingFinish});
			}else {
				openHDData.settings.open = true;
				this.visible = true;
				this.x = -num;
				Tweener.addTween(this, { alpha:1,x:0, transition:openHDData.settings.tween.transition, time:openHDData.settings.tween.time } );
				
				qjPlayer.manager.runAction(openHDData.settings.onOpen);
			}
		}
		
		public function setOpen(value:Boolean):void {
			if (openHDData.settings.open != value) {
				toggleOpen();
			}
		}
		public function loadswf(path:String):void {
			var url:String = path;

			if(openHDData.settings.path != url)
			{
				old_swf_w = 0;
				old_swf_h = 0;
				buttonLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,buttonImageLost);
				buttonLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,  buttonImageLoaded);
				buttonLoader.load(new URLRequest(url),new LoaderContext(true));
				openHDData.settings.path=url;
			}
		}
		
		public function loadswf_t_d(path:String,n1:String,n2:String):void
		{
			var url:String = path;
			if(openHDData.settings.path != url)
			{
				old_swf_w = 0;
				old_swf_h = 0;
				buttonLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,buttonImageLost);
				buttonLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,  buttonImageLoaded);
				buttonLoader.load(new URLRequest(url),new LoaderContext(true));
				openHDData.settings.path=url;
			}
			
			openHDData.settings.title = n1;
			openHDData.settings.detail=n2;
			
			loadtitle();
			loaddetail();
		}
		
	}
}
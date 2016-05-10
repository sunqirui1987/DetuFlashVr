package com.panozona.modules.ouweijt
{
	import com.adobe.images.JPGEncoder;
	import com.panozona.modules.ouweijt.data.OuweiJtData;
	import com.panozona.modules.ouweijt.lib.UploadPostHelper;
	import com.panozona.modules.ouweijt.view.RadioButton;
	import com.panozona.player.module.Module;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.data.property.Align;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.TextEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.system.ApplicationDomain;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	import caurina.transitions.Tweener;
	 
	public class OuweiJt extends Module{
		
		

		private var windowsprite:Sprite;
		private var dragsprite:Sprite;
		
		private var button:Sprite;
		private var btntext:TextField;
	    private var winputtext:TextField;
		private var hinputtext:TextField;
		private var panoramaEventClass:Class;
		private var isdianpu:Boolean=false;
		
		private var tipSprite:Sprite;
		private var tipSpriteTextfiled:TextField;
		
		private var isopen:Boolean=false;
		private var aesinfo:String="";
		
		private var curpan:String="";
		private var curtilt:String="";
		
		
		private var ouweijtdata:OuweiJtData;
		public function  OuweiJt() {
			super("OuweiJt", "1.0", "http://ouwei.cn/wiki/Module:OuweiJt");
			moduleDescription.addFunctionDescription("setOpen", Boolean);
			moduleDescription.addFunctionDescription("toggleOpen");
			
			
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
			
	
			ouweijtdata=new OuweiJtData(moduleData,qjPlayer); // allways read data first 
			
			panoramaEventClass = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.events.PanoramaEvent") as Class;
			// add listeners 
			qjPlayer.manager.addEventListener(panoramaEventClass.PANORAMA_STARTED_LOADING, onFirstPanoramaStartedLoading, false, 0 , true);
			qjPlayer.manager.addEventListener(panoramaEventClass.PANORAMA_STARTED_LOADING, onPanoramaStartedLoading, false, 0 , true);
			qjPlayer.manager.addEventListener(panoramaEventClass.PANORAMA_LOADED, onPanoramaLoaded, false, 0 , true);
			qjPlayer.manager.addEventListener(panoramaEventClass.TRANSITION_ENDED, onTransitionEnded, false, 0 , true);
			
		
			
			var ViewEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panosalado.events.ViewEvent") as Class;
			qjPlayer.manager.addEventListener(ViewEventClass.BOUNDS_CHANGED, handleResize, false, 0, true);
			
			//	
			
			windowsprite = new Sprite();
			dragsprite   = new Sprite();
			tipSprite    = new Sprite();
			
			this.addChild(windowsprite);
			this.addChild(dragsprite);
			this.addChild(tipSprite);
			
		
		
			var g:Graphics=windowsprite.graphics;
			g.beginFill(0x000000,0.6);
			g.drawRoundRect(0,0,180,120,10,10);
			g.endFill();
			
			
			setOpen(false);
			
		
	
			
			
			this.dragsprite.addEventListener(MouseEvent.MOUSE_DOWN,dragDownHandler);
			this.dragsprite.addEventListener(MouseEvent.MOUSE_UP,dragUpHandler);
			
			
			addControlPanel();
			DrawDragPanel();
			
			handleResize();
			
			
		
		}
		
		private function getParams():Object {  
			var params:Object = {};  
			var query:String = ExternalInterface.call("window.location.search.substring", 1);  
			
			if(query) {  
				var pairs:Array = query.split("&");  
				for(var i:uint=0; i < pairs.length; i++) {  
					var pos:int = pairs[i].indexOf("=");  
					//Alert.show(String(pos));  
					if(pos != -1) {  
						var argname:String = pairs[i].substring(0, pos);  
						var value:String = pairs[i].substring(pos+1);  
						
						params[argname] = value;  
					}  
				}  
			}  
			return params;  
		}  
		
	
	
		private function radiobtnHandler(e:MouseEvent):void
		{
		    winputtext.text="150";
			hinputtext.text="150";
			this.isdianpu=false;
			textInputHandler(null);
		}
		
		private function radiobtnHandler2(e:MouseEvent):void
		{
			winputtext.text="800";
			hinputtext.text="600";
			this.isdianpu=true;
			textInputHandler(null);
			
		}
		
		private function addControlPanel():void
		{
			var args:Object = getParams();  
			if(args.isdianpu != null) {  
				this.isdianpu=false;
				ouweijtdata.settings.isdianpu=true;
				this.isdianpu=true;
			}  

			var iscp:Boolean=true;
			var isdp:Boolean=false;
			
			if(ouweijtdata.settings.isdianpu == true)
			{
				iscp=false;
				isdp=true;
				this.isdianpu=true;
				ouweijtdata.settings.defaultWidth = 800;
				ouweijtdata.settings.defaultHeight = 600;
			}
	
			var format:TextFormat=new TextFormat();
			format.bold=true;
			format.align=TextFormatAlign.CENTER;
			format.color=0xffffff;
			
			
			new RadioButton(windowsprite,20,8,"产品",iscp,radiobtnHandler);
			var rwtext:TextField=new TextField();
			rwtext.text="产品";
			rwtext.width=60;
			rwtext.height=20;
			rwtext.x = 22;
			rwtext.y = 3;
			rwtext.mouseEnabled=false;
			rwtext.setTextFormat(format);
			
			windowsprite.addChild(rwtext);

			new RadioButton(windowsprite,75,8,"商铺",isdp,radiobtnHandler2);
			var rwtext2:TextField=new TextField();
			rwtext2.text="商铺";
			rwtext2.width=60;
			rwtext2.height=20;
			rwtext2.x = 78;
			rwtext2.y = 3;
			rwtext2.mouseEnabled=false;
			rwtext2.setTextFormat(format);
			
			windowsprite.addChild(rwtext2);
		
			
			
			var wtext:TextField=new TextField();
			wtext.text="宽：";
			wtext.width=60;
			wtext.height=20;
			wtext.x = 0;
			wtext.y = 25;
			wtext.setTextFormat(format);
			
			windowsprite.addChild(wtext);
			
			winputtext=new TextField();
			winputtext.border=true;
			winputtext.type=TextFieldType.INPUT;
			winputtext.background=true;
			winputtext.width=100;
			winputtext.height=20;
			winputtext.x = 51;
			winputtext.y = 25;
			winputtext.addEventListener(KeyboardEvent.KEY_UP,textInputHandler);
			winputtext.addEventListener(FocusEvent.FOCUS_OUT,textInputHandler);
			winputtext.text=ouweijtdata.settings.defaultWidth.toString();
			windowsprite.addChild(winputtext);
			
			
			var htext:TextField=new TextField();
			htext.text="高：";
			htext.width=60;
			htext.height=20;
			htext.x = 0;
			htext.y = 53;
			htext.setTextFormat(format);
			
			windowsprite.addChild(htext);
			
			hinputtext=new TextField();
			hinputtext.border=true;
			hinputtext.type=TextFieldType.INPUT;
			hinputtext.background=true;
			hinputtext.width=100;
			hinputtext.height=20;
			hinputtext.x = 51;
			hinputtext.y = 53;
			hinputtext.addEventListener(KeyboardEvent.KEY_UP,textInputHandler);
			hinputtext.addEventListener(FocusEvent.FOCUS_OUT,textInputHandler);
			hinputtext.text = ouweijtdata.settings.defaultHeight.toString();
			windowsprite.addChild(hinputtext);
			
			
			
			
		
			
			button=new Sprite();
			button.graphics.beginFill(0xcccccc,1);
			button.graphics.drawRect(0,0,100,25);
			button.graphics.endFill();
			button.x=35;
			button.y=82;
			button.buttonMode=true;
			button.useHandCursor=true;
			
			var dr:DropShadowFilter=new DropShadowFilter();
			button.filters=[dr];
			
			setButtonText("确定");
			
			button.addEventListener(MouseEvent.MOUSE_OVER,function(e:Event):void{
				button.graphics.clear();
				button.graphics.beginFill(0xccccff,1);
				button.graphics.drawRect(0,0,100,25);
				button.graphics.endFill();
			});
			button.addEventListener(MouseEvent.MOUSE_OUT,function(e:Event):void{
				button.graphics.clear();
				button.graphics.beginFill(0xcccccc,1);
				button.graphics.drawRect(0,0,100,25);
				button.graphics.endFill();
			});
			button.addEventListener(MouseEvent.CLICK,uploadclickHandler);
			
			windowsprite.addChild(button);
			
			
			
		}
		
		public function setTiptool(istimer:Boolean=false,text:String="处理中"):void
		{
			
			var format1:TextFormat=new TextFormat();
			format1.bold=true;
			format1.align=TextFormatAlign.CENTER;
			format1.color=0xffffff;
			format1.size=16;
			
			tipSpriteTextfiled  = new TextField();
			tipSpriteTextfiled.text=text;
			tipSpriteTextfiled.x = 110;
			tipSpriteTextfiled.y = 30;
			tipSpriteTextfiled.setTextFormat(format1);
			tipSprite.visible=true;
			
			if(tipSprite.numChildren > 0)
			{
				tipSprite.removeChildAt(0);
			}
			tipSprite.visible=true;
			tipSprite.addChild(tipSpriteTextfiled);
			
			tipSprite.x   = (qjPlayer.manager.boundsWidth - 320)/2;
			tipSprite.y   = (qjPlayer.manager.boundsHeight-80)/2;
			
			var g:Graphics=tipSprite.graphics;
			g.clear();
			g.lineStyle(2,0xFFFFFF);
			g.beginFill(0x000000,0.9);
			g.drawRoundRect(0,0,320,80,10,10);
			g.endFill();
			
			if(istimer==true)
			{
				var time:Timer=new Timer(3000,1);
				time.addEventListener(TimerEvent.TIMER_COMPLETE,function(e:Event):void{
					tipSprite.visible=false;
				});
				time.start();
			}
		}
		
		public function setButtonText(text:String):void
		{
			var format:TextFormat=new TextFormat();
			format.bold=true;
			format.align=TextFormatAlign.CENTER;
			format.color=0xffffff;
			
			if(button.numChildren > 0)
			{
				button.removeChildAt(0);
			}
			btntext=new TextField();
			btntext.text=text;
			btntext.width=80;
			btntext.height=20;
			btntext.x = 10;
			btntext.y = 3;
			btntext.mouseEnabled=false;
			btntext.setTextFormat(format);
			btntext.selectable=false;
			button.addChild(btntext);
		}
		
		private function textInputHandler(e:Event):void
		{
		
		
			this.DrawDragPanel(dragsprite.x,dragsprite.y);
		}
		
		
		private function DrawDragPanel(x:Number=0,y:Number=0):void
		{
		
			
			var w:Number = parseInt(winputtext.text.toString(),10);
			var h:Number = parseInt(hinputtext.text.toString(),10); 
		
		
			dragsprite.x = x;
			dragsprite.y = y;
			
			this.dragsprite.buttonMode=true;
			this.dragsprite.useHandCursor=true;
			
			var g:Graphics =dragsprite.graphics;
			g.clear();

			g.lineStyle(2, 0xFFFFFF);
			g.beginFill(0x000000, 0.6);
			g.drawRect(0, 0, w, h);
			g.endFill();	
			g.endFill();
			
			
			
			
		
		}
		
		private var __toDegrees:Number = 180 / Math.PI;
		private var __toRadians:Number = Math.PI / 180;
		private function getCursorPan(mx:Number):Number {
			return validatePanTilt(qjPlayer.manager._pan +
				Math.atan((mx -qjPlayer.manager.boundsWidth * 0.5)
					* Math.tan(qjPlayer.manager.fieldOfView * 0.5 * __toRadians) / (qjPlayer.manager.boundsWidth * 0.5)) * __toDegrees);
		}
		
		private var verticalFieldOfView:Number
		private function getCursorTilt(my:Number):Number {
			verticalFieldOfView = __toDegrees * 2 * Math.atan((qjPlayer.manager.boundsHeight / qjPlayer.manager.boundsWidth)
				* Math.tan(__toRadians * 0.5 * qjPlayer.manager.fieldOfView));
			return validatePanTilt( qjPlayer.manager._tilt -
				Math.atan((my -qjPlayer.manager.boundsHeight * 0.5)
					* Math.tan(verticalFieldOfView * 0.5 * __toRadians) / (qjPlayer.manager.boundsHeight * 0.5)) * __toDegrees);
		}
		private function validatePanTilt(value:Number):Number {
			if (value <= -180) value = (((value + 180) % 360) + 180);
			if (value > 180) value = (((value + 180) % 360) - 180);
			return value;
		}
		
		
		
		private function dragDownHandler(e:MouseEvent):void
		{
	
			
			this.dragsprite.startDrag();
		}
		
		private function dragUpHandler(e:MouseEvent):void
		{
			this.dragsprite.stopDrag();
		}
		
		
		
		private function uploadclickHandler(e:MouseEvent):void
		{
			var info:String= this.ouweijtdata.settings.defaultlocalinfo;	
			
			var x:Number = dragsprite.x;
			var y:Number = dragsprite.y;
			
			//printInfo(x+":"+y);
			
			var w:Number = parseInt(winputtext.text.toString(),10);
			var h:Number = parseInt(hinputtext.text.toString(),10); 
			var m:Sprite = qjPlayer.manager as Sprite;
			
			
			var rect:Rectangle=new Rectangle();
			rect.x=x;
			rect.y=y;
			rect.width=w;
			rect.height=h;
			
			var jpgSource:BitmapData = new BitmapData(m.width,m.height);
			jpgSource.draw(m,null,null,null,rect,true);
			
			var jp2:BitmapData= new BitmapData(w,h);
			jp2.copyPixels(jpgSource,rect,new Point(0,0));
			
			
			var jpgEncoder:JPGEncoder = new JPGEncoder(80);
			var jpgStream:ByteArray = jpgEncoder.encode(jp2);
			
			var currentDate:Date = new Date();
			
			
			
			
			var jpgURLRequest:URLRequest = new URLRequest (ouweijtdata.settings.defaultRemoteUrl+"guid="+Math.random()); //此web url请自行修改 
			jpgURLRequest.contentType = 'multipart/form-data; boundary=' + UploadPostHelper.getBoundary();
			jpgURLRequest.method = URLRequestMethod.POST; 
			var variables:URLVariables = new URLVariables();
			variables.info=info;
			variables.isdianpu="false";
			if(this.isdianpu==true)
			{
				variables.isdianpu="true";
			}
			jpgURLRequest.data = UploadPostHelper.getPostData( currentDate.time.toString()+'.jpg', jpgStream,"image",variables );     
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(ProgressEvent.PROGRESS,progressHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
			loader.addEventListener(Event.COMPLETE, completejpgHandler);
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.load(jpgURLRequest);
		
		}
	
		
		private function progressHandler(e:ProgressEvent):void
		{
			btntext.text="上传中";
			button.mouseEnabled=false;
			
			setTiptool(true,"正在上传");
			
		}
		
		private function ioErrorHandler(e:IOErrorEvent):void
		{
			setTiptool(true,"上传失败");
			setButtonText("确定");
			button.mouseEnabled=true;
			
			
		}
		
		private function completejpgHandler(e:Event):void
		{
			var input:String = e.target.data;
			printInfo(input);
			var arr:Array=input.split("|");
			if(arr.length > 0 && arr[1]=="1")
			{
				var url:String = arr[0];
				printInfo("AAAAA"+url);
				
				setTiptool(true,"上传成功");
				tipSprite.visible=true;
				setButtonText("确定");
				printInfo(e.target.data);
				button.mouseEnabled=true;
				
				
				var pan:String = getCursorPan(this.dragsprite.x+this.dragsprite.width/2).toFixed(2);
				var tilt:String = getCursorTilt(this.dragsprite.y+this.dragsprite.width/2).toFixed(2) ;
				
				this.curpan = pan;
				this.curtilt = tilt;
				
				ExternalInterface.call("FlashUploadSuccess",url,this.curpan,this.curtilt,qjPlayer.manager.currentPanoramaData.id);
			}
			else if(arr.length > 1 && arr[2]=="1")
			{
				var url1:String = arr[0];
				var url2:String = arr[1];
				printInfo("AAAAA"+url1);
				
				setTiptool(true,"上传成功");
				tipSprite.visible=true;
				setButtonText("确定");
				printInfo(e.target.data);
				button.mouseEnabled=true;
				
				ExternalInterface.call("FlashUploadSuccessByProduct",url1,url2);
			}
			else
			{
				setTiptool(true,"上传失败");
				setButtonText("确定");
				button.mouseEnabled=true;
			}
		
		}
		
		
		
	
		
		/**
		 * First panorama started loading, so all modules are loaded and added to stage
		 * now you can call other modules either directly or by executing proper actions
		 * each module must be ready to execute exposed functions after first panorama started loading;
		 */
		private function onFirstPanoramaStartedLoading(e:Event):void {
			
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
			
			
			var bg:Graphics = this.graphics;
			bg.clear();
			bg.beginFill(0x000000,0.1);
			bg.drawRect(0,0,qjPlayer.manager.boundsWidth,qjPlayer.manager.boundsHeight);
			bg.endFill();
			
			windowsprite.x = qjPlayer.manager.boundsWidth - 200;
			windowsprite.y = 10;
			

			
		}
		
		
		
		private function onClosingFinish():void {
			
			this.visible=false;
		}
		
		
		////////////////////////////////////////////////////////////////
		////////////////////////
	
		
		public function setOpen(value:Boolean):void {
			this.visible=value;
			isopen=value;
		}
		
		public function toggleOpen():void {
		
			if(isopen==true)
			{
				setOpen(false);
			}
			else
			{
				setOpen(true);
			}
		}
		
		
	}
}
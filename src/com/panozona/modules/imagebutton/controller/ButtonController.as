/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.imagebutton.controller{
	
	import com.panozona.modules.imagebutton.model.SubButtonData;
	import com.panozona.modules.imagebutton.model.structure.Style;
	import com.panozona.modules.imagebutton.model.structure.StyleContent;
	import com.panozona.modules.imagebutton.model.structure.SubButton;
	import com.panozona.modules.imagebutton.view.ButtonView;
	import com.panozona.modules.imagebutton.view.SubButtonView;
	import com.panozona.modules.menuscroller.view.ElementView;
	import com.panozona.player.module.Module;
	import com.panozona.player.module.data.property.Size;
	
	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.external.ExternalInterface;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import caurina.transitions.Tweener;
	
	public class ButtonController {
		
		private var _buttonView:ButtonView;
		private var _module:Module;
		private var _isloaded:Boolean=false;
		private var _updirect:Number=0;
		
		private var textField:TextField;
		
		private var subButtonControllers:Vector.<SubButtonController>;
		
		public function ButtonController(buttonView:ButtonView, module:Module) {
			
			_buttonView = buttonView;
			_module = module;
			
			var panoramaEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.events.PanoramaEvent") as Class;
			_module.qjPlayer.manager.addEventListener(panoramaEventClass.PANORAMA_STARTED_LOADING, onPanoramaStartedLoading, false, 0, true);
			module.qjPlayer.manager.addEventListener(panoramaEventClass.PANORAMA_LOADED, onPanoramaLoaded, false, 0, true);
			if(_buttonView.windowData.button.action != null){
				_buttonView.addEventListener(MouseEvent.CLICK, getMouseEventHandler(_buttonView.windowData.button.action));
			}
			//JS 事件
			if(_buttonView.windowData.button.jsaction != null){
				_buttonView.addEventListener(MouseEvent.CLICK, function():void{
					if(_buttonView.windowData.button.jsaction.toLowerCase().indexOf("http://")  == 0)
					{
						//网址跳转
						var url:URLRequest=new URLRequest(_buttonView.windowData.button.jsaction);
						flash.net.navigateToURL(url,"_self");
					}
					else
					{	
						//响应JS
						ExternalInterface.call(_buttonView.windowData.button.jsaction,_buttonView.windowData.button.id);
					}
				});
			}
			
			if (_buttonView.windowData.button.path != null && _buttonView.windowData.open == true){
				var buttonLoader:Loader = new Loader();
				buttonLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, buttonImageLost);
				buttonLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, buttonImageLoaded);
				buttonLoader.load(new URLRequest(_buttonView.windowData.button.path),new flash.system.LoaderContext(true));
				
				_isloaded = true;
			}
			
			module.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
			
			
			
		
			subButtonControllers = new Vector.<SubButtonController>();
			
			var subButtonView:SubButtonView;
			var subButtonController:SubButtonController;
			for each(var subButton:SubButton in buttonView.windowData.button.subButtons.getChildrenOfGivenClass(SubButton)) {
				subButtonView = new SubButtonView(new SubButtonData(subButton), _buttonView.windowData);
				_buttonView.subButtonsContainer.addChild(subButtonView);
				subButtonController = new SubButtonController(subButtonView, _module);
				subButtonControllers.push(subButtonController);
			}
			
			if((_buttonView.windowData.button.type == "text" && _buttonView.windowData.button.text) || _buttonView.windowData.button.htmlText){
				
				baseText = _buttonView.windowData.button.text;
				var textSprite:Sprite = new Sprite();
				
				textField = new TextField();
				textSprite.addChild(textField);
				
				
				var styleContent:StyleContent = _buttonView.windowData.styleContent;
				textField.x = styleContent.bubblePadding;
				textField.y = styleContent.bubblePadding;
				
				if(_buttonView.windowData.button.textSize){
					if(_buttonView.windowData.button.textSize.width >0)
						textField.width = _buttonView.windowData.button.textSize.width;
					if(_buttonView.windowData.button.textSize.height >0)
						textField.height = _buttonView.windowData.button.textSize.height;
				}
				
			    if(_buttonView.windowData.button.htmlText)
				{
					//HTMLtext会受textFormat影响生成的HTML标签
					textSprite.blendMode = BlendMode.LAYER;
					textField.wordWrap = true; //设置自动换行
					textField.multiline = true;
					textField.selectable = false;
					textField.background = false;
					textField.autoSize = TextFieldAutoSize.LEFT;
					textField.antiAliasType = AntiAliasType.ADVANCED;
					textField.defaultTextFormat = textField.defaultTextFormat;
					textField.htmlText = _buttonView.windowData.button.htmlText.text;
				}
				else if(_buttonView.windowData.button.text)
				{
					var textFormat:TextFormat = new TextFormat();
					textField.defaultTextFormat = textFormat;
					textField.multiline = true;
					textField.selectable = false;
					textField.autoSize = TextFieldAutoSize.LEFT;
					textField.blendMode = BlendMode.LAYER;
					textField.background = false;
					textField.antiAliasType = AntiAliasType.ADVANCED;
					textField.mouseEnabled = false;
					
					textSprite.blendMode = BlendMode.LAYER;
					textSprite.addChild(textField);
					
					textFormat.font = styleContent.fontFamily;
					textFormat.size = styleContent.fontSize;
					textFormat.color = styleContent.fontColor;
					textFormat.bold = styleContent.fontBold;
					textField.defaultTextFormat = textFormat;
					textField.text = _buttonView.windowData.button.text;
					textField.defaultTextFormat = textFormat;
				}
				
				if(styleContent.bgAlpha > 0)
				{
					textSprite.graphics.clear();
					textSprite.graphics.lineStyle(styleContent.borderSize, styleContent.borderColor,styleContent.bgAlpha);
					textSprite.graphics.beginFill(styleContent.bubbleColor,styleContent.bgAlpha);
//					var w:Number = (_buttonView.windowData.button.htmlText?textField.textWidth:textField.width) + styleContent.bubblePadding * 2;
//					var h:Number = (_buttonView.windowData.button.htmlText?textField.textHeight:textField.height) + styleContent.bubblePadding * 2;
//					var w:Number = textField.textWidth + styleContent.bubblePadding * 2;
//					var h:Number = textField.textHeight + styleContent.bubblePadding * 2;
					var w:Number = textField.width + styleContent.bubblePadding * 2;
					var h:Number = textField.height + styleContent.bubblePadding * 2;
//					trace("text="+textField.text+" h="+h+"w="+w+" textHeight="+textField.textHeight+" height="+textField.height+" textWidth="+textField.textWidth+" width="+textField.width);
					textSprite.graphics.drawRoundRect(0, 0,
						w,
						h,
						styleContent.borderRadius);
					textSprite.graphics.endFill();
				}
				
				textSprite.alpha=styleContent.alpha;
				if(styleContent.isdropfilter==true)
				{
					var shadow:DropShadowFilter=new DropShadowFilter();
					shadow.distance=styleContent.d_distance;
					shadow.angle = styleContent.d_angle;
					shadow.alpha = styleContent.d_alpha;
					shadow.color = styleContent.d_color;
					
					textSprite.filters=[shadow];
				}
				textField.addEventListener(TextEvent.LINK, linkEventHandler);
				_buttonView.addChild(textSprite);
		
				
				
			
			}
		}
		
		private function linkEventHandler(event:TextEvent):void
		{
			   if(event.text != "")
			   {
				   _module.qjPlayer.manager.runAction(event.text);
			   }
		}
	
		private function onEnterFrame(e:Event):void
		{
			if(_isloaded == false)
			{
				if (_buttonView.windowData.button.path != null && _buttonView.windowData.open == true){
					_isloaded = true;

					var buttonLoader:Loader = new Loader();
					buttonLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, buttonImageLost);
					buttonLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, buttonImageLoaded);
					buttonLoader.load(new URLRequest(_buttonView.windowData.button.path),new flash.system.LoaderContext(true));
					
					
				}
			}
			
		
			
			
		}
		
			
		
		private function onPanoramaStartedLoading(loadPanoramaEvent:Object):void {
			var panoramaEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.events.PanoramaEvent") as Class;
			_module.qjPlayer.manager.removeEventListener(panoramaEventClass.PANORAMA_STARTED_LOADING, onPanoramaStartedLoading);
			

			if (_buttonView.windowData.open) {
				_module.qjPlayer.manager.runAction(_buttonView.windowData.window.onOpen);
			}else {
				_module.qjPlayer.manager.runAction(_buttonView.windowData.window.onClose);
			}
			
		}
		

		
		private var baseText:String;
		private function onPanoramaLoaded(e:Event):void{
			
			if(this._buttonView.windowData.open == true)
			{
				if(_module.ifcheck(this._buttonView.windowData.button)  == false)
				{
					this._buttonView.windowData.open = false;
				}
				
			}
			
			
			
			
			if(textField && _module.qjPlayer.manager.currentPanoramaData){
				var s:String = baseText;
				if(s != null)
				{
					s = s.replace("{title}",_module.qjPlayer.manager.currentPanoramaData.title);
					textField.text = s;
				}
			}
		}
		
		
		public function buttonImageLost(e:IOErrorEvent):void {
			(e.target as LoaderInfo).removeEventListener(IOErrorEvent.IO_ERROR, buttonImageLost);
			(e.target as LoaderInfo).removeEventListener(Event.COMPLETE, buttonImageLoaded);
			_module.printError(e.toString());
		}
		
		public function buttonImageLoaded(e:Event):void {
			(e.target as LoaderInfo).removeEventListener(IOErrorEvent.IO_ERROR, buttonImageLost);
			(e.target as LoaderInfo).removeEventListener(Event.COMPLETE, buttonImageLoaded);
			
			var displayobj:DisplayObject = (e.target as LoaderInfo).content;
			
			try{
			if(displayobj.hasOwnProperty("qjPlayer"))
				displayobj["qjPlayer"] = _module.qjPlayer;
			}catch(err:Error){
				_module.printError(err.message);
			}
			
			_buttonView.addChildAt(displayobj, 0);
			_buttonView.scaleX = _buttonView.windowData.button.scale;
			_buttonView.scaleY = _buttonView.windowData.button.scale;
			
			var w:Number = _buttonView.width;
			var h:Number = _buttonView.height;
			if(w > _module.qjPlayer.manager.boundsWidth)
			{
				w = _module.qjPlayer.manager.boundsWidth - 30;
				h = _buttonView.height/_buttonView.width * w
				_buttonView.height = h;
				_buttonView.width = w;
			}
			else if(h > _module.qjPlayer.manager.boundsHeight)
			{
				h = _module.qjPlayer.manager.boundsHeight - 30;
				w = _buttonView.width/_buttonView.height * h;
				_buttonView.width = w;
				_buttonView.height = h;
			}
			
			
			_buttonView.windowData.size = new Size(w,h);
			
			if (_buttonView.windowData.button.mouse.onOver != null) {
				_buttonView.addEventListener(MouseEvent.ROLL_OVER, getMouseEventHandler(_buttonView.windowData.button.mouse.onOver));
			}
			if (_buttonView.windowData.button.mouse.onOut != null) {
				_buttonView.addEventListener(MouseEvent.ROLL_OUT, getMouseEventHandler(_buttonView.windowData.button.mouse.onOut));
			}
		
		}
		
		private function getMouseEventHandler(actionId:String):Function{
			return function(e:MouseEvent):void {
				_module.qjPlayer.manager.runAction(actionId);
			}
		}
	}
}
package com.panozona.modules.museumItem.view
{
	import com.panozona.modules.museumItem.data.DressItem;
	import com.panozona.modules.museumItem.data.MuseumItemData;
	import com.panozona.modules.museumItem.data.SourceItem;
	import com.panozona.player.module.Module;
	
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import caurina.transitions.Tweener;
	
	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-6-10 下午2:19:41
	 * 功能描述:
	 */
	public class JumpDressWnd extends Sprite
	{
		
		private var bg:BackView;
		
		private var w:Number;
		
		private var h:Number;
		
		private var item:DressItem;
		
		private var closeBtn:IconView;
		
		private var leftSp:Sprite;
		
		private var titleTxt:TextField;
		
		private var infoTxt:MaskTextView;
		
		private  var sources:Vector.<SourceItem>;
		
		private var citiaoBtn:IconView;
		
		private var hdView:HDView;
		
		private var callBackFun:Function;
		
		private var viewW:Number = 850;
		
		private var gap:Number = 15;
		
		private var btnHeight:Number = 27;
		
		private var content:Sprite;
		
		private var initViewW:Number = 850;
		
		private var maxLeftGap:Number= 80;
		
		private var maxTopGap:Number= 40;
		
		private var viewH:Number = 600;
		
		private var initViewH:Number = 600;
		
		private var leftW:Number = 290;
		
		private var museumItemData:MuseumItemData;
		
		private var module:Module;
		
		private var jiangjieBtn:IconView;
		
		private var sizeForLeft:Number = 1.8;
		
		private var leftbgColor:Number = 0xd5d5d5;
		
		private var buttonGap:Number = 3;
		
		private var leftBgSp:Sprite;
		
		private var titleTop:Number = 20;
		
		public function JumpDressWnd(item:DressItem,callBackFun:Function,museumItemData:MuseumItemData,module:Module)
		{
			super();
			
			this.museumItemData = museumItemData;
			this.module = module;
			
			bg = new BackView();
			addChild(bg);
			
			leftBgSp = new Sprite();
			addChild(leftBgSp);
			
			content = new Sprite();
			addChild(content);
			
			handleResize(module.qjPlayer.manager.boundsWidth,module.qjPlayer.manager.boundsHeight);
			
			this.item = item;
			this.callBackFun = callBackFun;
			
			this.sources = museumItemData.sources;
			
			
			
			createUI();
			
			jump();
		}
		
		private function drawLeftBg():void{
			leftBgSp.graphics.clear();
			leftBgSp.graphics.beginFill(leftbgColor,1);
			leftBgSp.graphics.drawRect(0,0,leftW,h);
			leftBgSp.graphics.endFill();
			leftBgSp.x = leftSp.localToGlobal(new Point(0,0)).x;
		}
		
		public function jump():void{
			var tempSp:JumpDressWnd = this;
			this.scaleX = this.scaleY = 0.1;
			this.visible = true;
			
			content.visible = false;
			
			leftBgSp.visible = false;
			
			Tweener.addTween(tempSp,{scaleX:1,scaleY:1,time:0.3,onUpdate:function():void{
				tempSp.x = module.qjPlayer.manager.boundsWidth*(1-tempSp.scaleX)/2;
				tempSp.y = module.qjPlayer.manager.boundsHeight*(1-tempSp.scaleY)/2;
			},onComplete:function():void{
				showAlign();
				content.visible = true;
				closeBtn.visible = true;
				leftBgSp.visible = true;
			}});
		}
				
		private var iscreateUi:Boolean;
		
		private function createUI():void
		{
			
			leftSp = new Sprite();
			content.addChild(leftSp);
			
			titleTxt = getText(item.title.text,0xefefef,36,leftW-gap*2);
			infoTxt = new MaskTextView(item.info.text,showBtnAlign,true,leftW-gap*2,true);
			
			titleTxt.x = infoTxt.x = gap;
			titleTxt.y = titleTop;
			
			leftSp.addChild(titleTxt);
			leftSp.addChild(infoTxt);
			infoTxt.y = titleTxt.y+titleTxt.height;	
//			leftSp.x = left;
//			leftSp.y = top;
			
			viewW = leftW*sizeForLeft;
			
			
			if(item.buyWebUrl){
				var item3:SourceItem = getSourceItemByName("btn_dressItemBuy");
				citiaoBtn = new IconView(item3.baseUrl,item3.mouseOverUrl,showBtnAlign);
				citiaoBtn.y = infoTxt.y+infoTxt.height+gap;
				citiaoBtn.buttonMode = true;
				citiaoBtn.addEventListener(MouseEvent.CLICK,showCitiaoWeb);
				leftSp.addChild(citiaoBtn);
			}
			
			if(item.infoWebUrl){
				var item4:SourceItem = getSourceItemByName("btn_dressItemInfo");
				jiangjieBtn = new IconView(item4.baseUrl,item4.mouseOverUrl,showBtnAlign);
				jiangjieBtn.buttonMode = true;
				jiangjieBtn.addEventListener(MouseEvent.CLICK,showJiangjieWeb);
				leftSp.addChild(jiangjieBtn);
			}
			
			
			hdView = new HDView(item.showItemUrl,viewW,initViewH);
			hdView.y = leftSp.y;
			leftSp.x = hdView.x+viewW +5;
			content.addChild(hdView);
			
			
			var item2:SourceItem  = getSourceItemByName("btn_close");
			closeBtn = new IconView(item2.baseUrl,item2.mouseOverUrl,showCloseBtnAlign);
			showCloseBtnAlign();
			closeBtn.y = 10;
			closeBtn.buttonMode = true;
			closeBtn.addEventListener(MouseEvent.CLICK,close);
			addChild(closeBtn);
			
			drawLeftBg();
			
			iscreateUi = true;
		}
		
		private function showBtnAlign():void
		{
			if(citiaoBtn){
				citiaoBtn.y = infoTxt.y+infoTxt.height+gap;
				citiaoBtn.x = (leftW - citiaoBtn.width -(jiangjieBtn?(jiangjieBtn.width+buttonGap):0))/2;
			}
			if(jiangjieBtn){
				jiangjieBtn.y = infoTxt.y+infoTxt.height+gap;
				if(citiaoBtn){
					jiangjieBtn.x = citiaoBtn.x+citiaoBtn.width+buttonGap;
				}else{
					jiangjieBtn.x = (leftW - citiaoBtn.width)/2;
				}
			}	
		}
		
		private function showAlign():void{
			if(!iscreateUi)
				return;
			
			if(w - leftW*(sizeForLeft+1) >= maxLeftGap*2){
				if(leftSp.visible)
					initViewW = w-maxLeftGap*2-leftW; 
				else
					initViewW = w-maxLeftGap*2; 
				content.x = maxLeftGap;
			}else if(w - leftW*(sizeForLeft+1) < maxLeftGap*2 && w - leftW*(sizeForLeft+1)>0){
				if(leftSp.visible)
					initViewW = leftW*sizeForLeft; 
				else
					initViewW = leftW*(sizeForLeft+1); 
				content.x =  (w-leftW*(sizeForLeft+1))/2;
			}else{
				if(leftSp.visible)
					initViewW = w-leftW;
				else
					initViewW = w;
				content.x = 0;
			}
			initViewW = Math.max(0,initViewW);
			initViewW = Math.min(w,initViewW);
			viewW = initViewW;
			
			if(h - initViewH >= maxTopGap*2){
				content.y = maxTopGap;
				viewH = h-maxTopGap*2;
			}else if(h - initViewH < maxTopGap*2 && h - initViewH>0){
				content.y =  (h -initViewH)/2;
				viewH = initViewH;
			}else{
				content.y = 0;
				viewH = h;
			}
			viewH = Math.max(0,viewH);
			viewH = Math.min(h,viewH);
			hdView.setWh(viewW,viewH);
			infoTxt.setH(h-titleTxt.height-gap*2-btnHeight-titleTop);
			
			leftSp.x = hdView.x+viewW +5;
			
			drawLeftBg();
			
		}
		
		protected function showCitiaoWeb(event:MouseEvent):void
		{
			navigateToURL(new URLRequest(item.buyWebUrl), "_blank");			
		}
		
		protected function showJiangjieWeb(event:MouseEvent):void
		{
			navigateToURL(new URLRequest(item.infoWebUrl), "_blank");			
		}
		
		private function showCloseBtnAlign():void{
			if(closeBtn){
				closeBtn.x = w-closeBtn.width-10;
				if(tx_autoClose){
					tx_autoClose.y = closeBtn.y;
					tx_autoClose.x = closeBtn.x - tx_autoClose.width;
				}
			}
		}
		
		public function destroy():void{
			if(closeBtn){
				closeBtn.destroy();
				if(closeBtn.hasEventListener(MouseEvent.CLICK))
					closeBtn.removeEventListener(MouseEvent.CLICK,close);
			}
			if(jiangjieBtn){
				jiangjieBtn.destroy();
				if(jiangjieBtn.hasEventListener(MouseEvent.CLICK))
					jiangjieBtn.removeEventListener(MouseEvent.CLICK,showJiangjieWeb);
			}
			if(citiaoBtn){
				citiaoBtn.destroy();
				if(citiaoBtn.hasEventListener(MouseEvent.CLICK))
					citiaoBtn.removeEventListener(MouseEvent.CLICK,showCitiaoWeb);
			}
			if(infoTxt)
				infoTxt.destroy();
			if(parent)
				parent.removeChild(this);
			callBackFun = null;
		}
		
		public function close(event:MouseEvent=null):void{
//			for(var i:int=0;i<numChildren;i++){
//				var temp:* = getChildAt(i);
//				if(temp != bg && temp != closeBtn)
//					temp.visible = false;
//			}
			if(callBackFun != null){
				callBackFun({type:"close"});
			}
			var tempSp:JumpDressWnd = this;
			Tweener.pauseTweens(tempSp);
			Tweener.addTween(tempSp,{scaleX:0,scaleY:0,time:0.3,onUpdate:function():void{
				tempSp.x = w*(1-tempSp.scaleX)/2;
				tempSp.y = h*(1-tempSp.scaleY)/2;
			},onComplete:function():void{
				tempSp.visible = false;
				tempSp.scaleX = tempSp.scaleY = 1;
				hdView.destroy();
				destroy();
			}});
			cancelAutoClose();
			
		}
		
		public function handleResize(w:Number,h:Number):void{
			this.w = w;
			this.h = h;
			bg.drawBg(w,h);
			
			showCloseBtnAlign();
			showAlign();
		}
		
		private var tx_autoClose:TextField;
		
		private var tx_autoClose_txt:String = "x秒后自动关闭，点击取消关闭";
		
		private var autoTimeObj:Object={autoTime:0};
		
		public function set timeToAutoClose(_timeToAutoClose:Number):void{
			if(!tx_autoClose){
				tx_autoClose = getText(tx_autoClose_txt.replace("x",int(_timeToAutoClose)));
				addChild(tx_autoClose);
				tx_autoClose.addEventListener(MouseEvent.CLICK,cancelAutoClose);
			}
			tx_autoClose.y = closeBtn.y;
			tx_autoClose.x = closeBtn.x - tx_autoClose.width;
			tx_autoClose.visible = true;
			autoTimeObj.autoTime = _timeToAutoClose;
			Tweener.addTween(autoTimeObj,{time:_timeToAutoClose,transition:"linear",autoTime:0,onUpdate:function():void{
				tx_autoClose.text = tx_autoClose_txt.replace("x",int(autoTimeObj.autoTime));
			},onComplete:close});
			transition:"linear"
		}
		
		public function cancelAutoClose(e:MouseEvent=null):void{
			if(tx_autoClose)
				tx_autoClose.visible = false;
			Tweener.removeTweens(autoTimeObj);
		}
		
		public function getText(txt:String,color:int=0xffffff,size:int=15,w:Number=250,leading:int=0):TextField{
			
			var textField:TextField = new TextField();
			var textFormat:TextFormat = new TextFormat();
			
			textField.defaultTextFormat = textFormat;
			textField.multiline = true;
			textField.selectable = false;
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.blendMode = BlendMode.LAYER;
			textField.background = false;
			textField.antiAliasType = AntiAliasType.ADVANCED;
			textField.wordWrap = true;
	//		textField.mouseEnabled = false;
			textField.width = w;
			
			textFormat.font = "微软雅黑";
			textFormat.size = size;
			textFormat.color = color;
			textFormat.bold = false;
			textFormat.leading = leading;
			textField.defaultTextFormat = textFormat;
			textField.htmlText = txt;
			
			//			textField.filters=  [new GlowFilter(0x000000,1,2,2,5)];
			
			//			textSprite.graphics.clear();
			//			textSprite.graphics.lineStyle();
			//			textSprite.graphics.beginFill(0xcccccc);
			//			textSprite.graphics.drawRoundRect(0, 0,
			//				textField.width + 1 * 2,
			//				textField.height + 1 * 2,
			//				5);
			//			textSprite.graphics.endFill();
			//			
			//			var shadow:DropShadowFilter=new DropShadowFilter();
			//			textSprite.filters=[shadow];
			return textField;
		}
		
		public function getSourceItemByName(name:String):SourceItem{
			var len:int = sources.length;
			for(var i:int=0;i<len;i++){
				if(sources[i].name == name)
					return sources[i];
			}
			return null;
		}
	}
}
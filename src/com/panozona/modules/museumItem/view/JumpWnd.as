package com.panozona.modules.museumItem.view
{
	import com.panozona.modules.museumItem.data.MuseumItem;
	import com.panozona.modules.museumItem.data.MuseumItemData;
	import com.panozona.modules.museumItem.data.SourceItem;
	import com.panozona.player.module.Module;
	
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
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
	public class JumpWnd extends Sprite
	{
		
		private var bg:Sprite;
		
		private var w:Number;
		
		private var h:Number;
		
		private var item:MuseumItem;
		
		private var closeBtn:IconView;
		
		private var leftSp:Sprite;
		
		private var titleTxt:TextField;
		
		private var infoTxt:MaskTextView;
		
		private var blueLine:Sprite;
		
		private  var sources:Vector.<SourceItem>;
		
		private var citiaoBtn:IconView;
		
		private var jiangjieBtn:IconView;
		
		private var moveLeftBtn:IconView;
		
		private var moveRightBtn:IconView;
		
		private var lineSp:Sprite;
		
		private var hdView:HDView;
		
		private var callBackFun:Function;
		
		private var viewW:Number = 850;
		
		private var gap:Number = 20;
		
		private var btnHeight:Number = 80;
		
		private var content:Sprite;
		
		private var initViewW:Number = 850;
		
		private var maxLeftGap:Number= 80;
		
		private var maxTopGap:Number= 40;
		
		private var viewH:Number = 600;
		
		private var initViewH:Number = 600;
		
		private var leftW:Number = 272;
		
		public var scrollView:ScrollView;
		
		private var museumItemData:MuseumItemData;
		
		private var module:Module;
		
		public function JumpWnd(item:MuseumItem,callBackFun:Function,museumItemData:MuseumItemData,module:Module,isShowList:Boolean=false)
		{
			super();
			
			this.museumItemData = museumItemData;
			this.module = module;
			
			bg = new Sprite();
			addChild(bg);
			
			content = new Sprite();
			addChild(content);
			
			handleResize(module.qjPlayer.manager.boundsWidth,module.qjPlayer.manager.boundsHeight);
			
			this.item = item;
			this.callBackFun = callBackFun;
			
			this.sources = museumItemData.sources;
			
			createUI();
			
			this.isShowList = isShowList;
			
			jump();
		}
		
		public function jump():void{
			var tempSp:JumpWnd = this;
			this.scaleX = this.scaleY = 0.1;
			this.visible = true;
			
			content.visible = false;
			if(scrollView){
				scrollView.visible = false;
			}
			
			Tweener.addTween(tempSp,{scaleX:1,scaleY:1,time:0.3,onUpdate:function():void{
				tempSp.x = module.qjPlayer.manager.boundsWidth*(1-tempSp.scaleX)/2;
				tempSp.y = module.qjPlayer.manager.boundsHeight*(1-tempSp.scaleY)/2;
			},onComplete:function():void{
				showAlign();
				content.visible = true;
				if(scrollView && _isShowList){
					scrollView.visible = true;
				}
				closeBtn.visible = true;
			}});
		}
		
		public function resetData(item:MuseumItem):void{
			this.item = item;
			if(item.isOnlyShowPic){
				leftSp.visible = false;
				moveRightBtn.visible = moveLeftBtn.visible = lineSp.visible = false;
				hdView.x = leftSp.x +5;
			}else{
				hdView.x = leftSp.x + leftW +5;
				titleTxt.text = item.title;
				infoTxt.text = item.info;
				infoTxt.y = titleTxt.y+titleTxt.height+gap;
				blueLine.graphics.clear();
				blueLine.graphics.lineStyle(4,0x397ddb);
				blueLine.graphics.lineTo(0,titleTxt.height);
				leftSp.visible = true;
				lineSp.x = leftSp.x+leftW;
				moveRightBtn.visible  = false;
				moveLeftBtn.visible = lineSp.visible = true;
				if(item.citiaoUrl){
					if(!citiaoBtn){
						var item3:SourceItem = getSourceItemByName("btn_citiao");
						citiaoBtn = new IconView(item3.baseUrl,item3.mouseOverUrl);
						citiaoBtn.y = infoTxt.y+infoTxt.height+gap;
						citiaoBtn.x = gap;
						citiaoBtn.buttonMode = true;
						citiaoBtn.addEventListener(MouseEvent.CLICK,showCitiaoWeb);
						leftSp.addChild(citiaoBtn);
					}else{
						citiaoBtn.visible = true;
					}
				}else{
					if(citiaoBtn)
						citiaoBtn.visible = false;
				}
				
				
				if(item.jiangJieUrl){
					if(!jiangjieBtn){
						var item4:SourceItem = getSourceItemByName("btn_jiangjie");
						jiangjieBtn = new IconView(item4.baseUrl,item4.mouseOverUrl);
						jiangjieBtn.buttonMode = true;
						jiangjieBtn.y = infoTxt.y+infoTxt.height+gap;
						jiangjieBtn.x = item.citiaoUrl?118:20;
						jiangjieBtn.addEventListener(MouseEvent.CLICK,playJiangjie);
						leftSp.addChild(jiangjieBtn);
					}else{
						jiangjieBtn.visible = true;
					}
				}else{
					if(jiangjieBtn)
						jiangjieBtn.visible = false;
				}
			}
			hdView.reload(item.showItemUrl);
			showAlign();
			
			if(callBackFun != null){
				callBackFun({type:"changeItem"});
			}
		}
		
		private var iscreateUi:Boolean;
		
		private function createUI():void
		{
			
			leftSp = new Sprite();
			content.addChild(leftSp);
			
			titleTxt = getText(item.title,0xefefef,36);
			infoTxt = new MaskTextView(item.info,showBtnAlign);
			
			blueLine = new Sprite();
			blueLine.graphics.lineStyle(4,0x397ddb);
			blueLine.graphics.lineTo(0,titleTxt.height);
			leftSp.addChild(blueLine);
			
			titleTxt.x = infoTxt.x = gap;
			
			leftSp.addChild(titleTxt);
			leftSp.addChild(infoTxt);
			infoTxt.y = titleTxt.y+titleTxt.height;	
//			leftSp.x = left;
//			leftSp.y = top;
			
			viewW = leftW*3;
			
			
			if(item.citiaoUrl){
				var item3:SourceItem = getSourceItemByName("btn_citiao");
				citiaoBtn = new IconView(item3.baseUrl,item3.mouseOverUrl);
				citiaoBtn.y = infoTxt.y+infoTxt.height+gap;
				citiaoBtn.x = gap;
				citiaoBtn.buttonMode = true;
				citiaoBtn.addEventListener(MouseEvent.CLICK,showCitiaoWeb);
				leftSp.addChild(citiaoBtn);
			}
			
			if(item.jiangJieUrl){
				var item4:SourceItem = getSourceItemByName("btn_jiangjie");
				jiangjieBtn = new IconView(item4.baseUrl,item4.mouseOverUrl);
				jiangjieBtn.buttonMode = true;
				jiangjieBtn.y = infoTxt.y+infoTxt.height+gap;
				jiangjieBtn.x = item.citiaoUrl?118:20;
				jiangjieBtn.addEventListener(MouseEvent.CLICK,playJiangjie);
				leftSp.addChild(jiangjieBtn);
			}
			
			lineSp = new Sprite();
			lineSp.graphics.lineStyle(1,0x373737);
			lineSp.graphics.lineTo(0,initViewH);
			lineSp.y = leftSp.y;
			lineSp.x = leftSp.x+leftW;
			content.addChild(lineSp);
			
			hdView = new HDView(item.showItemUrl,viewW,initViewH);
			hdView.y = leftSp.y;
			hdView.x = leftSp.x+leftW +5;
			content.addChild(hdView);
			
			
			
			var item5:SourceItem = getSourceItemByName("btn_moveLeft");
			moveLeftBtn = new IconView(item5.baseUrl,item5.mouseOverUrl);
			moveLeftBtn.buttonMode = true;
			moveLeftBtn.y = leftSp.y;
			moveLeftBtn.x = leftSp.x+leftW;
			moveLeftBtn.addEventListener(MouseEvent.CLICK,move);
			content.addChild(moveLeftBtn);
			
			item5 = getSourceItemByName("btn_moveRight");
			moveRightBtn = new IconView(item5.baseUrl,item5.mouseOverUrl);
			moveRightBtn.buttonMode = true;
			moveRightBtn.y = leftSp.y;
			moveRightBtn.x = leftSp.x+leftW;
			moveRightBtn.addEventListener(MouseEvent.CLICK,move);
			moveRightBtn.visible = false;
			content.addChild(moveRightBtn);
			
			if(item.isOnlyShowPic){
				hdView.setWh(viewW,initViewH);
				leftSp.visible = false;
				moveRightBtn.visible = moveLeftBtn.visible = lineSp.visible = false;
			}
			
			var item2:SourceItem  = getSourceItemByName("btn_close");
			closeBtn = new IconView(item2.baseUrl,item2.mouseOverUrl,showCloseBtnAlign);
			showCloseBtnAlign();
			closeBtn.y = 10;
			closeBtn.buttonMode = true;
			closeBtn.addEventListener(MouseEvent.CLICK,close);
			addChild(closeBtn);
			
			if(museumItemData.scrollData){
				scrollView = new ScrollView(museumItemData,module);
				addChild(scrollView);
			}
			
			iscreateUi = true;
		}
		
		private function showBtnAlign():void
		{
			if(citiaoBtn){
				citiaoBtn.y = infoTxt.y+infoTxt.height+gap;
			}
			
			if(jiangjieBtn){
				jiangjieBtn.y = infoTxt.y+infoTxt.height+gap;
			}			
		}
		
		private function showAlign():void{
			if(!iscreateUi)
				return;
			
			if(museumItemData.scrollData){
				scrollView.y = h-museumItemData.scrollData.height;
			}
			
			if(item.isOnlyShowPic){
				if(w - leftW*4 >= maxLeftGap*2){
					initViewW = w-maxLeftGap*2;
					content.x = maxLeftGap;
				}else if(w - leftW*4 < maxLeftGap*2 && w - leftW*4>0){
					initViewW = leftW*4; 
					content.x =  (w-leftW*4)/2;
				}else{
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
				if(museumItemData.scrollData && _isShowList){
					viewH = viewH-museumItemData.scrollData.height;
				}
				viewH = Math.max(0,viewH);
				viewH = Math.min(h,viewH);
				hdView.setWh(viewW,viewH);
				hdView.x = 0;
				return;
			}
//			var fullH:Number = titleTxt.height+infoTxt.height+btnHeight+gap*2;
//			if(!citiaoBtn && !jiangjieBtn){
//				fullH = titleTxt.height+infoTxt.height+gap;
//			}
//			
//			if(h<fullH){
//				top = 0;
//			}else{
//				top = (h-fullH)/2;
//			}
			if(w - leftW*4 >= maxLeftGap*2){
				if(leftSp.visible)
					initViewW = w-maxLeftGap*2-leftW; 
				else
					initViewW = w-maxLeftGap*2; 
				content.x = maxLeftGap;
			}else if(w - leftW*4 < maxLeftGap*2 && w - leftW*4>0){
				if(leftSp.visible)
					initViewW = leftW*3; 
				else
					initViewW = leftW*4; 
				content.x =  (w-leftW*4)/2;
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
			if(museumItemData.scrollData && _isShowList){
				viewH = viewH-museumItemData.scrollData.height;
			}
			viewH = Math.max(0,viewH);
			viewH = Math.min(h,viewH);
			hdView.setWh(viewW,viewH);
			lineSp.graphics.clear();
			lineSp.graphics.lineStyle(1,0x373737);
			lineSp.graphics.lineTo(0,viewH);
			
			infoTxt.setH(h-titleTxt.height-gap*2-btnHeight-((museumItemData.scrollData && _isShowList)?museumItemData.scrollData.height:0));
			
			
		}
		
		protected function move(event:MouseEvent):void
		{
			moveLeftBtn.visible = moveRightBtn.visible = false;
			if(event.currentTarget == moveLeftBtn){
				leftSp.visible = false;
				Tweener.addTween(lineSp,{x:leftSp.x,time:0.5,onComplete:function():void{
					moveRightBtn.x = leftSp.x;
					moveRightBtn.visible = true;
					lineSp.visible = false;
				},onUpdate:function():void{
					hdView.x = lineSp.x;
					hdView.setWh(viewW+(leftW-lineSp.x+5),hdView.h);
				}});
			}else{
				leftSp.scaleX = 0;
				lineSp.visible = true;
				Tweener.addTween(leftSp,{scaleX:1,time:0.5,onUpdate:function():void{
					lineSp.x = leftSp.x+leftW;
					hdView.x = lineSp.x;
					hdView.setWh(viewW+(leftW-lineSp.x+5),hdView.h);
				},onComplete:function():void{
					moveLeftBtn.visible = true;
					leftSp.visible = true;
				}});
			}
		}
		
		protected function playJiangjie(event:MouseEvent):void
		{
			if(callBackFun != null){
				callBackFun({type:"playJiangjie",url:item.jiangJieUrl});
			}
		}
		
		protected function showCitiaoWeb(event:MouseEvent):void
		{
			navigateToURL(new URLRequest(item.citiaoUrl), "_blank");			
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
					jiangjieBtn.removeEventListener(MouseEvent.CLICK,playJiangjie);
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
			var tempSp:JumpWnd = this;
			Tweener.pauseTweens(tempSp);
			Tweener.addTween(tempSp,{scaleX:0,scaleY:0,time:0.3,onUpdate:function():void{
				tempSp.x = w*(1-tempSp.scaleX)/2;
				tempSp.y = h*(1-tempSp.scaleY)/2;
			},onComplete:function():void{
				tempSp.visible = false;
				tempSp.scaleX = tempSp.scaleY = 1;
				hdView.destroy();
			//	destroy();
			}});
			cancelAutoClose();
			
		}
		
		public function handleResize(w:Number,h:Number):void{
			this.w = w;
			this.h = h;
			bg.graphics.clear();
			bg.graphics.beginFill(0x1b1b1b,1);
			bg.graphics.drawRect(0,0,w,h);
			bg.graphics.endFill();	
			
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
			textField.text = txt;
			
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
		
		private var _isShowList:Boolean;
		public function set isShowList( _isShowList:Boolean):void{
			this._isShowList =  _isShowList;
			if(scrollView){
				scrollView.visible = _isShowList;
			}
			showAlign();
		}
	}
}
package com.panozona.modules.museumItem.view
{
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import caurina.transitions.Tweener;
	
	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-6-17 上午10:00:45
	 * 功能描述:
	 */
	public class MaskTextView extends Sprite
	{
		
		private var infoTxt:TextField;
		
		private var _mask:Sprite;
		
		private var _isShowHide:Boolean;
		
		private var btnShow:Sprite;
		
		private var btnHide:Sprite;
		
		private var onMoveUpdateFun:Function;
		
		private var isHtml:Boolean;
		
		private var isNeedScroll:Boolean;
		
		private var scrollBar:ScrollBar;
		
		public function MaskTextView(txt:String,onMoveUpdateFun:Function=null,isHtml:Boolean=false,w:Number=250,isNeedScroll:Boolean=false)
		{
			super();
			
			this.onMoveUpdateFun = onMoveUpdateFun;
			this.isHtml = isHtml;
			this.isNeedScroll = isNeedScroll;
			
			infoTxt = getText(txt,0xe5e5e5,14,w,3);
			addChild(infoTxt);
			
			_mask = new Sprite();
			addChild(_mask);
			
			setH(infoTxt.height);
			if(isNeedScroll){
				scrollBar = new ScrollBar(maskH,changePosition);
				scrollBar.x = w;
				addChild(scrollBar);
				scrollBar.visible = false;
			}else{
			
				btnShow = getBtn("展开",0xe5e5e5,14,35);
				btnShow.addEventListener(MouseEvent.CLICK,onRollOver);
				
				btnHide = getBtn("收起",0xe5e5e5,14,35);
				btnHide.addEventListener(MouseEvent.CLICK,onRollOver);
				
				addChild(btnShow);
				addChild(btnHide);
				
				btnShow.visible = btnHide.visible = false;
				
				btnShow.x = width-btnShow.width-5;
				
				btnHide.x = width-btnHide.width-5;
				btnHide.y = infoTxt.height;
			}
			
		}
		
		protected function changePosition():void
		{
			infoTxt.y = -scrollBar.persent*(infoTxt.textHeight-maskH+10);
		}
		
		public function set text(s:String):void{
			infoTxt.text = s;
			setH(infoTxt.height);
		}
		
		protected function onRollOver(event:MouseEvent):void
		{
			if(event.currentTarget == btnShow){
				isShowHide = true;
			}else{
				isShowHide = false;
			}
		}
		private var maskH:Number;
		public function setH(h:Number):void{
			maskH = h;
			drawMask(h);
			if(h<infoTxt.height){
				if(scrollBar){
					scrollBar.visible = true;
					scrollBar.setH(h);
				}
				if(btnShow){
					btnShow.y = h;
					btnShow.visible = true;
					btnHide.visible = false;
				}
			}else{
				if(btnShow){
					btnShow.visible = false;
					btnHide.visible = false;
				}
				if(scrollBar){
					scrollBar.visible = false;
				}
			}
		}
		
		private function drawMask(h:Number):void{
			_mask.graphics.clear();
			_mask.graphics.beginFill(1,0);
			_mask.graphics.drawRect(0,0,infoTxt.width,h);
			_mask.graphics.endFill();
			infoTxt.mask = _mask;
			if(onMoveUpdateFun != null)
				onMoveUpdateFun();
		}
		
		override public function get height():Number{
			if(_mask && maskH<infoTxt.height)
				return _mask.height;
			return infoTxt.height;
		}
		
		public function set isShowHide(_isShowHide:Boolean):void{
			this._isShowHide = _isShowHide;
			btnHide.visible = btnShow.visible = false;
			var h:Number = _isShowHide?infoTxt.height:maskH;
			var obj:Object = {h:_mask.height}
			Tweener.addTween(obj,{h:h,time:0.3,onUpdate:function():void{
				drawMask(obj.h);
			},onComplete:function():void{
				_isShowHide?btnHide.visible = true:btnShow.visible = true;
			}});
		}
		
		public function destroy():void{
			if(btnShow && btnShow.hasEventListener(MouseEvent.CLICK))
				btnShow.removeEventListener(MouseEvent.CLICK,onRollOver);
			if(btnHide && btnHide.hasEventListener(MouseEvent.CLICK))
				btnHide.removeEventListener(MouseEvent.CLICK,onRollOver);
			onMoveUpdateFun = null;
			if(scrollBar)
				scrollBar.destroy();
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
			textField.mouseEnabled = false;
			textField.width = w;
			
			textFormat.font = "微软雅黑";
			textFormat.size = size;
			textFormat.color = color;
			textFormat.bold = false;
			textFormat.leading = leading;
			textField.defaultTextFormat = textFormat;
			if(isHtml)
				textField.htmlText = txt;
			else
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
		
		public function getBtn(txt:String,color:int=0xffffff,size:int=15,w:Number=250,leading:int=0):Sprite{
			var textField:TextField = getText(txt,color,size,w,leading);
			var sp:Sprite = new Sprite();
			sp.graphics.beginFill(1,0);
			sp.graphics.drawRect(0,0,textField.width,textField.height);
			sp.graphics.endFill();
			sp.addChild(textField);
			sp.buttonMode = true;
			return sp;
		}
	}
}
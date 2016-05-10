package com.panozona.modules.panoramaTitleAndDes.view
{
	import com.panozona.modules.panoramaTitleAndDes.model.PanoramaTitleAndDesData;
	import com.panozona.modules.panoramaTitleAndDes.model.structure.SourceItem;
	import com.panozona.modules.panoramaTitleAndDes.view.IconView;
	
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-8-1 上午10:16:44
	 * 功能描述:
	 */
	public class TitleView extends Sprite
	{
		
		private var _panoramaTitleAndDesData:PanoramaTitleAndDesData;
		
		private var titleTxt:TextField;
		
		private var zhankaiIcon:IconView;
		
		private var titleIcon:IconView;
		
		public function TitleView(_panoramaTitleAndDesData:PanoramaTitleAndDesData)
		{
			super();
			this._panoramaTitleAndDesData = _panoramaTitleAndDesData;
			
			titleTxt = getText("全景",_panoramaTitleAndDesData.settings.titleFontColor,_panoramaTitleAndDesData.settings.titleFontSize);
			addChild(titleTxt);
			
			var item4:SourceItem;
			
			item4 = _panoramaTitleAndDesData.getSourceItemByName("btn_zhankai");
			if(item4){
				zhankaiIcon = new IconView(item4.baseUrl,null,item4.mouseOverUrl,showAlign);
				if(!_panoramaTitleAndDesData.settings.isHideDes){
					addChild(zhankaiIcon);
					zhankaiIcon.buttonMode = true;
					zhankaiIcon.addEventListener(MouseEvent.CLICK,onShouSuo);
				}
			}
			
			item4 = _panoramaTitleAndDesData.getSourceItemByName("btn_title");
			if(item4){
				titleIcon = new IconView(item4.baseUrl,null,item4.mouseOverUrl,showAlign);
				addChild(titleIcon);
			}
		}
		
		protected function onShouSuo(event:MouseEvent):void
		{
			_panoramaTitleAndDesData.isShowFull = true;
		}
		
		public function set title(_title:String):void{
			if(titleTxt)
				titleTxt.text = _panoramaTitleAndDesData.settings.preText+_title;
			showAlign();
		}
		
		private var vw:Number = 0;
		
		private var vh:Number = 0;
		
		private function showAlign():void
		{
			if( zhankaiIcon && titleIcon){
				getWH();
				titleIcon.x = _panoramaTitleAndDesData.settings.leftPadding;
				titleIcon.y = (vh-titleIcon.height)*0.5;
				titleTxt.x = titleIcon.x+titleIcon.width+_panoramaTitleAndDesData.settings.gap;
				titleTxt.y = (vh-titleTxt.height)*0.5;
				if(!_panoramaTitleAndDesData.settings.isHideDes){
					zhankaiIcon.x = titleTxt.x + titleTxt.width+_panoramaTitleAndDesData.settings.gap;
					zhankaiIcon.y = (vh-zhankaiIcon.height)*0.5;
				}
				drawBg();
			}
		}
		
		private function getWH():void{
			var tempW:Number = 0;
			tempW += _panoramaTitleAndDesData.settings.leftPadding;
			for(var i:int=0;i<numChildren;i++){
				var temp:DisplayObject = getChildAt(i);
				tempW += (temp.width+(i==(numChildren-1)?0:_panoramaTitleAndDesData.settings.gap));
				if(temp.height>vh)
					vh = temp.height+2*_panoramaTitleAndDesData.settings.topPadding;
			}
			tempW += _panoramaTitleAndDesData.settings.rightPadding;
			vw = tempW;
		}
		
		private function drawBg():void{
			if(vw && vh){
				this.graphics.clear();
				this.graphics.lineStyle(_panoramaTitleAndDesData.settings.borderThick,_panoramaTitleAndDesData.settings.borderColor,_panoramaTitleAndDesData.settings.backAlpha);
				this.graphics.beginFill(_panoramaTitleAndDesData.settings.backColor,_panoramaTitleAndDesData.settings.backAlpha);
				this.graphics.drawRect(0,0,vw,vh);
				this.graphics.endFill();
			}
		}
		
		private function getText(txt:String,color:int=0xffffff,size:int=15,leading:int=0):TextField{
			
			var textField:TextField = new TextField();
			var textFormat:TextFormat = new TextFormat();
			
			textField.defaultTextFormat = textFormat;
			textField.multiline = false;
			textField.selectable = false;
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.blendMode = BlendMode.LAYER;
			textField.background = false;
			textField.antiAliasType = AntiAliasType.ADVANCED;
			textField.wordWrap = false;
			//		textField.mouseEnabled = false;
			
			
			textFormat.font = "微软雅黑";
			textFormat.size = size;
			textFormat.color = color;
			textFormat.bold = false;
			textFormat.leading = leading;
			textField.defaultTextFormat = textFormat;
			textField.text = txt;
			
			textField.width = textField.textWidth;
			
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
	}
}
package com.panozona.modules.panoramaTitleAndDes.view
{
	import com.panozona.modules.panoramaTitleAndDes.model.PanoramaTitleAndDesData;
	import com.panozona.modules.panoramaTitleAndDes.model.structure.SourceItem;
	
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import morn.core.components.TextArea;
	
	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-8-1 上午10:17:09
	 * 功能描述:
	 */
	public class DesView extends Sprite
	{
		
		private var _panoramaTitleAndDesData:PanoramaTitleAndDesData;
		
		private var titleTxt:TextField;
		
		private var descTxt:TextArea;
		
		private var shousuoIcon:IconView;
		
		private var lineSp:Sprite;
		
		public function DesView(_panoramaTitleAndDesData:PanoramaTitleAndDesData)
		{
			super();
			this._panoramaTitleAndDesData = _panoramaTitleAndDesData;
			
			titleTxt = getText("全景",_panoramaTitleAndDesData.settings.bigTitleFontColor,_panoramaTitleAndDesData.settings.bigTitleFontSize,_panoramaTitleAndDesData.windowData.window.size.width-2*_panoramaTitleAndDesData.settings.leftPadding);
			addChild(titleTxt);
			
			descTxt = new TextArea("全景描述");
			
			descTxt.vScrollBarSkin = "png.comp.vscroll2";
//			descTxt.vScrollBar.showButtons = false;
			var format:TextFormat = descTxt.format;
			format.color = _panoramaTitleAndDesData.settings.desTitleFontColor;
			format.size = _panoramaTitleAndDesData.settings.desTitleFontSize;
			format.font = "微软雅黑";
			descTxt.leading = _panoramaTitleAndDesData.settings.leading;
			descTxt.letterSpacing =  _panoramaTitleAndDesData.settings.spaceleading;
			descTxt.textField.textColor = _panoramaTitleAndDesData.settings.desTitleFontColor;
			descTxt.commitMeasure();
			descTxt.selectable = false;
			descTxt.vScrollBar.showButtons = false;
//			descTxt.format = format;
			addChild(descTxt);
			
			lineSp = new Sprite();
			
			lineSp.graphics.moveTo(1,0);
			lineSp.graphics.lineStyle(_panoramaTitleAndDesData.settings.lineAlpha,_panoramaTitleAndDesData.settings.lineColor);
			lineSp.graphics.lineTo(_panoramaTitleAndDesData.windowData.window.size.width-2,0);
			
			addChild(lineSp);
			
			lineSp.filters = [ new DropShadowFilter(1,45,_panoramaTitleAndDesData.settings.dropShadowColor,_panoramaTitleAndDesData.settings.lineAlpha,1,1) ];

			
			var item4:SourceItem = _panoramaTitleAndDesData.getSourceItemByName("btn_shousuo");
			if(item4){
				shousuoIcon = new IconView(item4.baseUrl,null,item4.mouseOverUrl,showAlign);
				addChild(shousuoIcon);
				shousuoIcon.buttonMode = true;
				shousuoIcon.addEventListener(MouseEvent.CLICK,onShouSuo);
			}
			
			showAlign();
			
		}
		
		protected function onShouSuo(event:MouseEvent):void
		{
			_panoramaTitleAndDesData.isShowFull = false;
		}
		
		private var vw:Number = 0;
		
		private var vh:Number = 0;
		
		
		private function showAlign():void
		{
			if( shousuoIcon){
				getWH();
				var maxH:Number = Math.max(titleTxt.textHeight,shousuoIcon.height);
				titleTxt.x = _panoramaTitleAndDesData.settings.leftPadding;
				titleTxt.y = _panoramaTitleAndDesData.settings.topPadding+(maxH-titleTxt.textHeight)*0.5;
				shousuoIcon.y = _panoramaTitleAndDesData.settings.topPadding+(maxH-shousuoIcon.height)*0.5;
				shousuoIcon.x = vw-_panoramaTitleAndDesData.settings.rightPadding-shousuoIcon.width;
				lineSp.y = maxH+_panoramaTitleAndDesData.settings.topPadding*2;
				descTxt.x = titleTxt.x;
				descTxt.y = lineSp.y + _panoramaTitleAndDesData.settings.topPadding;
				descTxt.width = _panoramaTitleAndDesData.windowData.window.size.width-2-_panoramaTitleAndDesData.settings.leftPadding;
				descTxt.height = _panoramaTitleAndDesData.windowData.window.size.height-_panoramaTitleAndDesData.settings.topPadding*2-lineSp.y;
				descTxt.vScrollBar.x = descTxt.width-descTxt.vScrollBar.width*descTxt.vScrollBar.scaleX;
				descTxt.textField.width = descTxt.width;
				drawBg();
			}
		}
		
		private function getWH():void{
			vw = _panoramaTitleAndDesData.windowData.window.size.width;
			vh = _panoramaTitleAndDesData.windowData.window.size.height;
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
		
		public function setData(title:String,des:String):void{
			if(titleTxt)
				titleTxt.text = title;
			if(descTxt){

				descTxt.textField.htmlText = des;
				descTxt.commitMeasure();
			}
			showAlign();
		}
	}
}
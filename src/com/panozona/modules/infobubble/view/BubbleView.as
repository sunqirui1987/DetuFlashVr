/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.infobubble.view{
	
	import com.panozona.modules.infobubble.model.InfoBubbleData;
	import com.panozona.modules.infobubble.model.structure.StyleContent;
	
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class BubbleView extends Sprite{
		
		public const textSprite:Sprite = new Sprite();
		
		private var textField:TextField = new TextField();
		private var textFormat:TextFormat = new TextFormat();
		
		private var _infoBubbleData:InfoBubbleData;
		
		public function BubbleView(infoBubbleData:InfoBubbleData){
			_infoBubbleData = infoBubbleData;
			
			mouseEnabled = false;
			mouseChildren = false;
			
			textField.defaultTextFormat = textFormat;
			textField.multiline = true;
			textField.selectable = false;
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.blendMode = BlendMode.LAYER;
			textField.background = false;
			textField.antiAliasType = AntiAliasType.ADVANCED;
			
			textSprite.blendMode = BlendMode.LAYER;
			textSprite.addChild(textField);
		}
		
		public function get infoBubbleData():InfoBubbleData {
			return _infoBubbleData;
		}
		
		public function setText(text:String, styleContent:StyleContent = null):void {
			if (styleContent == null) styleContent = new StyleContent();
			
			textFormat.font = styleContent.fontFamily;
			textFormat.size = styleContent.fontSize;
			textFormat.color = styleContent.fontColor;
			textFormat.bold = styleContent.fontBold;
			textField.defaultTextFormat = textFormat;
			textField.x = styleContent.bubblePadding;
			textField.y = styleContent.bubblePadding;
			textField.text = "";
			
			var array:Array = text.split("[n]");
			for (var i:int = 0; i < array.length; i++) {
				textField.appendText(array[i]);
				if (i < array.length - 1) {
					textField.appendText("\n");
				}
			}
			textSprite.graphics.clear();
			textSprite.graphics.lineStyle(styleContent.borderSize, styleContent.borderColor);
			textSprite.graphics.beginFill(styleContent.bubbleColor);
			textSprite.graphics.drawRoundRect(0, 0,
				textField.width + styleContent.bubblePadding * 2,
				textField.height + styleContent.bubblePadding * 2,
				styleContent.borderRadius);
			textSprite.graphics.endFill();
			this.alpha=styleContent.alpha;
			if(styleContent.isdropfilter==true)
			{
				var shadow:DropShadowFilter=new DropShadowFilter();
				shadow.distance=styleContent.d_distance;
				shadow.angle = styleContent.d_angle;
				shadow.alpha = styleContent.d_alpha;
				shadow.color = styleContent.d_color;
				
				textSprite.filters=[shadow];
			}
		}
	}
}
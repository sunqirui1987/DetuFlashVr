/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.panolink.view {
	
	import com.panozona.modules.panolink.model.PanoLinkData;
	import com.panozona.player.module.data.property.Size;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class LinkView extends Sprite {
		
		private var textField:TextField;
		private var textFormat:TextFormat;
		
		public const copyButton:SimpleButton = new SimpleButton();
		
		private var _panoLinkData:PanoLinkData;
		
		public function LinkView(panoLinkData:PanoLinkData) {
			
			_panoLinkData = panoLinkData;
			
			textFormat = new TextFormat();
			textFormat.size = _panoLinkData.settings.style.fontSize;
			textFormat.font = _panoLinkData.settings.style.fontFamily;
			textFormat.bold = _panoLinkData.settings.style.fontBold;
			textFormat.color = _panoLinkData.settings.style.fontColor;
			
			textField = new TextField();
			textField.background = true;
			textField.backgroundColor = _panoLinkData.settings.style.backgroundColor;
			textField.alwaysShowSelection = true;
			textField.width = _panoLinkData.settings.style.width;
			textField.height = _panoLinkData.settings.style.fontSize * 1.4;
			textField.defaultTextFormat = textFormat;
			textField.selectable = false;
			addChild(textField);
		}
		
		public function setBitmapsData(plainBitmapData:BitmapData, activeBitmapData:BitmapData):void {
			var copyPlainIcon:Sprite = new Sprite();
			copyPlainIcon.addChild(new Bitmap(plainBitmapData));
			var copyPressIcon:Sprite = new Sprite();
			copyPressIcon.addChild(new Bitmap(activeBitmapData));
			copyButton.upState = copyPlainIcon;
			copyButton.overState = copyPlainIcon;
			copyButton.downState = copyPressIcon;
			copyButton.hitTestState = copyPressIcon;
			copyButton.x = textField.width + 3;
			copyButton.y = (_panoLinkData.settings.style.fontSize * 1.4 - copyButton.height) * 0.5;
			copyButton.mouseEnabled = true;
			
			addChild(copyButton);
			
			_panoLinkData.windowData.size = new Size(this.width, this.height);
			
			copyButton.addEventListener(MouseEvent.CLICK, copyText, false, 0, true);
		}
		
		public function get panoLinkData():PanoLinkData {
			return _panoLinkData;
		}
		
		public function setText(value:String):void {
			textField.setSelection(0, 0);
			textField.text = value;
			textField.scrollH = textField.maxScrollH;
		}
		
		private function copyText(e:Event):void {
			textField.setSelection(0, textField.text.length);
			System.setClipboard(textField.text);
		}
	}
}
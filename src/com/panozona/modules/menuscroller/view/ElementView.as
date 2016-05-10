/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.menuscroller.view {
	
	import com.panozona.modules.menuscroller.events.ElementEvent;
	import com.panozona.modules.menuscroller.model.ElementData;
	import com.panozona.modules.menuscroller.model.structure.StyleContent;
	
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.ByteArray;
	
	public class ElementView extends Sprite{
		
		public var _content:Sprite;
		private var _contentAnchor:Sprite;
		
		private var _elementData:ElementData;
		
		public const textSprite:Sprite = new Sprite();
		
		private var textField:TextField = new TextField();
		private var textFormat:TextFormat = new TextFormat();
		
		public function ElementView(elementData:ElementData) {
			_elementData = elementData;
			
			buttonMode = true;
			
			_contentAnchor = new Sprite();
			_contentAnchor.graphics.beginFill(0x000000, 0);
			_contentAnchor.graphics.drawRect(0, 0, _elementData.size.width * 0.5, _elementData.size.height * 0.5);
			_contentAnchor.graphics.endFill();
			addChild(_contentAnchor);
			
			_elementData.addEventListener(ElementEvent.CHANGED_IS_ACTIVE, handleIsActiveChange, false, 0, true);
			
		}
		
		private function handleIsActiveChange(e:ElementEvent):void
		{
			if(_content == null) { return ; }
			
		//	_content.graphics.clear();
			if(_elementData.isActive == true)
			{
			//	_content.graphics.lineStyle(4,0xFFFFFF);
				_content.filters = [new GlowFilter(0xFFFFFF, 1.0, 8.0, 8.0, 10, 1, false, false)];  
			}
			else
			{
				_content.filters = [new GlowFilter(0x9FA0A0, 1.0, 5.0, 5.0, 10, 1, false, false)];  
		//		_content.graphics.lineStyle(2,0x777777);
			}
//			_content.graphics.drawRect(0,0,_content.width/_content.scaleX,_content.height/_content.scaleY);
//			_content.graphics.endFill();
			
		}
		
		public function get elementData():ElementData {
			return _elementData;
		}
		
		public function set content(displayObject:Sprite):void {
			if (_content != null) return;
			_contentAnchor.graphics.clear();
			_content = displayObject;
			
			_content.x = -displayObject.width * 0.5;
			_content.y = -displayObject.height * 0.5;
			
			_contentAnchor.x = displayObject.width * 0.5;
			_contentAnchor.y = displayObject.height * 0.5;
			
			_contentAnchor.addChild(_content);
			
			addEventListener(MouseEvent.ROLL_OVER, onMouseOver, false, 0, true);
			addEventListener(MouseEvent.ROLL_OUT, onMouseOut, false, 0, true);
			
			if(_elementData.rawElement.text){
				textField.multiline = false;
				textField.selectable = false;
				textField.blendMode = BlendMode.LAYER;
				textField.mouseEnabled = false;
		//		textField.autoSize = TextFieldAutoSize.LEFT;
				
				textField.width = elementData.size.width;
				 
				if(styleContent == null)
				{
					styleContent = new StyleContent();
				}
				textFormat.font = styleContent.fontFamily;
				textFormat.size = styleContent.fontSize;
				textFormat.color = styleContent.fontColor;
				textFormat.bold = styleContent.fontBold;
				textFormat.align = TextFormatAlign.CENTER;
				
				textField.defaultTextFormat = textFormat;
				
				textSprite.addChild(textField);
				
				_content.addChild(textSprite);
				textSprite.mouseEnabled = false;
				textSprite.mouseChildren = false;
				setW();
			}
			
//			_container.graphics.beginFill(0xff0000, 1);
//			_container.graphics.drawCircle(0, 0, 50);
//			_container.graphics.endFill();
//			
//			_contentAnchor.graphics.beginFill(0x00ff00, 1);
//			_contentAnchor.graphics.drawCircle(0, 0, 50);
//			_contentAnchor.graphics.endFill();
			
	
//			_content.graphics.clear();
//			_content.graphics.lineStyle(2,0x777777);
//			_content.graphics.drawRect(0,0,_content.width/_content.scaleX,_content.height/_content.scaleY);
//			_content.graphics.endFill();
			
			handleIsActiveChange(null);
			
		}
		
		private function onMouseOver(e:Event):void {
			parent.setChildIndex(this, parent.numChildren - 1);
			_elementData.mouseOver = true;
		}
		
		private function onMouseOut(e:Event):void {
			_elementData.mouseOver = false;
		}
		
		private var styleContent:StyleContent;
		
		private var text:String;
		
		public function setText(text:String, styleContent:StyleContent = null):void {
			this.styleContent = styleContent;
			if(!this.styleContent)
				this.styleContent = new StyleContent();
			this.text = text;
		}
		
		public function setW():void{
			
			textField.text = _elementData.rawElement.text;
			textSprite.graphics.clear();
			textSprite.graphics.beginFill(styleContent.backColor,styleContent.alpha);
			var h:Number = textField.textHeight + 5;// styleContent.fontSize*1.3;
			h = Math.min(h,elementData.size.height);
			textField.height = h;
			textSprite.graphics.drawRect(0, 0,
				elementData.size.width,
				h);
			textSprite.graphics.endFill();
			textSprite.y = (2*elementData.size.height/2 - h)*1/_content.scaleY ;
			textSprite.scaleX = 1/_content.scaleX;
			textSprite.scaleY = 1/_content.scaleY;
			
		}
		
		private function GetStringLength(thisString : String) : Number 
		{ 
			var thisStringByteLengths :ByteArray = new ByteArray(); 
			thisStringByteLengths.writeMultiByte(thisString, "utf8"); 
			return thisStringByteLengths.length; 
		} 
		
		private var _isSelect:Boolean;
		public function set isSelect(_isSelect:Boolean):void{
			if(this._isSelect == _isSelect || _elementData.isActive || !_content)
				return;
			this._isSelect = _isSelect;
			if(this._isSelect){
				_content.filters = [new GlowFilter(0x1dc7f7, 1.0, 5.0, 5.0, 10, 1, false, false)];  
			}else{
				_content.filters = [new GlowFilter(0x9FA0A0, 1.0, 5.0, 5.0, 10, 1, false, false)];  
			}
		}
	}
}
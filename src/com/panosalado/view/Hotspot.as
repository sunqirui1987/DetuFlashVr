/*
 OuWei Flash3DHDView 
*/
package com.panosalado.view {
	
	
	import com.panozona.player.manager.data.panoramas.HotspotData;
	import com.panozona.player.manager.data.panoramas.help.SURLLoader;
	import com.panozona.player.manager.utils.ImageCutter;
	import com.panozona.player.module.data.property.TextArg;
	import com.panozona.player.module.utils.Scale9BitmapSprite;
	import com.panozona.player.module.utils.ZLoader;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Rectangle;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;

	public class Hotspot extends ManagedChild {
		
		public var _text:String;
		public var _textarg:TextArg = null;
		public var _overalpha:Number = 1;
		public var _alpha:Number = 1;
		
		public var textSprite:Sprite = new Sprite();
		public var bgsprite:Sprite = new Sprite();
		public var styleContent:HotspotStyleContent;
		public var textField:TextField = new TextField();
		public var textFormat:TextFormat = new TextFormat();
		public var _hotspotData:HotspotData = null;
		
		public var sub_bgsprite:DisplayObject = null;
		public var sub_bg1sprite:DisplayObject = null;
		public var sub_bg2sprite:DisplayObject = null;
		
		public var origindisplayObject:DisplayObject;
		public var displayObject:DisplayObject;

		
		public function Hotspot(displayobject:DisplayObject = null,hotspotData:HotspotData = null):void {
			this.addEventListener(MouseEvent.MOUSE_OVER,hotmouseoverhandler);
			this.addEventListener(MouseEvent.MOUSE_OUT,hotmouseouthandler);
			this._hotspotData = hotspotData;
			this.origindisplayObject = displayobject;
			
			
			if(origindisplayObject == null)
			{
				return;
			}
			
		
			if(origindisplayObject is Bitmap){
				displayObject = new Bitmap((origindisplayObject as Bitmap).bitmapData.clone(),"auto",true);
				if(_hotspotData != null &&　_hotspotData.crop　!= "")
				{
					this.crop = _hotspotData.crop;
				}
				
				displayObject.x = -displayObject.width * 0.5;
				displayObject.y = -displayObject.height * 0.5;
			}
			else
			{
				displayObject = origindisplayObject;
			}
			addChild(displayObject);
		}
		
	
		
		public function get crop():String
		{
			return _hotspotData.crop;
		}
		
		public function set crop(crop:String):void
		{
			if(origindisplayObject is Bitmap){
				_hotspotData.crop = crop;
				
				var rectarr:Array = this._hotspotData.crop.split("|");
				var rect:Rectangle = new Rectangle(rectarr[0],rectarr[1],rectarr[2],rectarr[3]);
				var bd:BitmapData = ImageCutter.cutimg((origindisplayObject as Bitmap).bitmapData,rect);
				
				(displayObject as Bitmap).bitmapData = bd;
			}
			
		}
		private function hotmouseoverhandler(e:MouseEvent):void
		{
			this.alpha = _overalpha;
		}
		
		private function hotmouseouthandler(e:MouseEvent):void
		{
			this.alpha =  _alpha;
		}
		
		
		public function setoveralpha(alpha:Number):void
		{
			this._overalpha = alpha;
			
		}
		public function setalpha(alpha:Number):void
		{
			this._alpha = alpha;
			this.alpha = this._alpha;
		}
		
		public  function   settiptext(str:String,textarg:TextArg=null):void
		{
			this._text = str;
		    this._textarg = textarg;
			trace(" this._textargbg"+ this._textarg.bg);
			if(this._textarg.bg == "")
			{
				this.show();
			}
			else
			{
			
				if(this._textarg.bg.toLocaleLowerCase().indexOf("png") != -1)
				{
					(new ZLoader()).load(this._textarg.bg,null,function(e:Event){
						var bmd:BitmapData = (e.target.content as Bitmap).bitmapData;
						sub_bgsprite = new Bitmap(bmd,"auto",true);
						loadbgsuccess();
					});
				}
				
				(new ZLoader()).load(this._textarg.bg1,null,function(e:Event){
					var bmd:BitmapData = (e.target.content as Bitmap).bitmapData;
					sub_bg1sprite = new Bitmap(bmd,"auto",true);
					loadbgsuccess();
				});
				
				if(this._textarg.bg2 != "")
				{
					(new ZLoader()).load(this._textarg.bg2,null,function(e:Event){
						var bmd:BitmapData = (e.target.content as Bitmap).bitmapData;
						sub_bg2sprite = new Bitmap(bmd,"auto",true);
						loadbgsuccess();
					});
				}
			}
			
		}
		
		public function loadbgsuccess():void{
			if( (this._textarg.bg.toLocaleLowerCase().indexOf("png") == -1 || this.sub_bgsprite != null)
				&&
				this.sub_bg1sprite != null
				&&
				(this._textarg.bg2 == "" ||  this.sub_bg2sprite != null)
			)
			{
				show();
			}
		}
	
		
		
		
		public function show(e:Event=null):void
		{
			
			if(this._text == "" || this._text == null)
			{
				return;
			}
			if(this.contains(textSprite) || (bgsprite != null && this.contains(bgsprite))  )
			{
				return ;
			}
		
			
			
			
			textSprite.mouseEnabled = false;
			textSprite.mouseChildren = false;
			
			textField.defaultTextFormat = textFormat;
			textField.multiline = true;
			textField.selectable = false;
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.blendMode = BlendMode.NORMAL;
			textField.background = false;
			textField.antiAliasType = AntiAliasType.NORMAL;
			textSprite.addChild(textField);
			
			styleContent = new HotspotStyleContent();

			textFormat.font = styleContent.fontFamily;
			textFormat.size = this._textarg.fontsize;
			textFormat.color = 0xFFFFFF;
			textFormat.bold = this._textarg.fontblod;
	
			textField.defaultTextFormat = textFormat;
			textField.x = styleContent.bubblePadding;
			textField.y = styleContent.bubblePadding;
			textField.text = "";
			
			
			
			var array:Array = _text.split("[n]");
			for (var i:int = 0; i < array.length; i++) {
				textField.appendText(array[i]);
				if (i < array.length - 1) {
					textField.appendText("\n");
				}
			}
			
			var tw:Number = textField.width + styleContent.bubblePadding * 2;
			var th:Number = textField.height + styleContent.bubblePadding * 2;
			
			if(this._textarg.bg == "")
			{
				textSprite.graphics.clear();
				textSprite.graphics.lineStyle(styleContent.borderSize, styleContent.borderColor);
				textSprite.graphics.beginFill(styleContent.bubbleColor);
				textSprite.graphics.drawRoundRect(0, 0,
					tw,
					th,
					styleContent.borderRadius);
				textSprite.graphics.endFill();
				textSprite.alpha=styleContent.alpha;
				
				
				//路径
				textSprite.x = -textSprite.width/2;
				textSprite.y = -textSprite.height - 5;
				this.addChild(textSprite);
			}
			else
			{
				
				
				var bgwidth:Number = this._textarg.bg1w + this._textarg.bg1padding +  this._textarg.bg2padding;
				if(this.sub_bg2sprite != null)
				{
					bgwidth = bgwidth + this._textarg.bg2w ; 
				}
				
				
				bgsprite.graphics.clear();
				bgsprite.graphics.beginFill(0x00000,0);
				bgsprite.graphics.drawRect(0,0,tw +  bgwidth,this._textarg.bgh);
				bgsprite.graphics.endFill();

				if(this.sub_bgsprite== null)
				{
					bgsprite.graphics.clear();
					bgsprite.graphics.beginFill(Number(this._textarg.bg),this._textarg.bgaplah);
					bgsprite.graphics.lineStyle(this._textarg.bgborder,this._textarg.bgbordercolor,this._textarg.bgborderalpha);
					bgsprite.graphics.drawRoundRect(0,0,tw +  bgwidth,this._textarg.bgh,this._textarg.bgradius);
					bgsprite.graphics.endFill();
				}
				else
				{
					this.sub_bgsprite.width = bgsprite.width;
					this.sub_bgsprite.height = bgsprite.height;
					bgsprite.addChild(this.sub_bgsprite);
				}
				
				bgsprite.addChild(this.sub_bg1sprite);
				
				textSprite.x =this._textarg.bg1w + this._textarg.bg1padding;
				textSprite.y = this._textarg.texttop;
				bgsprite.addChild(textSprite);
				
				if(this.sub_bg2sprite != null)
				{
					this.sub_bg2sprite.x  =  bgsprite.width - this.sub_bg2sprite.width;
					bgsprite.addChild(this.sub_bg2sprite);
				}
				
				
				
				
				bgsprite.x = -bgsprite.width/2;
				bgsprite.y = -bgsprite.height - 0 - this._textarg.h;
				this.addChild(bgsprite);
			}
		}
		
		
	}
}
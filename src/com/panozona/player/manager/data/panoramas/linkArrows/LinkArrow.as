package com.panozona.player.manager.data.panoramas.linkArrows
{
	import flash.display.BlendMode;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.BevelFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BitmapFilterType;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import morn.core.components.Component;
	
	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-3-18 上午9:56:31
	 * 功能描述:
	 */
	public class LinkArrow extends Component
	{
		
		private var obj:Sprite;
		
		public var pid:String;
		
		/**
		 * 关联箭头的样式
		 * 0：尖角
		 * 1：带柄箭头
		 */	
		private var drawType:int=0;
		
		public var title:String;
		
		public var isedit:Number = 0;
		
//		public var txt_title:TextField;
//		
//		public var txt_title_sp:Sprite;
		
		public function LinkArrow(pid:String,title:String,drawType:int=0,isedit:Number = 0)
		{
			super();
			this.pid = pid;
			this.title = title;
			this.drawType = drawType;
			this.isedit = isedit;
			obj = getupdirectsprite();
			addChild(obj);
			
			toolTip = title;
//			txt_title_sp = new Sprite();
//			addChild(txt_title_sp);
//			txt_title = getText(title,0xffffff,20);
//			txt_title.filters = [new GlowFilter(0x000000,1,2,2,5)];
//			txt_title_sp.addChild(txt_title);
//			txt_title.x = -txt_title.textWidth/2;
//			txt_title.y = -txt_title.textHeight/2;
//			txt_title_sp.rotationX = 90;
//			
//			txt_title_sp.mouseEnabled = txt_title_sp.mouseChildren = false;
//			txt_title.mouseEnabled = txt_title.mouseEnabled = false;
//			
//			txt_title_sp.visible = false;
		}
		
		private var bevel:BevelFilter;
		private var bevel2:BevelFilter;
		
		private var r1:Number = 52;
		private var r2:Number = 14;
		private function getupdirectsprite():Sprite
		{
			
			var obj:Sprite = new Sprite();
			obj.graphics.clear();
			var graphics:Graphics = obj.graphics;
			var bcolor:Number = 0xFFFFFF;
			if(this.isedit == 1)
			{
				bcolor = 0xffff00;
			}
			if(drawType == 0){
				graphics.lineStyle(1,0,0.5);
				graphics.beginFill(bcolor,0.8);
				graphics.moveTo(0,-r1);
				graphics.lineTo(0,0);
				graphics.lineTo(r1,0);
				graphics.lineTo(r1,-r2);
				graphics.lineTo(r2,-r2);
				graphics.lineTo(r2,-r1);
				graphics.lineTo(0,-r1);
				graphics.endFill();
				obj.rotation = 135;
			}else{
				graphics.lineStyle(3,0x666666,1);
				graphics.beginFill(0xf6f6f6,0.8);
				graphics.moveTo(-35,-20);
				graphics.lineTo(0,-20);
				graphics.lineTo(0,-42);
				graphics.curveTo(2,-45,4,-45);
				graphics.lineTo(48,-2);
				graphics.curveTo(50,0,48,2);
				graphics.lineTo(4,45);
				graphics.curveTo(2,45,0,42);
				graphics.lineTo(0,20);
				graphics.lineTo(-35,20);
				graphics.lineTo(-35,-20);
				graphics.endFill();
				obj.rotation = -90;
			}
			
			
			
//			graphics.beginFill(0xFF0000,0.9);
//			graphics.drawCircle(0,0,3);
//			graphics.endFill();
			
//			var graphics:Graphics = obj.graphics;
//			graphics.lineStyle(0,0,0x999999);
//			graphics.beginFill(0xFFFFFF,0.9);
//			graphics.moveTo(-50,-25);
//			graphics.lineTo(0,-25);
//			graphics.lineTo(0,-50);
//			graphics.lineTo(50,0);
//			graphics.lineTo(0,50);
//			graphics.lineTo(0,25);
//			graphics.lineTo(-50,25);
//			graphics.lineTo(-50,-25);
//			graphics.endFill();
//			obj.rotation = -90;
//			
//			
//			graphics.beginFill(0xFF0000,0.9);
//			graphics.drawCircle(0,0,3);
//			graphics.endFill();
			
//			bevel= new BevelFilter(); 
//			bevel.distance = 3; 
//			bevel.angle = 45; 
//			bevel.highlightColor = 0x000000; 
//			bevel.highlightAlpha = 0.2; 
//			bevel.shadowColor = 0x000000; 
//			bevel.shadowAlpha = 0.2; 
//			bevel.blurX = 5; 
//			bevel.blurY = 5; 
//			bevel.strength = 2; 
//			bevel.quality = BitmapFilterQuality.HIGH; 
//			bevel.type = BitmapFilterType.OUTER; 
//			bevel.knockout = false; 
//			
//			bevel2 = new BevelFilter(); 
//			bevel2.distance = 3; 
//			bevel2.angle = -45; 
//			bevel2.highlightColor = 0x000000; 
//			bevel2.highlightAlpha = 0.2;  
//			bevel2.shadowColor = 0x000000; 
//			bevel2.shadowAlpha = 0.2;  
//			bevel2.blurX = 2; 
//			bevel2.blurY = 2; 
//			bevel2.strength = 2; 
//			bevel2.quality = BitmapFilterQuality.HIGH; 
//			bevel2.type = BitmapFilterType.OUTER; 
//			bevel2.knockout = false; 
//			
//			obj.filters = [bevel,bevel2];
//			
//			obj.filters = [bevel];
			
			obj.filters = [dropShadowFilter];
			
			
			
			obj.addEventListener(MouseEvent.MOUSE_OVER,objmouseoverhandler);
			obj.addEventListener(MouseEvent.MOUSE_OUT,objmouseouthandler);
			
			
			return obj;
		}
		
		private var dropShadowFilter:DropShadowFilter = new DropShadowFilter(4,45,0x000000,0.5);
		
		private function objmouseoverhandler(e:MouseEvent):void
		{
			
//			txt_title_sp.visible = true;
			
			e.preventDefault();
			
			var obj:Sprite = e.target as Sprite;
			
			var gr:GlowFilter;
			
			if(drawType == 1){//箭头
				obj.graphics.clear();
				obj.graphics.lineStyle(3,0x0033ff,0.7);
				obj.graphics.beginFill(0xf6f6f6,1);
				obj.graphics.moveTo(-35,-20);
				obj.graphics.lineTo(0,-20);
				obj.graphics.lineTo(0,-42);
				obj.graphics.curveTo(2,-45,4,-45);
				obj.graphics.lineTo(48,-2);
				obj.graphics.curveTo(50,0,48,2);
				obj.graphics.lineTo(4,45);
				obj.graphics.curveTo(2,45,0,42);
				obj.graphics.lineTo(0,20);
				obj.graphics.lineTo(-35,20);
				obj.graphics.lineTo(-35,-20);
				obj.graphics.endFill();
				obj.rotation = -90;		
				gr = new GlowFilter(0x397ddb,0.8,12,12);
				obj.filters = [gr];
				return;
			}
			gr = new GlowFilter(0x397ddb,0.8,10,10);
	//		obj.filters = [bevel,bevel2,gr];
	//		obj.filters = [gr];
			obj.filters = [dropShadowFilter,gr];
			
			
		}
		private function objmouseouthandler(e:MouseEvent):void
		{
			e.preventDefault();
			
			var obj:Sprite = e.target as Sprite;
			
			if(drawType == 1){//箭头
				obj.graphics.clear();
				obj.graphics.lineStyle(3,0x666666,1);
				obj.graphics.beginFill(0xf6f6f6,0.8);
				obj.graphics.moveTo(-35,-20);
				obj.graphics.lineTo(0,-20);
				obj.graphics.lineTo(0,-42);
				obj.graphics.curveTo(2,-45,4,-45);
				obj.graphics.lineTo(48,-2);
				obj.graphics.curveTo(50,0,48,2);
				obj.graphics.lineTo(4,45);
				obj.graphics.curveTo(2,45,0,42);
				obj.graphics.lineTo(0,20);
				obj.graphics.lineTo(-35,20);
				obj.graphics.lineTo(-35,-20);
				obj.graphics.endFill();
				obj.rotation = -90;
			}
			
			obj.filters = [dropShadowFilter];
	//		obj.filters = [bevel,bevel2];
	//		obj.filters = [];
	//		txt_title_sp.visible = false;
		}
		
		public function destroy():void{
			if(obj){
				obj.removeEventListener(MouseEvent.MOUSE_OVER,objmouseoverhandler);
				obj.removeEventListener(MouseEvent.MOUSE_OUT,objmouseouthandler);
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
	}
}
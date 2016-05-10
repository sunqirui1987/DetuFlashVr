package com.panozona.player.manager.data.streetview
{
	import com.panosalado.view.ManagedChild;
	import com.panozona.player.manager.StreetManager;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BevelFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BitmapFilterType;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	
	public class StreeviewArrow extends ManagedChild
	{
		
		
		private var _streetmanager:StreetManager;
		private var _updirect:Number=0;
		private var _oldpan:Number = -1;
		
		
		private var subchildsprite:Vector.<Sprite> = new Vector.<Sprite>();
		
		
		
		
		public function StreeviewArrow(streetmanager:StreetManager)
		{
			_streetmanager = streetmanager;
			
			//开始侦听
			this.addEventListener(Event.ENTER_FRAME,enterframeHandler);
			
			this.update();
		}
		
		private function enterframeHandler(e:Event):void
		{
			if(this._streetmanager.currentPanoramaData != null)
			{
				if( this._streetmanager.pan != this._oldpan)
				{
					this._oldpan = this._streetmanager.pan ;
					
					for(var i:Number=0;i<subchildsprite.length;i++)	
					{
						if(i >= this._streetmanager.directionarrowarr.length ){ break; }
						
						var arrowdata:StreetviewArrowData =this._streetmanager.directionarrowarr[i];
						if(arrowdata == null){ break;}
						
						var txtsprite:Sprite = subchildsprite[i];
						var rz:Number = this._streetmanager.pan +  arrowdata.txtdirect ;
						trace("arrowdata.txtdirect"+arrowdata.txtdirect);
						txtsprite.rotationX = 90;
						txtsprite.rotationZ =  (rz + arrowdata.direct + 360) % 360 ;
						
					}
					
				}
			}
		}
		
		
		public function update():void	
		{
			//清空状态
			while(this.numChildren > 0)
			{
				this.removeChildAt(0);
			}
			subchildsprite = new Vector.<Sprite>();
			//direction  North is 0, East is 90 South is 180, West is 270
			for(var i:Number = 0; i < this._streetmanager.directionarrowarr.length; i++)
			{
				var arrowdata:StreetviewArrowData = this._streetmanager.directionarrowarr[i];
				//方向定点
				var obj:Sprite =getupdirectsprite();
				
				var newobj:Sprite = new Sprite();
				newobj.alpha = 1;
				newobj.addChild(obj);
				newobj.rotation =  arrowdata.direct;
				newobj.x = Math.sin(newobj.rotation  * Math.PI / 180) * 100;//(this.width - obj.width) / 2;
				newobj.y = -Math.cos(newobj.rotation * Math.PI / 180) * 100;
				newobj.z = 0;
				
				trace("streetview --- > "+arrowdata.text+":"+arrowdata.direct+":"+newobj.rotation)
				
				
				var textFormat:TextFormat = new TextFormat();
				textFormat.font = "微软雅黑";
				textFormat.size = 14;
				textFormat.color = 0xFFFFFF;
				textFormat.bold = false;
				
				
				
				var textField:TextField = new TextField();
				textField.defaultTextFormat = textFormat;
				textField.multiline = false;
				textField.selectable = false;
				textField.autoSize = TextFieldAutoSize.CENTER;
				textField.blendMode = BlendMode.LAYER;
				textField.background = false;
				textField.antiAliasType = AntiAliasType.ADVANCED;
				
				
				textField.mouseEnabled=false;
				textField.text = arrowdata.text;
				
				var gr:GlowFilter = new GlowFilter(0x000000,0.8,3,3,5);
				textField.filters = [gr];
				
				var txtSprite:Sprite = new Sprite();
				txtSprite.addChild(textField);
				txtSprite.mouseEnabled = false;
				
				
				textField.x = -textField.width / 2;
				textField.y = -textField.height / 2;
				
				
				subchildsprite.push(txtSprite);
				
				newobj.addChild(txtSprite);
				
				this.addChild(newobj);
				newobj.buttonMode = true;
				newobj.useHandCursor = true;
				newobj.addEventListener(MouseEvent.CLICK,create(newobjClickHandler,arrowdata));
				newobj.addEventListener(MouseEvent.MOUSE_OVER,newobjMouseOverHandler);
				newobj.addEventListener(MouseEvent.MOUSE_OUT,newobjMouseOUTHandler);
				
			}
			
			
			
			
			
		}
		private function newobjMouseOverHandler(e:MouseEvent):void
		{
			
			var obj:Sprite = e.currentTarget as Sprite;
			obj.parent.setChildIndex(obj,obj.parent.numChildren -1);
		}
		private function newobjMouseOUTHandler(e:MouseEvent):void
		{
			
			
		}
		private function newobjClickHandler(e:MouseEvent,... arg):void
		{
			e.preventDefault();
			var arrowdata:StreetviewArrowData = arg[0] as StreetviewArrowData;
			
			_streetmanager.loadStreetviewPano(arrowdata.panoid);
		}
		
		public  function create(f:Function,... arg):Function {
			var F:Boolean=false;
			var _f:Function=function(e:*,..._arg):void{
				_arg=arg
				if(!F){
					F=true
					_arg.unshift(e)}
				f.apply(null,_arg)
			};
			return _f;
		}
		
		
		private var bevel:BevelFilter;
		private var bevel2:BevelFilter;
		private function getupdirectsprite():Sprite
		{
			
			var obj:Sprite = new Sprite();
			obj.graphics.clear();
			var graphics:Graphics = obj.graphics;
			graphics.lineStyle(0,0,0x999999);
			graphics.beginFill(0xFFFFFF,0.9);
			graphics.moveTo(-50,-25);
			graphics.lineTo(0,-25);
			graphics.lineTo(0,-50);
			graphics.lineTo(50,0);
			graphics.lineTo(0,50);
			graphics.lineTo(0,25);
			graphics.lineTo(-50,25);
			graphics.lineTo(-50,-25);
			graphics.endFill();
			obj.rotation = -90;
			
			
			
			
			bevel= new BevelFilter(); 
			bevel.distance = 5; 
			bevel.angle = 45; 
			bevel.highlightColor = 0xcccccc; 
			bevel.highlightAlpha = 0.2; 
			bevel.shadowColor = 0xcccccc; 
			bevel.shadowAlpha = 0.6; 
			bevel.blurX = 5; 
			bevel.blurY = 5; 
			bevel.strength = 5; 
			bevel.quality = BitmapFilterQuality.HIGH; 
			bevel.type = BitmapFilterType.INNER; 
			bevel.knockout = false; 
			
			bevel2 = new BevelFilter(); 
			bevel2.distance = 5; 
			bevel2.angle = -45; 
			bevel2.highlightColor = 0xcccccc; 
			bevel2.highlightAlpha = 0.2;  
			bevel2.shadowColor = 0xcccccc; 
			bevel2.shadowAlpha = 0.6;  
			bevel2.blurX = 5; 
			bevel2.blurY = 5; 
			bevel2.strength = 5; 
			bevel2.quality = BitmapFilterQuality.HIGH; 
			bevel2.type = BitmapFilterType.INNER; 
			bevel2.knockout = false; 
			
			obj.filters = [bevel,bevel2];
			
			obj.addEventListener(MouseEvent.MOUSE_OVER,objmouseoverhandler);
			obj.addEventListener(MouseEvent.MOUSE_OUT,objmouseouthandler);
			
			
			return obj;
		}
		
		private function objmouseoverhandler(e:MouseEvent):void
		{
			e.preventDefault();
			
			var obj:Sprite = e.target as Sprite;
			
			
			var gr:GlowFilter = new GlowFilter(0x0033ff,0.8,10,10);
			obj.filters = [bevel,bevel2,gr];
			
		}
		private function objmouseouthandler(e:MouseEvent):void
		{
			e.preventDefault();
			
			var obj:Sprite = e.target as Sprite;
			
			obj.filters = [bevel,bevel2];
		}
	}
}
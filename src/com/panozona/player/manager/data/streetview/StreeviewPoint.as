package com.panozona.player.manager.data.streetview
{


	import com.panozona.player.manager.StreetManager;
	
	import flash.display.BlendMode;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;



	public class StreeviewPoint extends Sprite
	{

		private var _streetmanager:StreetManager;
		private var textField:TextField ;
		private var _c_innercanvas:Sprite = new Sprite();
		
		
		private var _distance:Number;
		private var _mousepoint:Point = new Point();

		
		public function StreeviewPoint(streetmanager:StreetManager)
		{
			this._streetmanager = streetmanager;
			this._streetmanager.addEventListener(Event.ENTER_FRAME,enterframeHandler);
			
			//var ma:Matrix3D = new Matrix3D();
			//ma.appendRotation(90,Vector3D.X_AXIS);
			//this.transform.matrix3D = ma;
			
			this._c_innercanvas.graphics.clear();
			var g:Graphics = this._c_innercanvas.graphics;
			g.lineStyle(2,0xFFFFFF,1);
			g.beginFill(0xFFFFFF,0.3);
			g.drawCircle(0,0,25);
			g.endFill();
			this.addChild(this._c_innercanvas);
			
			var _c_innercanvasma:Matrix3D = new Matrix3D();
			_c_innercanvasma.appendRotation(-90,Vector3D.X_AXIS);
			_c_innercanvasma.appendRotation(-5,Vector3D.Z_AXIS);
			_c_innercanvas.transform.matrix3D = _c_innercanvasma;
			
			var textFormat:TextFormat = new TextFormat();
			textFormat.font = "微软雅黑";
			textFormat.size = 12;
			textFormat.color = 0xFFFFFF;
			textFormat.bold = true;
			
			
			textField = new TextField();
			textField.alpha = 0.8;
			textField.defaultTextFormat = textFormat;
			textField.multiline = false;
			textField.selectable = false;
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.blendMode = BlendMode.LAYER;
			textField.background = false;
			textField.antiAliasType = AntiAliasType.ADVANCED;
			var gr:GlowFilter = new GlowFilter(0x000000,0.8,3,3,5);
			textField.filters = [gr];
			
			textField.x = 0;
			textField.y = -24;
			textField.mouseEnabled=false;
			textField.text = "";
			
			
			this.addChild(textField);
			
			this._c_innercanvas.addEventListener(MouseEvent.MOUSE_DOWN,loadpanodownhandler);
			this._c_innercanvas.addEventListener(MouseEvent.MOUSE_UP,loadpanouphandler);

		}
		
		private function loadpanodownhandler(e:MouseEvent):void	
		{
			_mousepoint = new Point(this._streetmanager.mouseX,this._streetmanager.mouseY);
		}
		private function loadpanouphandler(e:MouseEvent):void	
		{
			var upmousepoint:Point = new Point(this._streetmanager.mouseX,this._streetmanager.mouseY);
			
			if(Math.abs(upmousepoint.x - _mousepoint.x) < 2 && Math.abs(upmousepoint.y - _mousepoint.y) < 2)
			{
				var currentdirection:Number = this._streetmanager.currentPanoramaData.direction;
				var tmpdir:Number = validateDir(this._streetmanager.pan + currentdirection);
			
				this._streetmanager.loadStreetviewPano(this._streetmanager.currentPanoramaData.id,"",tmpdir,this._distance);
			}
			
		}
		
		private function validateDir(value:Number):Number {
			if ( value <= 0 || value > 360 ) return ((value + 360) % 360);
			return value;
		}
		
		private function enterframeHandler(e:Event):void
		{
			var ctilt:Number = getCursorTilt();
			var cpan:Number = getCursorPan();
			if(ctilt > 10)
			{
				this.visible = false;
				return;
			}
			var rzft:Number = 0;
			rzft = (this._streetmanager.tilt - 0 ) * 10;
			//trace(this._streetmanager._boundsHeight +"-"+ rzft);
			if(this._streetmanager.mouseY > this._streetmanager._boundsHeight - 220 + rzft)
			{
				this.visible = false;
				return;
			}
			
			if(this._streetmanager.mouseY > this._streetmanager._boundsHeight * 4 / 9)
			{
				this._distance = 10;
			}
			else if(this._streetmanager.mouseY > this._streetmanager._boundsHeight * 3 / 9)
			{
				this._distance = 20;
			}
			else if(this._streetmanager.mouseY > this._streetmanager._boundsHeight * 2 / 9)
			{
				this._distance = 30;
			}

			var textstr:String = "";
			if(this._distance != 0)
			{
				textstr = "向前"+this._distance+"米";
			}
			textField.text = textstr;
			
			
			//_c_innercanvas.rotationZ =  this._streetmanager.tilt;
			if( this._streetmanager.tilt <= 0)
			{
				_c_innercanvas.rotationX =  80;
			}
			else if( this._streetmanager.tilt > 0)
			{
				_c_innercanvas.rotationX =  80 - this._streetmanager.tilt * 2 ;
			}
		
			
			this.visible = true;
			this.x = this._streetmanager.mouseX;
			this.y = this._streetmanager.mouseY;
			
			
			
			
		}
		
		private var __toDegrees:Number = 180 / Math.PI;
		private var __toRadians:Number = Math.PI / 180;
		private function validatePanTilt(value:Number):Number {
			if (value <= -180) value = (((value + 180) % 360) + 180);
			if (value > 180) value = (((value + 180) % 360) - 180);
			return value;
		}
		private function getCursorPan():Number {
			return validatePanTilt( this._streetmanager._pan +
				Math.atan((this.mouseX - this._streetmanager.boundsWidth * 0.5)
					* Math.tan(this._streetmanager.fieldOfView * 0.5 * __toRadians) / (this._streetmanager.boundsWidth * 0.5)) * __toDegrees);
		}
		
		private var verticalFieldOfView:Number
		private function getCursorTilt():Number {
			verticalFieldOfView =  __toDegrees * 2 * Math.atan((this._streetmanager.boundsHeight / this._streetmanager.boundsWidth) * Math.tan(__toRadians * 0.5 * this._streetmanager.fieldOfView));
			
			var ti:Number = this._streetmanager._tilt -
				Math.atan(( this._streetmanager.mouseY - this._streetmanager.boundsHeight * 0.5)
					* Math.tan(verticalFieldOfView * 0.5 * __toRadians) / (this._streetmanager.boundsHeight * 0.5)) * __toDegrees;
			
			return validatePanTilt(ti );
		}
		
	}
}
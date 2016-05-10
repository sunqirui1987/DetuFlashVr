package com.panozona.modules.ouweijt.view
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-4-15 上午10:50:46
	 * 功能描述:
	 */
	public class RadioButton extends Sprite
	{
		
		private var tipSpriteTextfiled:TextField;
		
		private var mouseHandle:Function;
		
		private var _isSelected:Boolean;
		
		private var bigRadius:Number = 7;
		
		private var smallRadius:Number = 5;
		
		private var sp:Sprite;
		
		public function RadioButton(parent:Sprite,x:Number,y:Number,label:String='',_isSelected:Boolean=false,mouseHandle:Function=null)
		{
			super();
			
			this.x = x;
			this.y = y;
			this.mouseHandle = mouseHandle;
			this._isSelected = _isSelected;
			if(parent)
				parent.addChild(this);
			
			sp = new Sprite();
			addChild(sp);
			
			var format1:TextFormat=new TextFormat();
			format1.bold=true;
			format1.align=TextFormatAlign.CENTER;
			format1.color=0xffffff;
			format1.size=16;
			
			tipSpriteTextfiled  = new TextField();
			tipSpriteTextfiled.text=label;
			tipSpriteTextfiled.x = 20;
			tipSpriteTextfiled.setTextFormat(format1);
			draw();
			
			sp.x = bigRadius;
			sp.y = bigRadius;
			sp.buttonMode = true;
			sp.addEventListener(MouseEvent.CLICK,onClick);
		}
		
		protected function onClick(event:MouseEvent):void
		{
			var temp:Boolean = !isSelected;
			if(!temp)
				return;
			isSelected = temp;
			if(temp){
				for(var i:int=0;i<parent.numChildren;i++){
					var tempSp:* = parent.getChildAt(i);
					if(tempSp is RadioButton && tempSp != this){
						tempSp.isSelected = !temp;
					}
				}
			}
			if(mouseHandle != null){
				mouseHandle(event);
			}
		}
		
		private function draw():void{
			sp.graphics.clear();
			sp.graphics.lineStyle(1,1);
			sp.graphics.drawCircle(0,0,bigRadius);
			if(_isSelected){
				sp.graphics.beginFill(1,1);
				sp.graphics.drawCircle(0,0,smallRadius);
				sp.graphics.endFill();
			}else{
				sp.graphics.lineStyle(1,0);
				sp.graphics.beginFill(1,0);
				sp.graphics.drawCircle(0,0,smallRadius);
				sp.graphics.endFill();
			}
		}
		
		public function set isSelected(_isSelected:Boolean):void{
			this._isSelected = _isSelected;
			draw();
		}
		
		public function get isSelected():Boolean{
			return this._isSelected;
		}
	}
}
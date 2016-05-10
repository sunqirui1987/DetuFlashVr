package com.panozona.modules.guide.view
{
	import com.panozona.modules.guide.model.GuideData;
	import com.panozona.player.module.utils.Scale9BitmapSprite;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import caurina.transitions.Tweener;

	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-9-4 上午11:26:45
	 * 功能描述:
	 */
	public class GuideView extends Sprite
	{
		
		private var guideData:GuideData;
		
		private var textField:TextField;
		
		private var bg:Loader;
		
		private var isMoving:Boolean;
		
		private var dir:String;
		
		private var back:Scale9BitmapSprite;
		
		private var initX:Number;
		private var initY:Number;
		
		private var toX:Number;
		private var toY:Number;
		
		public function GuideView(guideData:GuideData)
		{
			this.guideData = guideData;
			
			this.mouseEnabled = false;//不允许此组件接收鼠标消息
			
			bg = new Loader();
			bg.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoadFinish);
			addChild(bg);
			
			textField = new TextField();
			textField.selectable = false;//不允许文本被选择
			textField.multiline = true;//允许文本多行
			textField.wordWrap = true;//让文本自动换行
			var format:TextFormat = new TextFormat('宋体',12);
			format.color = 0xffff00;
			format.align = TextFormatAlign.CENTER;
			textField.defaultTextFormat = format;
			//			textField.x=5;
			//			textField.y=5;
			textField.filters=  [new GlowFilter(0x000000,1,2,2,5)];
			
			addChild( textField );
			
			this.visible = false;
			
			this.mouseEnabled = this.mouseChildren = false;
			
			this.cacheAsBitmap = true;
		}
		
		protected function onLoadFinish(event:Event):void
		{
			//			textField.x = (bg.width-textField.width)/2 ;
			//			textField.y = (bg.height-textField.height)/2;
		}
		
		private var moveArea:Number = 5;
		
		public function setData(parent:DisplayObjectContainer, value:String ,dir:String="up",initX:Number=0,initY:Number=0,picUlr:String=""):void{
			if(parent)
				parent.addChild(this);
			
			textField.text="";
			textField.width=0;
			textField.height=25;
			
			textField.text = value;
			
			textField.width=100;
			
			this.initX = initX;
			this.initY = initY;
			
			x = initX;
			y = initY;
			
			var url:String;
			
			switch(dir){
				case "up":
					//	bg.source = Configs.PIC_URL+'guide/guide1.png';
					url = guideData.setting.upUrl;
					toX = initX;
					toY = initY-moveArea;
					textField.x = 18;
					textField.y = 54;
					
					break;
				case "down":
					//	bg.source = Configs.PIC_URL+'guide/guide2.png';
					url = guideData.setting.downUrl;
					toX = initX;
					toY = initY+moveArea;
					textField.x = 18;
					textField.y = 25;
					break;
				case "left":
					//	bg.source = Configs.PIC_URL+'guide/guide3.png';
					url = guideData.setting.leftUrl;
					toX = initX-moveArea;
					toY = initY;
					textField.x = 45;
					textField.y = 25;
					break;
				case "right":
					//	bg.source = Configs.PIC_URL+'guide/guide4.png';
					url = guideData.setting.rightUrl;
					toX = initX+moveArea;
					toY = initY;
					textField.x = 15;
					textField.y = 25;
					break;
			}
			//			textField.x = (bg.width-textField.width)/2 ;
			//			textField.y = (bg.height-textField.height)/2;
			this.dir = dir;
			
			this.x = initX;
			this.y = initY;
			if(picUlr)
				url = picUlr;
			bg.load(new URLRequest(url),new LoaderContext(true));
		}
		
		private var _isShow:Boolean;
		
		public function get isShow():Boolean{
			return _isShow;
		}
		
		public function set isShow(_isShow:Boolean):void{
			this._isShow = _isShow;
			visible = _isShow;
			if(_isShow){
				if(parent)
					parent.setChildIndex(this,parent.numChildren-1);
				if(!isMoving){
					isMoving = true;
					doMove();
				}
			}
				
			else{
				if(isMoving)
					isMoving = false;
			}
		}
		
		private function doMove():void
		{
			// TODO Auto Generated method stub 
			if(!isMoving)
				return;
			if(parent)
				parent.setChildIndex(this,parent.numChildren-1);
			Tweener.addTween(this,{time:1,x:toX,y:toY,onComplete:function():void{
				x = initX;
				y = initY;
				doMove();
			}});
		}
	}
}
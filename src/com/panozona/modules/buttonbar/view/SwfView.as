package com.panozona.modules.buttonbar.view
{
	import com.panozona.modules.buttonbar.model.ButtonBarData;
	import com.panozona.modules.buttonbar.model.structure.SwfViewDataItem;
	import com.panozona.player.module.data.property.Align;
	import com.panozona.player.module.data.property.Size;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	
	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-8-20 上午8:52:45
	 * 功能描述:
	 */
	public class SwfView extends Sprite
	{
		
		private var _buttonBarData:ButtonBarData;
		
		public var mc_compass:MovieClip;
		public var mc_mouseScroll:MovieClip;
		public var mc_fullScene:MovieClip;
		public var mc_music:MovieClip;
		
		public var  btn_up:SimpleButton;
		public var  btn_left:SimpleButton;
		public var  btn_down:SimpleButton;
		public var  btn_right:SimpleButton;
		public var  btn_reset:SimpleButton;
		
		public var  btn_forward:SimpleButton;
		public var  btn_back:SimpleButton;
		
		public var mc_back:MovieClip;
		
		
		public function SwfView(_buttonBarData:ButtonBarData)
		{
			super();
			this._buttonBarData = _buttonBarData;
		}
		
		public function get buttonBarData():ButtonBarData{
			return _buttonBarData;
		}
		
		public function createUI(content:Sprite):void{
			mc_compass = content.getChildByName("mc_compass") as MovieClip;
			mc_mouseScroll = content.getChildByName("mc_mouseScroll") as MovieClip;
			mc_fullScene = content.getChildByName("mc_fullScene") as MovieClip;
			mc_music = content.getChildByName("mc_music") as MovieClip;
			
			if(mc_compass){
				var item:SwfViewDataItem = _buttonBarData.swfViewData.getSwfViewDataItemById("mc_compass");
				if(item){
					addChild(mc_compass);
				}
				btn_up = mc_compass.getChildByName("btn_up") as SimpleButton;
				btn_left = mc_compass.getChildByName("btn_left") as SimpleButton;
				btn_down = mc_compass.getChildByName("btn_down") as SimpleButton;
				btn_right = mc_compass.getChildByName("btn_right") as SimpleButton;
				btn_reset = mc_compass.getChildByName("btn_reset") as SimpleButton;
				
				mc_back = mc_compass.getChildByName("mc_back") as MovieClip;
			}
			
			if(mc_mouseScroll){
				item = _buttonBarData.swfViewData.getSwfViewDataItemById("mc_mouseScroll");
				if(item){
					addChild(mc_mouseScroll);
				}
				btn_forward = mc_mouseScroll.getChildByName("btn_forward") as SimpleButton;
				btn_back = mc_mouseScroll.getChildByName("btn_back") as SimpleButton;
			}
			
			if(mc_fullScene){
				item = _buttonBarData.swfViewData.getSwfViewDataItemById("mc_fullScene");
				if(item){
					addChild(mc_fullScene);
				}
				mc_fullScene.gotoAndStop(1);
			}
			
			if(mc_music){
				item = _buttonBarData.swfViewData.getSwfViewDataItemById("mc_music");
				if(item){
					addChild(mc_music);
				}
				mc_music.gotoAndStop(1);
			}
			
			showAlign();
		}
		
		private function showAlign():void
		{
			var nowY:Number = 0;
			var maxW:Number = 0;
			for(var i:int=0,n:int=numChildren;i<n;i++){
				var mc:MovieClip = getChildAt(i) as MovieClip;
				if(mc && mc.width>maxW){
					maxW = mc.width;
				}
			}
			
			for(i=0,n=numChildren;i<n;i++){
				mc = getChildAt(i) as MovieClip;
				if(mc){
					mc.y = nowY;
					nowY += mc.height;
					var item:SwfViewDataItem  = _buttonBarData.swfViewData.getSwfViewDataItemById(mc.name);
					if(item){
						nowY += item.gap;
						mc.y += item.move.vertical;
					}
					mc.x = (maxW-mc.width)*0.5+item.move.horizontal;
				}
	//			trace("name="+mc.name+" x="+mc.x+" y="+mc.y +" w="+mc.width+" h="+mc.height);
			}
			_buttonBarData.windowData.size = new Size(maxW,nowY);
		}
	}
}
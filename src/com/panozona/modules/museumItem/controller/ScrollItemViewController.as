package com.panozona.modules.museumItem.controller
{
	import com.panozona.modules.museumItem.event.MuseumItemEvent;
	import com.panozona.player.module.utils.ShineControler;
	import com.panozona.player.module.utils.ZLoader;
	import com.panozona.modules.museumItem.view.ScrollItemView;
	import com.panozona.player.module.Module;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;

	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-7-21 下午4:54:19
	 * 功能描述:
	 */
	public class ScrollItemViewController
	{
		
		private var module:Module;
		
		private var scrollItemView:ScrollItemView;
		
		public function ScrollItemViewController(scrollItemView:ScrollItemView,module:Module)
		{
			this.module = module;
			this.scrollItemView = scrollItemView;
			if(scrollItemView.itemData.picUrl)
				new ZLoader().load(scrollItemView.itemData.picUrl,errFun,loadFinish);
			
			scrollItemView.museumItemData.addEventListener(MuseumItemEvent.SELECT_NEW_MUSEUM_ITEM,onSelectd);
		}
		
		protected function onSelectd(event:Event):void
		{
			if(scrollItemView.museumItemData.selectItem == scrollItemView.itemData){
				scrollItemView.filters = [new GlowFilter(0xffffff,1,scrollItemView.museumItemData.scrollData.gap,scrollItemView.museumItemData.scrollData.gap,1)];
			}else{
				scrollItemView.filters = [];
			}
		}
		
		private function errFun(event:IOErrorEvent):void
		{
			module.printError(event.text);
		}
		
		protected function onMouseHandle(event:MouseEvent):void
		{
			switch(event.type){
				case MouseEvent.ROLL_OVER:
					ShineControler.setBrightness(scrollItemView,0.05);
					break;
				case MouseEvent.ROLL_OUT:
					ShineControler.setBrightness(scrollItemView,0);
					break;
				case MouseEvent.CLICK:
					scrollItemView.museumItemData.selectItem = scrollItemView.itemData;
					break;
			}
		}
		
		private function loadFinish(event:Event):void
		{
			var baseBmt:BitmapData = (event.target.content as Bitmap).bitmapData.clone();
			var bmd:Bitmap = new Bitmap(baseBmt);
			bmd.scaleX = scrollItemView.museumItemData.scrollData.itemSize.width/bmd.width;
			bmd.scaleY = scrollItemView.museumItemData.scrollData.itemSize.height/bmd.height;
			scrollItemView.addChild(bmd);
			
			scrollItemView.buttonMode = true;
			scrollItemView.addEventListener(MouseEvent.ROLL_OVER,onMouseHandle, false, 0, true);
			scrollItemView.addEventListener(MouseEvent.ROLL_OUT,onMouseHandle, false, 0, true);
			scrollItemView.addEventListener(MouseEvent.CLICK,onMouseHandle, false, 0, true);
		}
	}
}
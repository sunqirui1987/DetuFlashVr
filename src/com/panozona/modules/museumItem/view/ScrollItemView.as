package com.panozona.modules.museumItem.view
{
	import com.panozona.modules.museumItem.data.MuseumItem;
	import com.panozona.modules.museumItem.data.MuseumItemData;
	import com.panozona.player.module.Module;
	
	import flash.display.Sprite;
	
	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-7-21 下午4:52:15
	 * 功能描述:
	 */
	public class ScrollItemView extends Sprite
	{
		
		public var museumItemData:MuseumItemData;
		
		private var module:Module;
		
		public var itemData:MuseumItem;
		
		public function ScrollItemView(itemData:MuseumItem,museumItemData:MuseumItemData,module:Module)
		{
			this.museumItemData = museumItemData;
			this.module = module;
			this.itemData = itemData;
			drawBack();
		}
		
		private function drawBack():void
		{
			graphics.beginFill(museumItemData.scrollData.itemBackColor,museumItemData.scrollData.backAlpha);			
			graphics.drawRect(0,0,museumItemData.scrollData.itemSize.width,museumItemData.scrollData.itemSize.height);
			graphics.endFill();
		}
	}
}
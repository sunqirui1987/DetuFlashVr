package com.panozona.player.manager.utils
{
	import com.panosalado.events.*;
	import com.panozona.player.*;
	import com.panozona.player.manager.data.global.*;
	import com.panozona.player.manager.utils.*;
	import com.panozona.player.module.data.property.*;
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.ui.*;
	
	public class Branding extends Sprite{
		

		
		private var player:QjPlayer;
		
		private var brandingButton:Sprite;
		
		public function Branding() {
			if (stage) stageReady();
			else addEventListener(Event.ADDED_TO_STAGE, stageReady, false, 0, true);
		}
		
		private function stageReady(e:Event = null):void {
			player = (this.parent as QjPlayer);
			
		
			
			var menu:ContextMenu = new ContextMenu();
			var item:ContextMenuItem = new ContextMenuItem("关于得图云 | 全景漫游");
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, gotoPanoZona, false, 0, true);
			menu.customItems.push(item);
			player.contextMenu = menu;
			
			player.contextMenu.hideBuiltInItems();
		
		}
	
		private function gotoPanoZona(e:Event):void {
			try {
				navigateToURL(new URLRequest("http://www.detuyun.com"), '_BLANK');
			} catch (error:Error) {
				
			}
		}
	}
}
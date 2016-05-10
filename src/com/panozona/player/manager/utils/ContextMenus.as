package com.panozona.player.manager.utils
{
	import com.panozona.player.QjPlayer;
	import com.panozona.player.manager.data.global.ContextMenuData;
	
	import flash.display.Sprite;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;

	public class ContextMenus extends Sprite
	{
		
		
		private var player:QjPlayer;
		
		private var brandingButton:Sprite;
		
		public function ContextMenus() {
			if (stage) stageReady();
			else addEventListener(Event.ADDED_TO_STAGE, stageReady, false, 0, true);
		}
		
		private function stageReady(e:Event = null):void {
			player = (this.parent as QjPlayer);
			
			var menu:ContextMenu = new ContextMenu();
			for(var i:Number = 0; i  < player.managerData.contextMenus.length ;i++)
			{
				var cmdata:ContextMenuData =  player.managerData.contextMenus[i];
				if(cmdata.blank == ""){ cmdata.blank ="_blank" ; }
				var item:ContextMenuItem = new ContextMenuItem(cmdata.menuname);
				item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,getContextMenuEvent(cmdata));
				menu.customItems.push(item);
			}

			player.contextMenu = menu;
			player.contextMenu.hideBuiltInItems();
			
		}
		
		private function getContextMenuEvent(cmdata:ContextMenuData):Function
		{
			return function(e:Event):void{
				if(cmdata.url.toLowerCase().indexOf("http://")  == 0)
				{
					//网址跳转
					navigateToURL(new URLRequest(cmdata.url),cmdata.blank);
				}
				else
				{	
					player.manager.runAction(cmdata.url);
				}
			};
		}
		
	}
}
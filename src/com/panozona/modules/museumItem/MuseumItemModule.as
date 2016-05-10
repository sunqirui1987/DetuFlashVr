package com.panozona.modules.museumItem
{
	import com.panozona.modules.mousecursor.data.MouseCursorData;
	import com.panozona.modules.museumItem.controller.JumpWndController;
	import com.panozona.modules.museumItem.data.DressItem;
	import com.panozona.modules.museumItem.data.MuseumItem;
	import com.panozona.modules.museumItem.data.MuseumItemData;
	import com.panozona.player.module.Module;
	import com.panozona.player.module.data.ModuleData;
	
	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-6-10 下午2:02:35
	 * 功能描述:
	 */
	public class MuseumItemModule extends Module
	{
		
		public var museumItemData:MuseumItemData;
		
		public var jumpController:JumpWndController;
		
		public function MuseumItemModule()
		{
			super("MuseumItemModule", "1.2", "http://ouwei.cn/wiki/Module:MuseumItemModule");
			moduleDescription.addFunctionDescription("jumpItem", String);
			moduleDescription.addFunctionDescription("jumpDressItem", String);
		}
		
		override protected function moduleReady(moduleData:ModuleData):void {
			museumItemData = new MuseumItemData(moduleData, qjPlayer);
			
			jumpController = new JumpWndController(museumItemData,this);
		}
		
		public function jumpItem(id:String,timeToAutoClose:Number=0,isShowList:Boolean=false):void{
			var item:MuseumItem = museumItemData.getMuseumItemById(id);
			if(item)
				jumpController.showJumpWnd(item,timeToAutoClose,isShowList);
		}
		
		public function jumpDressItem(id:String,timeToAutoClose:Number=0):void{
			var item:DressItem = museumItemData.getDressItemById(id);
			if(item)
				jumpController.showJumpDressWnd(item,timeToAutoClose);
		}
	}
}
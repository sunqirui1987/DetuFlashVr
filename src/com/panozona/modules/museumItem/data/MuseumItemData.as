package com.panozona.modules.museumItem.data
{
	import com.panozona.modules.museumItem.data.struct.Info;
	import com.panozona.modules.museumItem.data.struct.Title;
	import com.panozona.modules.museumItem.event.MuseumItemEvent;
	import com.panozona.player.module.data.DataNode;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.utils.DataNodeTranslator;
	
	import flash.events.EventDispatcher;

	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-6-10 下午2:13:07
	 * 功能描述:
	 */
	public class MuseumItemData  extends EventDispatcher
	{
		
		public var items:Vector.<MuseumItem> = new Vector.<MuseumItem>();
		
		public var sources:Vector.<SourceItem> = new Vector.<SourceItem>();
		
		public var scrollData:ScrollData;
		
		public var onClose:String;
		
		public var dressItems:Vector.<DressItem> = new Vector.<DressItem>();
		
		public function MuseumItemData(moduleData:ModuleData, qjPlayer:Object){
			
			var tarnslator:DataNodeTranslator = new DataNodeTranslator(qjPlayer.managerData.debugMode);
			
			for each(var dataNode:DataNode in moduleData.nodes) {
				if (dataNode.name == "item") {
					var item:MuseumItem = new MuseumItem();
					tarnslator.dataNodeToObject(dataNode, item);
					items.push(item);
				}else if (dataNode.name == "source") {
					var item2:SourceItem = new SourceItem();
					tarnslator.dataNodeToObject(dataNode, item2);
					sources.push(item2);
				}else if (dataNode.name == "scroll") {
					scrollData = new ScrollData();
					tarnslator.dataNodeToObject(dataNode, scrollData);
				}else if (dataNode.name == "dressItem") {
					var dressItem:DressItem = new DressItem();
					tarnslator.dataNodeToObject(dataNode, dressItem);
					if (dressItem.getChildrenOfGivenClass(Title).length == 1) {
						dressItem.title = dressItem.getChildrenOfGivenClass(Title).pop();
					}
					if (dressItem.getChildrenOfGivenClass(Info).length == 1) {
						dressItem.info = dressItem.getChildrenOfGivenClass(Info).pop();
					}
					dressItems.push(dressItem);
				}else {
					throw new Error("Invalid node name: " + dataNode.name);
				}
			}
		}
		
		public function getMuseumItemById(id:String):MuseumItem{
			var len:int = items.length;
			for(var i:int=0;i<len;i++){
				if(items[i].id == id)
					return items[i];
			}
			return null;
		}
		
		public function getDressItemById(id:String):DressItem{
			var len:int = dressItems.length;
			for(var i:int=0;i<len;i++){
				if(dressItems[i].id == id)
					return dressItems[i];
			}
			return null;
		}
		
		public function getSourceItemByName(name:String):SourceItem{
			var len:int = sources.length;
			for(var i:int=0;i<len;i++){
				if(sources[i].name == name)
					return sources[i];
			}
			return null;
		}
		
		private var _selectItem:MuseumItem;
		
		public function get selectItem():MuseumItem{
			return this._selectItem;
		}
		
		public function set selectItem(_selectItem:MuseumItem):void{
			if(_selectItem == null)
				return;
			this._selectItem = _selectItem;
			dispatchEvent(new MuseumItemEvent(MuseumItemEvent.SELECT_NEW_MUSEUM_ITEM));
		}
	}
}
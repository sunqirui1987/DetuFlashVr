package com.panozona.modules.guide.model
{
	import com.panozona.player.module.data.DataNode;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.utils.DataNodeTranslator;

	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-9-4 上午11:14:05
	 * 功能描述:
	 */
	public class GuideData
	{
		public var setting:Setting = new Setting();
		public const items:Vector.<GuideItem> = new Vector.<GuideItem>();
		public function GuideData(moduleData:ModuleData, qjPlayer:Object) {
			var tarnslator:DataNodeTranslator = new DataNodeTranslator(qjPlayer.managerData.debugMode);
			for each(var dataNode:DataNode in moduleData.nodes) {
				if (dataNode.name == "setting") {
					tarnslator.dataNodeToObject(dataNode,setting);
				}else if (dataNode.name == "guideItem") {
					var item:GuideItem = new GuideItem();
					tarnslator.dataNodeToObject(dataNode,item);
					items.push(item);
				}else {
					throw new Error("Invalid node name: " + dataNode.name);
				}
			}
		}
		
		public function getItemById(id:String):GuideItem{
			for(var i:int=0,n:int=items.length;i<n;i++){
				if(items[i].id == id)
					return items[i];
			}
			return null;
		}
	}
}
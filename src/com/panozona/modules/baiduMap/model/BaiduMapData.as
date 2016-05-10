package com.panozona.modules.baiduMap.model
{
	import com.panozona.modules.baiduMap.model.structure.Close;
	import com.panozona.player.module.data.DataNode;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.utils.DataNodeTranslator;

	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-3-12 上午10:11:45
	 * 功能描述:
	 */
	public class BaiduMapData
	{
		
		public const windowData:WindowData = new WindowData();
		public const close:Close = new Close();
		
		public function BaiduMapData(moduleData:ModuleData, qjPlayer:Object) {
			var tarnslator:DataNodeTranslator = new DataNodeTranslator(qjPlayer.managerData.debugMode);
			for each(var dataNode:DataNode in moduleData.nodes) {
				if (dataNode.name == "window") {
					tarnslator.dataNodeToObject(dataNode, windowData.window);
				}else if (dataNode.name == "close") {
					tarnslator.dataNodeToObject(dataNode, close);
				}else {
					throw new Error("Invalid node name: " + dataNode.name);
				}
			}
			windowData.open = windowData.window.open;
		}
	}
}
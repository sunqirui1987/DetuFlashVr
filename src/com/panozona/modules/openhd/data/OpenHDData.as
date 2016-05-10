package com.panozona.modules.openhd.data
{
	
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.data.DataNode;
	import com.panozona.player.module.utils.DataNodeTranslator;
	
	public class OpenHDData{
		
		public var settings:Settings = new Settings();
	
		
		public function OpenHDData(moduleData:ModuleData, qjPlayer:Object) {
			
			var translator:DataNodeTranslator = new DataNodeTranslator(qjPlayer.managerData.debugMode);
			
			for each(var dataNode:DataNode in moduleData.nodes) {
				if (dataNode.name == "settings") {
					translator.dataNodeToObject(dataNode, settings);
				}else {
					throw new Error("Invalid node name: " + dataNode.name);
				}
			}
			
			
			
		}
	}
	
	
}
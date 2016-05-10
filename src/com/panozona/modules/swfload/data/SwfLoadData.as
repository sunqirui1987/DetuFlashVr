package com.panozona.modules.swfload.data
{
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.data.DataNode;
	import com.panozona.player.module.utils.DataNodeTranslator;
	
	public class SwfLoadData{
		
		public var settings:Settings = new Settings();
		
		
		public function SwfLoadData(moduleData:ModuleData, qjPlayer:Object) {
			
			var translator:DataNodeTranslator = new DataNodeTranslator(qjPlayer.managerData.debugMode);
			
			for each(var dataNode:DataNode in moduleData.nodes) {
				if (dataNode.name == "settings") {
					translator.dataNodeToObject(dataNode, settings);
				}else {
					throw new Error("Invalid node name: " + dataNode.name);
				}
			}
			
			if (qjPlayer.managerData.debugMode) {
				
				if (settings.path == null || !settings.path.match(/^(.+)\.(png|gif|jpg|jpeg|swf)$/i))
					throw new Error("Invalid bitmaps grid path: " + settings.path);
			}
		
		}
	}
}
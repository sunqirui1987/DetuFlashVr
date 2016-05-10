/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.viewfinder.data{
	
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.data.DataNode;
	import com.panozona.player.module.utils.DataNodeTranslator;
	
	public class ViewFinderData {
		
		public const settings:Settings = new Settings();
		
		public function ViewFinderData(moduleData:ModuleData, qjPlayer:Object){
			
			var translator:DataNodeTranslator = new DataNodeTranslator(qjPlayer.managerData.debugMode);
			
			for each(var dataNode:DataNode in moduleData.nodes) {
				if (dataNode.name == "settings") {
					translator.dataNodeToObject(dataNode, settings);
				}else {
					throw new Error("Invalid node name: " + dataNode.name);
				}
			}
			// no additional validation required
		}
	}
}
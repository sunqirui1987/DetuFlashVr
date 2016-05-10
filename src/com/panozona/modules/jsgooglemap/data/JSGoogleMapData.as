/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.jsgooglemap.data {
	
	import com.panozona.modules.jsgooglemap.data.structure.*;
	import com.panozona.player.module.data.DataNode;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.utils.DataNodeTranslator;
	
	public class JSGoogleMapData {
		
		public var settings:Settings = new Settings();
		public var waypoints:Waypoints = new Waypoints();
		public var tracks:Tracks = new Tracks();
		
		public function JSGoogleMapData(moduleData:ModuleData, qjPlayer:Object) {
			
			var translator:DataNodeTranslator = new DataNodeTranslator(qjPlayer.managerData.debugMode);
			
			for each(var dataNode:DataNode in moduleData.nodes) {
				if (dataNode.name == "settings") {
					translator.dataNodeToObject(dataNode, settings);
				}else if (dataNode.name == "waypoints") {
					translator.dataNodeToObject(dataNode, waypoints);
				}else if (dataNode.name == "tracks") {
					translator.dataNodeToObject(dataNode, tracks);
				}else {
					throw new Error("Invalid node name: " + dataNode.name);
				}
			}
			
			if (qjPlayer.managerData.debugMode) {
				if (settings.onOpen != null && qjPlayer.managerData.getActionDataById(settings.onOpen) == null) {
					throw new Error("Action does not exist: " + settings.onOpen);
				}
				if (settings.onClose != null && qjPlayer.managerData.getActionDataById(settings.onClose) == null) {
					throw new Error("Action does not exist: " + settings.onClose);
				}
				for each (var waypoint:Waypoint in waypoints.getChildrenOfGivenClass(Waypoint)) {
					if (qjPlayer.managerData.getPanoramaDataById(waypoint.target) == null) {
						throw new Error("{Panorama does not exist: " + waypoint.target);
					}
				}
			}
		}
	}
}
/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.imagemap.model {
	
	import com.panozona.modules.imagemap.model.structure.Close;
	import com.panozona.modules.imagemap.model.structure.Layers;
	import com.panozona.modules.imagemap.model.structure.Map;
	import com.panozona.modules.imagemap.model.structure.Panel;
	import com.panozona.modules.imagemap.model.structure.Tab;
	import com.panozona.modules.imagemap.model.structure.Waypoint;
	import com.panozona.modules.imagemap.model.structure.Waypoints;
	import com.panozona.player.module.data.DataNode;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.utils.DataNodeTranslator;
	
	public class ImageMapData {
		
		public const windowData:WindowData = new WindowData();
		public const close:Close = new Close();
		public const viewerData:ViewerData = new ViewerData();
		public const mapData:MapData = new MapData();
		public const listData:ListData = new ListData();
		public const panel:Panel = new Panel();
		public const layers:Layers = new Layers();
		public var tab:Tab;
		
		public function ImageMapData(moduleData:ModuleData, qjPlayer:Object) {
			var tarnslator:DataNodeTranslator = new DataNodeTranslator(qjPlayer.managerData.debugMode);
			for each(var dataNode:DataNode in moduleData.nodes) {
				if (dataNode.name == "window") {
					tarnslator.dataNodeToObject(dataNode, windowData.window);
				}else if (dataNode.name == "close") {
					tarnslator.dataNodeToObject(dataNode, close);
				}else if (dataNode.name == "viewer") {
					tarnslator.dataNodeToObject(dataNode, viewerData.viewer);
				}else if (dataNode.name == "maps") {
					tarnslator.dataNodeToObject(dataNode, mapData.maps);
				}else if (dataNode.name == "lists") {
					tarnslator.dataNodeToObject(dataNode, listData.lists);
				}else if (dataNode.name == "layers") {
					tarnslator.dataNodeToObject(dataNode, layers);
				}else if (dataNode.name == "panel") {
					tarnslator.dataNodeToObject(dataNode, panel);
				}else if (dataNode.name == "tab") {
					tab = new Tab();
					tarnslator.dataNodeToObject(dataNode, tab);
				}else if (dataNode.name == "View") {
					if(tab){
						tab.uiXML = moduleData.moduleDataXml.View[0];
					}
				}else {
					qjPlayer.traceWindow.printError("Invalid node name: " + dataNode.name);
				}
			}
			
			windowData.open = windowData.window.open;
			
			if (qjPlayer.managerData.debugMode) {
				if (viewerData.viewer.moveEnabled || viewerData.viewer.zoomEnabled || viewerData.viewer.dragEnabled) {
					if (viewerData.viewer.path == null || !viewerData.viewer.path.match(/^(.+)\.(png|gif|jpg|jpeg|swf)$/i))
						qjPlayer.traceWindow.printError("Invalid viewer path: " + viewerData.viewer.path);
				}
				if (windowData.window.onOpen != null && qjPlayer.managerData.getActionDataById(windowData.window.onOpen) == null) {
					qjPlayer.traceWindow.printError("Action does not exist: " + windowData.window.onOpen);
				}
				if (windowData.window.onClose != null && qjPlayer.managerData.getActionDataById(windowData.window.onClose) == null) {
					qjPlayer.traceWindow.printError("Action does not exist: " + windowData.window.onClose);
				}
				if (mapData.maps.getChildrenOfGivenClass(Map).length == 0) {
					qjPlayer.traceWindow.printError("No maps found.");
				}
				var mapIds:Object = new Object();
				var waypointTargets:Object = new Object();
				for each(var map:Map in mapData.maps.getChildrenOfGivenClass(Map)) {
					if (map.id == null) {
						qjPlayer.traceWindow.printError("Map id not specified.");
					}
					if (map.path == null || !map.path.match(/^(.+)\.(png|gif|jpg|jpeg|swf)$/i)) {
						qjPlayer.traceWindow.printError("Invalid map path: " + map.path);
					}
					if (map.onSet != null && qjPlayer.managerData.getActionDataById(map.onSet) == null) {
						qjPlayer.traceWindow.printError("Action does not exist: " + map.onSet);
					}
					if (mapIds[map.id] != undefined) {
						qjPlayer.traceWindow.printError("Repeating map id: " + map.id);
					}else {
						mapIds[map.id] = ""; // something
						for each(var waypoints:Waypoints in map.getChildrenOfGivenClass(Waypoints)) {
							if (waypoints.path == null || !waypoints.path.match(/^(.+)\.(png|gif|jpg|jpeg|)$/i)) {
								qjPlayer.traceWindow.printError("Invalid waypoints path: " + waypoints.path);
							}
							for each(var waypoint:Waypoint in waypoints.getChildrenOfGivenClass(Waypoint)) {
								if (waypoint.target == null) {
									qjPlayer.traceWindow.printError("Waypoint target not specified in map: " + map.id);
								}
								if (qjPlayer.managerData.getPanoramaDataById(waypoint.target) == null) {
									qjPlayer.traceWindow.printError("Invalid waypoint target: " + waypoint.target);
								}
								if (waypoint.mouse.onOver != null && qjPlayer.managerData.getActionDataById(waypoint.mouse.onOver) == null){
									qjPlayer.traceWindow.printError("Action does not exist: " + waypoint.mouse.onOver);
								}
								if (waypoint.mouse.onOut != null && qjPlayer.managerData.getActionDataById(waypoint.mouse.onOut) == null){
									qjPlayer.traceWindow.printError("Action does not exist: " + waypoint.mouse.onOut);
								}
								if (waypointTargets[waypoint.target] != undefined) {
									qjPlayer.traceWindow.printError("Repeating waypoint target: " + waypoint.target);
								}else {
									waypointTargets[waypoint.target] = ""; // something
								}
							}
						}
					}
				}
			}
		}
	}
}
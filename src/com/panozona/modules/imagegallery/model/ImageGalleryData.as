/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.imagegallery.model {
	
	import com.panozona.modules.imagegallery.model.structure.Close;
	import com.panozona.modules.imagegallery.model.structure.Group;
	import com.panozona.modules.imagegallery.model.structure.Image;
	import com.panozona.player.module.data.DataNode;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.utils.DataNodeTranslator;
	
	public class ImageGalleryData {
		
		public const windowData:WindowData = new WindowData();
		public const close:Close = new Close();
		public const viewerData:ViewerData =  new ViewerData();
		
		public function ImageGalleryData(moduleData:ModuleData, qjPlayer:Object) {
			var tarnslator:DataNodeTranslator = new DataNodeTranslator(qjPlayer.managerData.debugMode);
			for each(var dataNode:DataNode in moduleData.nodes) {
				if (dataNode.name == "window") {
					tarnslator.dataNodeToObject(dataNode, windowData.window);
				}else if (dataNode.name == "close") {
					tarnslator.dataNodeToObject(dataNode, close);
				}else if (dataNode.name == "viewer") {
					tarnslator.dataNodeToObject(dataNode, viewerData.viewer);
				}else if (dataNode.name == "groups") {
					tarnslator.dataNodeToObject(dataNode, viewerData.groups);
				}else {
					throw new Error("Invalid node name: " + dataNode.name);
				}
			}
			
			windowData.open = windowData.window.open;
			
			if (qjPlayer.managerData.debugMode) {
				if (windowData.window.onOpen != null && qjPlayer.managerData.getActionDataById(windowData.window.onOpen) == null) {
					throw new Error("Action does not exist: " + windowData.window.onOpen);
				}
				if (windowData.window.onClose != null && qjPlayer.managerData.getActionDataById(windowData.window.onClose) == null) {
					throw new Error("Action does not exist: " + windowData.window.onClose);
				}
				if (viewerData.viewer.path == null || !viewerData.viewer.path.match(/^(.+)\.(png|gif|jpg|jpeg|)$/i)) {
					throw new Error("Invalid viewer path: " + viewerData.viewer.path);
				}
				var groupIds:Object = new Object();
				for each(var group:Group in viewerData.groups.getChildrenOfGivenClass(Group)) {
					if (group.id == null) {
						throw new Error("Group id not specified.");
					}
					if (groupIds[group.id] != undefined) {
						throw new Error("Repeating group id: " + group.id);
					} else {
						groupIds[group.id] = ""; // something
						if (group.getChildrenOfGivenClass(Image).length == 0) {
							throw new Error("Group is empty: " + group.id);
						}
						for each(var image:Image in group.getChildrenOfGivenClass(Image)) {
							if (image.path == null || !image.path.match(/^(.+)\.(png|gif|jpg|jpeg|)$/i)) {
								throw new Error("Invalid image path: " + image.path);
							}
						}
					}
				}
			}
		}
	}
}
/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.infobox.model {
	
	import com.panozona.modules.infobox.model.structure.Close;
	import com.panozona.player.module.data.DataNode;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.utils.DataNodeTranslator;
	
	public class InfoBoxData {
		
		public const windowData:WindowData = new WindowData();
		public const close:Close = new Close();
		public const viewerData:ViewerData = new ViewerData();
		public const articleData:ArticleData = new ArticleData();
		
		public function InfoBoxData(moduleData:ModuleData, qjPlayer:Object) {
			var tarnslator:DataNodeTranslator = new DataNodeTranslator(qjPlayer.managerData.debugMode);
			for each(var dataNode:DataNode in moduleData.nodes) {
				if (dataNode.name == "window") {
					tarnslator.dataNodeToObject(dataNode, windowData.window);
				}else if (dataNode.name == "close") {
					tarnslator.dataNodeToObject(dataNode, close);
				}else if (dataNode.name == "viewer") {
					tarnslator.dataNodeToObject(dataNode, viewerData.viewer);
				}else if (dataNode.name == "articles") {
					tarnslator.dataNodeToObject(dataNode, articleData.articles);
				}else {
					throw new Error("Invalid node name: " + dataNode.name);
				}
			}
			
			windowData.open = windowData.window.open;
			
			if (qjPlayer.managerData.debugMode) {
				if (viewerData.viewer.moveEnabled || viewerData.viewer.zoomEnabled || viewerData.viewer.dragEnabled) {
					if (viewerData.viewer.path == null || !viewerData.viewer.path.match(/^(.+)\.(png|gif|jpg|jpeg|swf)$/i))
						throw new Error("Invalid viewer path: " + viewerData.viewer.path);
				}
				if (windowData.window.onOpen != null && qjPlayer.managerData.getActionDataById(windowData.window.onOpen) == null) {
					throw new Error("Action does not exist: " + windowData.window.onOpen);
				}
				if (windowData.window.onClose != null && qjPlayer.managerData.getActionDataById(windowData.window.onClose) == null) {
					throw new Error("Action does not exist: " + windowData.window.onClose);
				}
				if (articleData.articles.getChildrenOfGivenClass(Article).length == 0) {
					throw new Error("No articles found.");
				}
				var articleIds:Object = new Object();
				
				for each(var artilce:Article in articleData.articles.getChildrenOfGivenClass(Articlr)) {
					if (article.id == null) throw new Error("Article id not specified.");
					if (article.onSet != null && qjPlayer.managerData.getActionDataById(article.onSet) == null) throw new Error("Action does not exist: " + article.onSet);
					if (articleIds[article.id] != undefined) {
						throw new Error("Repeating article id: " + article.id);
					}else {
						articleIds[article.id] = ""; // something
					}
				}
			}
		}
	}
}
/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.menuscroller.model {
	
	import com.panozona.modules.menuscroller.model.structure.Close;
	import com.panozona.modules.menuscroller.model.structure.Element;
	import com.panozona.modules.menuscroller.model.structure.Elements;
	import com.panozona.modules.menuscroller.model.structure.ExtraElement;
	import com.panozona.modules.menuscroller.model.structure.IconItem;
	import com.panozona.modules.menuscroller.model.structure.RawElement;
	import com.panozona.modules.menuscroller.model.structure.ShowViewItem;
	import com.panozona.modules.menuscroller.model.structure.Styles;
	import com.panozona.player.module.data.DataNode;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.utils.DataNodeTranslator;
	
	public class MenuScrollerData {
		
		public const windowData:WindowData = new WindowData();
		public const scrollerData:ScrollerData = new ScrollerData();
		public const elements:Elements = new Elements();
		public const close:Close = new Close();
		public const styles:Styles = new Styles();
		public const icons:Vector.<IconItem> = new Vector.<IconItem>();
		public var showViewItem:ShowViewItem;
		
		public function MenuScrollerData(moduleData:ModuleData, qjPlayer:Object) {
			var tarnslator:DataNodeTranslator = new DataNodeTranslator(qjPlayer.managerData.debugMode);
			for each(var dataNode:DataNode in moduleData.nodes) {
				if (dataNode.name == "window") {
					tarnslator.dataNodeToObject(dataNode, windowData.window);
				}else if (dataNode.name == "scroller") {
					tarnslator.dataNodeToObject(dataNode, scrollerData.scroller);
				}else if (dataNode.name == "elements") {
					tarnslator.dataNodeToObject(dataNode, elements);
				}else if (dataNode.name == "close") {
					tarnslator.dataNodeToObject(dataNode, close);
				}else if(dataNode.name == "styles") {
					tarnslator.dataNodeToObject(dataNode, styles);
				}else if(dataNode.name == "icon") {
					var item2:IconItem = new IconItem();
					tarnslator.dataNodeToObject(dataNode, item2);
					icons.push(item2);
				}else if(dataNode.name == "showView") {
					showViewItem = new ShowViewItem();
					tarnslator.dataNodeToObject(dataNode, showViewItem);
				}else {
					qjPlayer.traceWindow.printError("Invalid node name: " + dataNode.name);
				}
			}
			
			windowData.open = windowData.window.open;
			windowData.elasticWidth = windowData.window.size.width;
			windowData.elasticHeight = windowData.window.size.height;
			
			if (qjPlayer.managerData.debugMode) {
				if (windowData.window.onOpen != null && qjPlayer.managerData.getActionDataById(windowData.window.onOpen) == null) {
					qjPlayer.traceWindow.printError("Action does not exist: " + windowData.window.onOpen);
				}
				if (windowData.window.onClose != null && qjPlayer.managerData.getActionDataById(windowData.window.onClose) == null) {
					qjPlayer.traceWindow.printError("Action does not exist: " + windowData.window.onClose);
				}
				var elementTargets:Object = new Object();
				var extraElementIds:Object = new Object();
				for each (var rawElement:RawElement in elements.getAllChildren()) {
					if (rawElement.path == null || !rawElement.path.match(/^(.+)\.(png|gif|jpg|jpeg|swf)/i)) {
						qjPlayer.traceWindow.printError("Invalid element path: " + rawElement.path);
					}
					if (rawElement.mouse.onOver != null && qjPlayer.managerData.getActionDataById(rawElement.mouse.onOver) == null){
						qjPlayer.traceWindow.printError("Action does not exist: " + rawElement.mouse.onOver);
					}
					if (rawElement.mouse.onOut != null && qjPlayer.managerData.getActionDataById(rawElement.mouse.onOut) == null){
						qjPlayer.traceWindow.printError("Action does not exist: " + rawElement.mouse.onOut);
					}
					if (rawElement is Element){
						if ((rawElement as Element).target == null) qjPlayer.traceWindow.printError("Element target not specified.");
						if (qjPlayer.managerData.getPanoramaDataById((rawElement as Element).target) == null) qjPlayer.traceWindow.printError("Invalid element target: " + (rawElement as Element).target);
						if (elementTargets[(rawElement as Element).target] != undefined) qjPlayer.traceWindow.printError("Repeating element target: " + (rawElement as Element).target);
						elementTargets[(rawElement as Element).target] = ""; // something
					}else {
						if ((rawElement as ExtraElement).id == null) qjPlayer.traceWindow.printError("ExtraElement id not specified.");
						if (extraElementIds[(rawElement as ExtraElement).id] != undefined) qjPlayer.traceWindow.printError("Repeating extraElement id: " + (rawElement as ExtraElement).id);
						extraElementIds[(rawElement as ExtraElement).id] = ""; // somethig
						if (qjPlayer.managerData.getActionDataById((rawElement as ExtraElement).action) == null){
							qjPlayer.traceWindow.printError("Action in extraElement does not exist: " + (rawElement as ExtraElement).action);
						}
					}
				}
			}
		}
	}
}
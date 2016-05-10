/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.buttonbar.model{
	
	import com.panozona.modules.buttonbar.model.structure.Bg;
	import com.panozona.modules.buttonbar.model.structure.Button;
	import com.panozona.modules.buttonbar.model.structure.Buttons;
	import com.panozona.modules.buttonbar.model.structure.ExtraButton;
	import com.panozona.player.module.data.DataNode;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.utils.DataNodeTranslator;
	
	public class ButtonBarData {
		
		public const windowData:WindowData = new WindowData();
		public const buttons:Buttons = new Buttons();
		public const bg:Bg = new Bg();
		public var swfViewData:SwfViewData;
		
		public function ButtonBarData(moduleData:ModuleData, qjPlayer:Object){
			
			var translator:DataNodeTranslator = new DataNodeTranslator(qjPlayer.managerData.debugMode);
			
			for each(var dataNode:DataNode in moduleData.nodes) {
				if (dataNode.name == "window") {
					translator.dataNodeToObject(dataNode, windowData.window);
				}else if (dataNode.name == "buttons") {
					translator.dataNodeToObject(dataNode, buttons);
				}else if (dataNode.name == "bg") {
					translator.dataNodeToObject(dataNode, bg);
				}else if (dataNode.name == "swfView") {
					swfViewData = new SwfViewData();
					translator.dataNodeToObject(dataNode, swfViewData);
				}else {
					qjPlayer.traceWindow.printError("Invalid node name: " + dataNode.name);
				}
			}
			
			windowData.open = windowData.window.open;
			
			if (qjPlayer.managerData.debugMode) {
				if (buttons.path == null || !buttons.path.match(/^(.+)\.(png|gif|jpg|jpeg)/i)) qjPlayer.traceWindow.printError("Invalid buttons path: " + buttons.path);
				var buttonNames:Object = new Object();
				for each(var button:Button in buttons.getChildrenOfGivenClass(Button)) {
					if (button.name == null) qjPlayer.traceWindow.printError("Button name not specified.");
					if (buttonNames[button.name] != undefined) {
						qjPlayer.traceWindow.printError("Repeating button name: " + button.name);
					}else {
						buttonNames[button.name] = ""; // something
						if (button.mouse.onOver != null && qjPlayer.managerData.getActionDataById(button.mouse.onOver) == null){
							qjPlayer.traceWindow.printError("Action does not exist: " + button.mouse.onOver);
						}
						if (button.mouse.onOut != null && qjPlayer.managerData.getActionDataById(button.mouse.onOut) == null){
							qjPlayer.traceWindow.printError("Action does not exist: " + button.mouse.onOut);
						}
						if (button is ExtraButton && qjPlayer.managerData.getActionDataById((button as ExtraButton).action) == null){
							qjPlayer.traceWindow.printError("Action does not exist: " + (button as ExtraButton).action);
						}
					}
				}
			}
		}
	}
}
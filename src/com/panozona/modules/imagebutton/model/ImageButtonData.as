/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.imagebutton.model{
	
	import com.panozona.modules.imagebutton.model.structure.Bg;
	import com.panozona.modules.imagebutton.model.structure.Button;
	import com.panozona.modules.imagebutton.model.structure.GroupButton;
	import com.panozona.modules.imagebutton.model.structure.HtmlText;
	import com.panozona.modules.imagebutton.model.structure.Styles;
	import com.panozona.modules.imagebutton.model.structure.SubButton;
	import com.panozona.modules.imagebutton.model.structure.SubButtons;
	import com.panozona.modules.imagebutton.model.structure.TextSize;
	import com.panozona.modules.imagebutton.model.structure.Window;
	import com.panozona.player.module.data.DataNode;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.utils.DataNodeTranslator;
	
	public class ImageButtonData{
		
		public const buttons:Vector.<Button> = new Vector.<Button>();
		public const styles:Styles = new Styles();
		public const groupButtons:Vector.<GroupButton> = new Vector.<GroupButton>();
		
		public function ImageButtonData(moduleData:ModuleData, qjPlayer:Object){
			var tarnslator:DataNodeTranslator = new DataNodeTranslator(qjPlayer.managerData.debugMode);
			for each(var dataNode:DataNode in moduleData.nodes) {
				if (dataNode.name == "button") {
					var button:Button = new Button();
					tarnslator.dataNodeToObject(dataNode, button);
					
					if (button.getChildrenOfGivenClass(Window).length == 1) {
						button.window = button.getChildrenOfGivenClass(Window).pop();
					}else if (button.getChildrenOfGivenClass(Window).length == 0) {
						button.window = new Window();
					}
					if (button.getChildrenOfGivenClass(SubButtons).length == 1) {
						button.subButtons = button.getChildrenOfGivenClass(SubButtons).pop();
					}else if (button.getChildrenOfGivenClass(SubButtons).length == 0) {
						button.subButtons = new SubButtons();
					}
					if (button.getChildrenOfGivenClass(HtmlText).length == 1) {
						button.htmlText = button.getChildrenOfGivenClass(HtmlText).pop();
					}
					buttons.push(button);
				}else if (dataNode.name == "groupButton") {
					var groupButton:GroupButton = new GroupButton();
					tarnslator.dataNodeToObject(dataNode, groupButton);
					
					if (groupButton.getChildrenOfGivenClass(Window).length == 1) {
						groupButton.window = groupButton.getChildrenOfGivenClass(Window).pop();
					}else if (groupButton.getChildrenOfGivenClass(Window).length == 0) {
						groupButton.window = new Window();
					}
					if (groupButton.getChildrenOfGivenClass(Bg).length == 1) {
						groupButton.bg = groupButton.getChildrenOfGivenClass(Bg).pop();
					}else if (groupButton.getChildrenOfGivenClass(Bg).length == 0) {
						groupButton.bg = new Bg();
					}
					var arr:Array = groupButton.getChildrenOfGivenClass(Button);
					for(var i:int=0;i<arr.length;i++){
						var b:Button = arr[i] as Button;
						if (b.getChildrenOfGivenClass(Window).length == 1) {
							b.window = b.getChildrenOfGivenClass(Window).pop();
						}else if (button.getChildrenOfGivenClass(Window).length == 0) {
							b.window = new Window();
						}
						if (b.getChildrenOfGivenClass(SubButtons).length == 1) {
							b.subButtons = button.getChildrenOfGivenClass(SubButtons).pop();
						}else if (b.getChildrenOfGivenClass(SubButtons).length == 0) {
							b.subButtons = new SubButtons();
						}
						if (b.getChildrenOfGivenClass(HtmlText).length == 1) {
							b.htmlText = b.getChildrenOfGivenClass(HtmlText).pop();
						}
					}
					groupButtons.push(groupButton);
				}else if(dataNode.name == "styles") {
					tarnslator.dataNodeToObject(dataNode, styles);
				}else {
					qjPlayer.traceWindow.printError("Unrecognized node: " + dataNode.name);
				}
			}
			
			if (qjPlayer.managerData.debugMode){
				var buttonIds:Object = new Object();
				var subButtonIds:Object = new Object();
				for each (button in buttons){
					if (button.id == null) {
						qjPlayer.traceWindow.printError("Button id not specified.");
					}
					/*
					if ((button.path != null && !button.path.match(/^(.+)\.(png|gif|jpg|jpeg|swf)$/i))
						|| (button.path == null && button.subButtons.getChildrenOfGivenClass(SubButton).length == 0)){
						qjPlayer.traceWindow.printError("Invalid button path: " + button.path);
					}*/
					if (button.action != null && qjPlayer.managerData.getActionDataById(button.action) == null){
						qjPlayer.traceWindow.printError("Action does not exist: " + button.action);
					}
					if (button.mouse.onOver != null && qjPlayer.managerData.getActionDataById(button.mouse.onOver) == null){
						qjPlayer.traceWindow.printError("Action does not exist: " + button.mouse.onOver);
					}
					if (button.mouse.onOut != null && qjPlayer.managerData.getActionDataById(button.mouse.onOut) == null){
						qjPlayer.traceWindow.printError("Action does not exist: " + button.mouse.onOut);
					}
					if (buttonIds[button.id] != undefined) {
						qjPlayer.traceWindow.printError("Repeating button id: " + button.id);
					}else {
						buttonIds[button.id] = ""; // something
						for each (var subButton:SubButton in button.subButtons.getChildrenOfGivenClass(SubButton)) {
							if (subButton.id == null) {
								qjPlayer.traceWindow.printError("subButton id not specified.");
							}
							if (subButton.path == null || !subButton.path.match(/^(.+)\.(png|gif|jpg|jpeg)$/i)){
								qjPlayer.traceWindow.printError("Invalid subButton path: " + subButton.path);
							}
							if (subButton.action != null && qjPlayer.managerData.getActionDataById(subButton.action) == null){
								qjPlayer.traceWindow.printError("Action does not exist: " + subButton.action);
							}
							if (subButton.mouse.onOver != null && qjPlayer.managerData.getActionDataById(subButton.mouse.onOver) == null){
								qjPlayer.traceWindow.printError("Action does not exist: " + subButton.mouse.onOver);
							}
							if (subButton.mouse.onOut != null && qjPlayer.managerData.getActionDataById(subButton.mouse.onOut) == null){
								qjPlayer.traceWindow.printError("Action does not exist: " + subButton.mouse.onOut);
							}
							if (subButtonIds[subButton.id] != undefined) {
								qjPlayer.traceWindow.printError("Repeating subButton id: " + subButton.id);
							}else {
								subButtonIds[subButton.id] = ""; // something
							}
						}
					}
				}
			}
		}
	}
}
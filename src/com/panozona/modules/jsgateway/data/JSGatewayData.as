/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.jsgateway.data{
	
	import com.panozona.modules.jsgateway.data.structure.ASFunction;
	import com.panozona.modules.jsgateway.data.structure.ASFunctions;
	import com.panozona.modules.jsgateway.data.structure.JSFunction;
	import com.panozona.modules.jsgateway.data.structure.JSFunctions;
	import com.panozona.modules.jsgateway.data.structure.Settings;
	import com.panozona.player.module.data.DataNode;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.utils.DataNodeTranslator;
	
	public class JSGatewayData {
		
		public const settings:Settings = new Settings();
		public const jsfuncttions:JSFunctions = new JSFunctions();
		public const asfuncttions:ASFunctions = new ASFunctions();
		
		public function JSGatewayData(moduleData:ModuleData, qjPlayer:Object) {
			
			var translator:DataNodeTranslator = new DataNodeTranslator(qjPlayer.managerData.debugMode);
			
			for each(var dataNode:DataNode in moduleData.nodes) {
				if (dataNode.name == "jsfunctions") {
					translator.dataNodeToObject(dataNode, jsfuncttions);
				}else if (dataNode.name == "asfunctions") {
					translator.dataNodeToObject(dataNode, asfuncttions);
				}else if (dataNode.name == "settings") {
					translator.dataNodeToObject(dataNode, settings);
				}else {
					throw new Error("Invalid node name: " + dataNode.name);
				}
			}
			
			if (qjPlayer.managerData.debugMode) {
				var jsfunctionIds:Object = new Object();
				for each (var jsfunction:JSFunction in jsfuncttions.getChildrenOfGivenClass(JSFunction)) {
					if (jsfunction.id == null) throw new Error("jsfunction id not specified.");
					if (jsfunction.name == null) throw new Error("jsfunction name not specified.");
					if (jsfunctionIds[jsfunction.id] != undefined) {
						throw new Error("Repeating jsfunction id: " + jsfunction.id);
					}else {
						jsfunctionIds[jsfunction.id] = ""; // something
					}
				}
				var asfunctionNames:Object = new Object();
				for each (var asfunction:ASFunction in asfuncttions.getChildrenOfGivenClass(ASFunction)) {
					if (asfunction.name == null) throw new Error("asfunction name not specified.");
					if (asfunction.callback == null) throw new Error("asfunction callback not specified.");
					if (asfunctionNames[asfunction.name] != undefined) {
						throw new Error("Repeating asfunction name: " + asfunction.name);
					}else {
						asfunctionNames[asfunction.name] = ""; // something
					}
				}
			}
		}
	}
}
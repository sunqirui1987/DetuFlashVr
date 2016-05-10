package com.panozona.modules.guestBook.utils
{
	import com.panozona.modules.guestBook.model.MessagesData;
	import com.panozona.player.manager.events.ConfigurationEvent;
	import com.panozona.player.module.data.DataNode;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.getDefinitionByName;
	
	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-2-21
	 * 功能描述:
	 */
	public class GuestBookDataParseXml extends EventDispatcher
	{
		public function GuestBookDataParseXml(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function configureManagerData(messagesData:MessagesData, settings:XML):void {
			var mainNodeName:String;
			parseMessages(messagesData, settings);
		}
		
		protected function parseMessages(messagesData:MessagesData, messagesNode:XML):void {
			var dataNodeMain:DataNode = new DataNode(messagesNode.localName());
			for each(var moduleChildNode:XML in messagesNode.elements()) {
				var dataNode:DataNode;
				dataNode = new DataNode(moduleChildNode.localName());
				parseDataNodeRecursive(dataNode, moduleChildNode);
				dataNodeMain.childNodes.push(dataNode);
			}
			messagesData.nodes.push(dataNodeMain);
		}
		
		protected function parseDataNodeRecursive(dataNode:DataNode, moduleNode:XML):void {
			var recognizedValue:*;
			for each(var attribute:XML in moduleNode.attributes()) {
				recognizedValue = recognizeContent(attribute);
				dataNode.attributes[attribute.name().toString()] = recognizedValue;
			}
			var childDataNode:DataNode;
			for each(var moduleChildNode:XML in moduleNode.children()){
				if (moduleChildNode.nodeKind() == "text"){
					if (dataNode.attributes["text"] == undefined) {
						dataNode.attributes["text"] = moduleChildNode.toString();
					}else {
						dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
							"Text value allready exists in: " + dataNode.name));
					}
				}else {
					childDataNode = new DataNode(moduleChildNode.localName());
					parseDataNodeRecursive(childDataNode, moduleChildNode);
					dataNode.childNodes.push(childDataNode);
				}
			}
		}
		
		protected function recognizeContent(content:String):*{
			if (content == null){
				return null;
			}else if (content.match(/^(\[.*\])$/)) { // [String]
				return content.substring(1, content.length - 1);
			}else if (content == "true" || content == "false") { // Boolean
				return ((content == "true")? true : false);
			}else if (content.match(/^(-)?[\d]+(.[\d]+)?$/)) { // Number
				return (Number(content));
			}else if (content.match(/^#[0-9a-f]{6}$/i)) { // Number - color
				content = content.substring(1, content.length);
				return (Number("0x" + content));
			}else if (content == "NaN"){ // Number - NaN
				return NaN;
			}else if (content.match(/^(?!http).+:.+$/)) { // Object
				var object:Object = new Object();
				applySubAttributes(object, content); 
				return object;
			}else if (content.match(/^(Linear|Expo|Back|Bounce|Cubic|Elastic)\.[a-zA-Z]+$/)) { // Function
				return (recognizeFunction(content) as Function);
			}else if (content.replace(/\s/g, "").length > 0) { // TODO: trim
				return content; // String
			}else {
				dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING, content+"Missing value."));
				return null;
			}
		}
		
		protected function recognizeFunction(content:String):Function {
			var result:Function;
			var functionElements:Array = content.split(".");
			var functionClass:Object = getDefinitionByName("com.robertpenner.easing." + functionElements[0]);
			result = functionClass[functionElements[1]] as Function
			if (result == null){
				dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
					"Invalid function name in: " + functionElements[0]+"."+functionElements[1]));
			}
			return result;
		}
		
		protected function applySubAttributes(object:Object, subAttributes:String):void {
			var allSubAttributes:Array = subAttributes.split(",");
			var singleSubAttrArray:Array;
			var recognizedValue:*;
			for each (var singleSubAttribute:String in allSubAttributes) {
				if (!singleSubAttribute.match(/^[\w]+:[^:]+$/)){
					dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
						"Invalid subattribute format: " + singleSubAttribute));
					continue;
				}
				singleSubAttrArray = singleSubAttribute.match(/[^:]+/g);
				recognizedValue = recognizeContent(singleSubAttrArray[1]);
				
//				if (!debugMode) {
//					object[singleSubAttrArray[0]] = recognizedValue;
//					continue;
//				}
				
				if (object.hasOwnProperty(singleSubAttrArray[0])) {
					if (object[singleSubAttrArray[0]] is Boolean) {
						if (recognizedValue is Boolean) {
							object[singleSubAttrArray[0]] = recognizedValue;
						}else {
							dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
								"Invalid subattribute type (Boolean expected): " + singleSubAttribute));
						}
					}else if (object[singleSubAttrArray[0]] is Number) {
						if(recognizedValue is Number){
							object[singleSubAttrArray[0]] = recognizedValue;
						}else {
							dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
								"Invalid subattribute type (Number expected): " + singleSubAttribute));
						}
					}else if (object[singleSubAttrArray[0]] is Function) {
						if(recognizedValue is Function){
							object[singleSubAttrArray[0]] = recognizedValue;
						}else {
							dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
								"Invalid subattribute type (Function expected): " + singleSubAttribute));
						}
					}else if (object[singleSubAttrArray[0]] == null || object[singleSubAttrArray[0]] is String) {
						if(recognizedValue is String){
							object[singleSubAttrArray[0]] = recognizedValue; 
						}else {
							dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
								"Invalid subattribute type (String expected): " + singleSubAttribute));
						}
					}
				}else {
					// check if creation of new atribute in object is possible
					// used in onEnterSource, onLeaveTarget, ect.
					try{
						object[singleSubAttrArray[0]] = recognizedValue;
					}catch (e:Error) {
						dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
							"Invalid attribute name (cannot apply): " + singleSubAttrArray[0]));
					}
				}
			}
		}
	}
}
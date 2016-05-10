package com.panozona.player.manager.utils.configuration
{
	import com.panozona.player.manager.data.ManagerData;
	import com.panozona.player.manager.data.panoramas.PanoramaData;
	import com.panozona.player.manager.events.ConfigurationEvent;
	import com.robertpenner.easing.Back;
	import com.robertpenner.easing.Bounce;
	import com.robertpenner.easing.Cubic;
	import com.robertpenner.easing.Elastic;
	import com.robertpenner.easing.Expo;
	import com.robertpenner.easing.Linear;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	public class ManagerDataParserFlashvars extends EventDispatcher
	{
		protected var debugMode:Boolean = false;
		
		public function ManagerDataParserFlashvars()
		{
		}
		
		public function configureManagerData(managerData:ManagerData, parameters:Object):void 
		{
			if(parameters == null)
			{
				return ;
			}
			var subAttributes:String = "";
			//模式
			if(parameters.qj_global_debugMode != null)
			{
				managerData.debugMode = parameters.qj_global_debugMode as Boolean;
				debugMode = managerData.debugMode;
			}
			
			
			/*******  Control Strart   *******/
			if(parameters.qj_global_control_mouseInertial  != null)
			{
				subAttributes = parameters.qj_global_control_mouseInertial as String
				applySubAttributes(managerData.controlData.inertialMouseCameraData, subAttributes);
			}
			
			if(parameters.qj_global_control_keyboard  != null)
			{
				subAttributes = parameters.qj_global_control_keyboard as String
				applySubAttributes(managerData.controlData.keyboardCameraData, subAttributes);
			}
			
			if(parameters.qj_global_control_autorotation  != null)
			{
				subAttributes = parameters.qj_global_control_autorotation as String
				applySubAttributes(managerData.controlData.autorotationCameraData, subAttributes);
			}
			
			if(parameters.qj_global_control_transition  != null)
			{
				subAttributes = parameters.qj_global_control_transition as String
				applySubAttributes(managerData.controlData.simpleTransitionData, subAttributes);
			}
			 /*******  Control end   *******/
			
			/*******  panoramas Strart   *******/
			if(parameters.qj_global_panoramas_firstPanorama  != null)
			{
				subAttributes = parameters.qj_global_panoramas_firstPanorama as String
				managerData.allPanoramasData.firstPanorama = getAttributeValue(subAttributes, String);
			}
			if(parameters.qj_global_panoramas_isAutoLink  != null)
			{
				subAttributes = parameters.qj_global_panoramas_isAutoLink as String
				managerData.allPanoramasData.isAutoLink = getAttributeValue(subAttributes, Boolean);
			}
			if(parameters.qj_global_panoramas_helpPath != null)
			{
				subAttributes = parameters.qj_qj_global_panoramas_helpPath as String
				managerData.allPanoramasData.helpPath = getAttributeValue(subAttributes, String);
			}
			/*******  panoramas end   *******/
			
			/*******  panorama end  *******/
			if(parameters.qj_panorama_first_camera  != null)
			{
				subAttributes = parameters.qj_panorama_first_camera as String;
				if(managerData.panoramasData.length == 0)
				{
					return;
				}
				var current_PanoramaData:PanoramaData = managerData.panoramasData[0];
				for each(var pdata:PanoramaData in managerData.panoramasData)
				{
					if(pdata.id ==managerData.allPanoramasData.firstPanorama)
					{
						current_PanoramaData = pdata;
					}
				}
				
				applySubAttributes(current_PanoramaData.params, subAttributes);
			}
			/*******  panorama end   *******/
			
		}
		
		protected function getAttributeValue(attribute:String, ReturnClass:Class):*{
			var recognizedValue:* = recognizeContent(attribute);
			
			if (recognizedValue is ReturnClass) {
				return recognizedValue;
			}
			else if( flash.utils.getQualifiedClassName(ReturnClass) == "String" )
			{
				return String(recognizedValue);
			}
			else if (recognizedValue != null){
				dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
					"Ivalid attribute type (" + getQualifiedClassName(ReturnClass) + " expected): " + attribute));
			}
			return null;
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
				
				if (!debugMode) {
					object[singleSubAttrArray[0]] = recognizedValue;
					continue;
				}
				
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
		
		Linear; Expo; Back; Bounce; Cubic; Elastic;
		protected function recognizeContent(content:String):*{
			if(content == "")
			{
				return "";
			}
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
		
		Linear; Expo; Back; Bounce; Cubic; Elastic;
		protected function recognizeContentAction(content:String):*{
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
				//}else if (content.match(/^(?!http).+:.+$/)) { // Object
				//	var object:Object = new Object();
				//		applySubAttributes(object, content); 
				//		return object;
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
		
		
	}
}
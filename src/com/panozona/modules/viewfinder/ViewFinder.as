/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.viewfinder{
	
	import com.panozona.modules.viewfinder.data.ViewFinderData;
	import com.panozona.player.module.Module;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.data.property.Align;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.system.ApplicationDomain;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class ViewFinder extends Module {
		
		private var txtOutput:TextField;
		private var pointer:Sprite;
		private var viewFinderData:ViewFinderData;
		private var currentDirection:Number = 0;
		private var simplebuttonsprite:Sprite;
		
		public function ViewFinder():void{
			super("ViewFinder", "1.3", "http://ouwei.cn/wiki/Module:ViewFinder");
			moduleDescription.addFunctionDescription("setActive", String, Boolean);
		}
		
		override protected function moduleReady(moduleData:ModuleData):void {
			
			viewFinderData = new ViewFinderData(moduleData, qjPlayer); // always first
			
			if(viewFinderData.settings.isCircle == true)
			{
				pointer = new Sprite();
				pointer.graphics.beginFill(viewFinderData.settings.qcolor);
				pointer.graphics.drawCircle(0, 0, 5);
				pointer.graphics.endFill();
				
				pointer.graphics.beginFill(0x000000);
				pointer.graphics.drawCircle(0, 0, 2);
				pointer.graphics.endFill();
				pointer.mouseEnabled = false;
				addChild(pointer);
			}
			
			var txtFormat:TextFormat = new TextFormat();
			txtFormat.font = "Courier";
			txtFormat.size = 12;
			
			txtOutput = new TextField();
			txtOutput.mouseEnabled = false;
			txtOutput.textColor = 0xffffff;
			txtOutput.background = true;
			txtOutput.backgroundColor = 0x000000;
			txtOutput.defaultTextFormat = txtFormat;
			if (!viewFinderData.settings.showDirection) {
				txtOutput.height = 48;
			}else {
				txtOutput.height = 60;
			}
			txtOutput.width = 105;
			addChild(txtOutput);
			
			
			
			
			
			if (viewFinderData.settings.showDirection) {
				var panoramaEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.events.PanoramaEvent") as Class;
				qjPlayer.manager.addEventListener(panoramaEventClass.PANORAMA_STARTED_LOADING, onPanoramaStartedLoading, false, 0, true);
			}
			if (viewFinderData.settings.useCursor) {
				stage.addEventListener(Event.ENTER_FRAME, enterFrameHandlerCursor, false, 0, true);
			}else{
				stage.addEventListener(Event.ENTER_FRAME, enterFrameHandlerDot, false, 0, true);
			}
			stage.addEventListener(MouseEvent.CLICK,clickFrameHandlerCursor, false, 0, true);
			
			var ViewEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panosalado.events.ViewEvent") as Class;
			qjPlayer.manager.addEventListener(ViewEventClass.BOUNDS_CHANGED, handleResize, false, 0, true);
			handleResize();
		}
		
		private function onPanoramaStartedLoading(panoramaEvent:Object):void {
			currentDirection = qjPlayer.manager.currentPanoramaData.direction;
		}
		
		private function enterFrameHandlerDot(event:Event):void {
			if(viewFinderData.settings.isShow==true)
			{
				if (viewFinderData.settings.showDirection) {
					txtOutput.text = "pan  " + qjPlayer.manager._pan.toFixed(2) +
					"\ntilt " + qjPlayer.manager._tilt.toFixed(2) +
					"\nfov  " + qjPlayer.manager._fieldOfView.toFixed(2) +
					"\ndir  " + validateDir(qjPlayer.manager.pan + currentDirection).toFixed(2);
				}else{
					txtOutput.text = "pan  " + qjPlayer.manager._pan.toFixed(2) +
					"\ntilt " + qjPlayer.manager._tilt.toFixed(2) +
					"\nfov  " + qjPlayer.manager._fieldOfView.toFixed(2);
				}
			}
			else
			{
				txtOutput.visible=false;
			}
			if(ExternalInterface.available == true)
			{
				ExternalInterface.call("enterFrameHandlerDot",  qjPlayer.manager._pan.toFixed(2),qjPlayer.manager._tilt.toFixed(2),qjPlayer.manager._fieldOfView.toFixed(2));
			}
		}
		
		private function enterFrameHandlerCursor(event:Event):void {
			
			if(viewFinderData.settings.isShow==true)
			{
				if (viewFinderData.settings.showDirection) {
					txtOutput.text = "pan  " + getCursorPan().toFixed(2) +
					"\ntilt " + getCursorTilt().toFixed(2) +
					"\nfov  " + qjPlayer.manager._fieldOfView.toFixed(2) +
					"\ndir  " + validateDir(getCursorPan() + currentDirection).toFixed(2);
				}else {
					txtOutput.text = "pan  " + getCursorPan().toFixed(2) +
					"\ntilt " + getCursorTilt().toFixed(2) +
					"\nfov  " + qjPlayer.manager._fieldOfView.toFixed(2);
				}
			}
			else
			{
				txtOutput.visible=false;
			}
			if(ExternalInterface.available == true)
			{
				ExternalInterface.call("enterFrameHandlerCursor", getCursorPan().toFixed(2),getCursorTilt().toFixed(2), qjPlayer.manager._fieldOfView.toFixed(2));
			}
		}
		
		private function clickFrameHandlerCursor(event:MouseEvent):void {
			
			if(viewFinderData.settings.isShow==true)
			{
				if (viewFinderData.settings.showDirection) {
					txtOutput.text = "pan  " + getCursorPan().toFixed(2) +
						"\ntilt " + getCursorTilt().toFixed(2) +
						"\nfov  " + qjPlayer.manager._fieldOfView.toFixed(2) +
						"\ndir  " + validateDir(getCursorPan() + currentDirection).toFixed(2);
				}else {
					txtOutput.text = "pan  " + getCursorPan().toFixed(2) +
						"\ntilt " + getCursorTilt().toFixed(2) +
						"\nfov  " + qjPlayer.manager._fieldOfView.toFixed(2);
				}
			}
			else
			{
				txtOutput.visible=false;
			}
			if(ExternalInterface.available == true)
			{
				ExternalInterface.call("clickFrameHandlerCursor", getCursorPan().toFixed(2),getCursorTilt().toFixed(2), qjPlayer.manager._fieldOfView.toFixed(2));
			}
		}
		
		// w = sw /2  
		
		// tan (fieldofview/2) = (wallsize/2)/projectionPlaneDistance =
		//Math.tan(qjPlayer.manager.fieldOfView * 0.5 * __toRadians) / (qjPlayer.manager.boundsWidth * 0.5)) 
		// ==> w/f /w
		// ==> 1/f
		// ==> (qjPlayer.manager.mouseX - qjPlayer.manager.boundsWidth * 0.5) = A ==> A/f == tanx
		private function getCursorPan():Number {
			return validatePanTilt( qjPlayer.manager._pan +
				Math.atan((qjPlayer.manager.mouseX - qjPlayer.manager.boundsWidth * 0.5)
				* Math.tan(qjPlayer.manager.fieldOfView * 0.5 * __toRadians) / (qjPlayer.manager.boundsWidth * 0.5)) * __toDegrees);
		}
		
		private var verticalFieldOfView:Number
		private function getCursorTilt():Number {
			verticalFieldOfView = __toDegrees * 2 * Math.atan((qjPlayer.manager.boundsHeight / qjPlayer.manager.boundsWidth)
				* Math.tan(__toRadians * 0.5 * qjPlayer.manager.fieldOfView));
			return validatePanTilt( qjPlayer.manager._tilt -
				Math.atan(( qjPlayer.manager.mouseY - qjPlayer.manager.boundsHeight * 0.5)
				* Math.tan(verticalFieldOfView * 0.5 * __toRadians) / (qjPlayer.manager.boundsHeight * 0.5)) * __toDegrees);
		}
		
		private function validateDir(value:Number):Number {
			if ( value <= 0 || value > 360 ) return ((value + 360) % 360);
			return value;
		}
		
		private function validatePanTilt(value:Number):Number {
			if (value <= -180) value = (((value + 180) % 360) + 180);
			if (value > 180) value = (((value + 180) % 360) - 180);
			return value;
		}
		
		private function handleResize(e:Event = null):void {
			if (viewFinderData.settings.align.horizontal == Align.LEFT) {
				txtOutput.x = 0;
			}else if (viewFinderData.settings.align.horizontal == Align.RIGHT) {
				txtOutput.x = qjPlayer.manager.boundsWidth - txtOutput.width;
			}else { // CENTER
				txtOutput.x = (qjPlayer.manager.boundsWidth - txtOutput.width) * 0.5;
			}
			if (viewFinderData.settings.align.vertical == Align.TOP){
				txtOutput.y = 0;
			}else if (viewFinderData.settings.align.vertical == Align.BOTTOM) {
				txtOutput.y = qjPlayer.manager.boundsHeight - txtOutput.height;
			}else { // MIDDLE
				txtOutput.y = (qjPlayer.manager.boundsHeight - txtOutput.height) * 0.5;
			}
			txtOutput.x += viewFinderData.settings.move.horizontal;
			txtOutput.y += viewFinderData.settings.move.vertical;
			
			if(pointer != null){
				pointer.x = (qjPlayer.manager.boundsWidth) * 0.5;
				pointer.y = (qjPlayer.manager.boundsHeight) * 0.5;
			}
		}
		
		private var __toDegrees:Number = 180 / Math.PI;
		private var __toRadians:Number = Math.PI / 180;
		
		
		
		
		
		
		
		
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////
		//  Exposed functions 
		///////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function setActive(name:String, active:Boolean):void {
			
		}
		
		
	}
}

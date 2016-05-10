/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.jsgateway {
	
	import com.panozona.modules.jsgateway.data.JSGatewayData;
	import com.panozona.modules.jsgateway.data.structure.ASFunction;
	import com.panozona.modules.jsgateway.data.structure.JSFunction;
	import com.panozona.player.module.Module;
	import com.panozona.player.module.data.ModuleData;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.system.ApplicationDomain;
	import flash.system.Security;
	import flash.utils.Timer;

	
	public class JSGateway extends Module{
		
		private var jsgatewayData:JSGatewayData;
		private var pointer:Sprite;
		private var firstPanorama:String=null;
		private var panoramaEventClass:Class;
		
		
		
		public function JSGateway(){
			super("JSGateway", "1.3.2", "http://ouwei.cn/wiki/Module:JSGateway");
			moduleDescription.addFunctionDescription("run", String);
		}
		
		override protected function moduleReady(moduleData:ModuleData):void {
			
			//visible = false;
			visible = true;
			
			if (!ExternalInterface.available) {
				printError("ExternalInterface not avaible");
				return;
			}
			
			
			
			
		//	ExternalInterface.addCallback("runAction", qjPlayer.manager.runAction);
			ExternalInterface.addCallback("runMoveViewChange",runMoveViewChange);
			ExternalInterface.addCallback("runMoveViewChangeSearch",runMoveViewChangeSearch);
			
			if(moduleData == null)
			{
				return;
			}
			jsgatewayData = new JSGatewayData(moduleData, qjPlayer);
			drawpoint();
			
			
			for each (var asfunction:ASFunction in jsgatewayData.asfuncttions.getChildrenOfGivenClass(ASFunction)) {
				try {
					ExternalInterface.addCallback(asfunction.name, getReference(asfunction.callback) as Function);
				}catch (e:Error) {
					printWarning("Could not expose asfunction: " + asfunction.name +", " + e.message);
				}
			}
			
			var panoramaEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.events.PanoramaEvent") as Class;
			this.panoramaEventClass = panoramaEventClass;
			
			
			if(jsgatewayData.settings.callOnEnter){

				qjPlayer.manager.addEventListener(panoramaEventClass.PANORAMA_LOADED, onPanoramaLoaded, false, 0, true);
			}
			if(jsgatewayData.settings.callOnTransitionEnd){
				qjPlayer.manager.addEventListener(panoramaEventClass.TRANSITION_ENDED, onTransitionEnded, false, 0, true);
			}
			if(jsgatewayData.settings.callOnMoveEnd){
				var panoSaladoEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panosalado.events.PanoSaladoEvent") as Class;
				qjPlayer.manager.addEventListener(panoSaladoEventClass.SWING_TO_COMPLETE, onMoveEnded, false, 0, true);
				qjPlayer.manager.addEventListener(panoSaladoEventClass.SWING_TO_CHILD_COMPLETE, onMoveEnded, false, 0, true);
			}
			if(jsgatewayData.settings.callOnViewChange){
				qjPlayer.manager.addEventListener(panoramaEventClass.PANORAMA_STARTED_LOADING, onPanoramaStartedLoading, false, 0, true);
				stage.addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
			}
			
			var ViewEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panosalado.events.ViewEvent") as Class;
			qjPlayer.manager.addEventListener(ViewEventClass.BOUNDS_CHANGED, handleResize, false, 0, true);
			handleResize();
		}
		
		private function drawpoint():void	
		{
			pointer = new Sprite();
			pointer.graphics.beginFill(0x000000);
			pointer.graphics.drawCircle(0, 0,4);
			pointer.graphics.endFill();
			pointer.mouseEnabled = false;
			
			addChild(pointer);
			
			
			pointer.visible=false;
		}
		private function handleResize(e:Event = null):void {
			
			pointer.x = (qjPlayer.manager.boundsWidth) * 0.5;
			pointer.y = (qjPlayer.manager.boundsHeight) * 0.5;
			
		}
		private var pan:Number;
		private var tilt:Number;
		private var fov:Number;
		private var p:Boolean;
		private function runMoveViewChange(pan:Number,tilt:Number,p:Boolean=false,pano:String="",fov:Number=30):void
		{
			pointer.visible=true;
			this.pan = pan;
			this.tilt = tilt;
			this.p = p;
			this.fov =fov;
			
			if(pano != "" && pano != qjPlayer.manager.currentPanoramaData.id )
			{
				qjPlayer.manager.addEventListener(panoramaEventClass.PANORAMA_LOADED, onPanoramaLoaded_runmove, false, 0, true);
				
				qjPlayer.manager.loadPanoramaById(pano);
				
				return;
			}
			
			if(p==true)
			{
				qjPlayer.manager.renderAt(pan, tilt, fov);
			}
			else
			{
				qjPlayer.manager.moveToView(pan,tilt,fov);
			}
			//qjPlayer.manager.moveToViewThenFunction(pan,tilt,fov,swingComplete);
			swingComplete();
		}
		
		
		private function runMoveViewChangeSearch(pano:String):void
		{
			var pano_tmp:String = pano;
			
			for each(var panoramaData:* in qjPlayer.manager.managerData.panoramasData) {
				var panoid:String = panoramaData.id;
				if(panoid.indexOf("pa"+pano+"_") > -1)
				{
					runMoveViewChange(0,0,true,panoid,90);
					
					return;
				}
				
			}
			return ;
			
			
			
		}
		
		
		
		private function onPanoramaLoaded_runmove(panoramaEvent:Object):void {
			
			printWarning("loading");
			
			qjPlayer.manager.renderAt(this.pan, this.tilt, this.fov);
			
			printWarning("loaded"+this.pan+":"+this.tilt+":"+this.fov);
			
			qjPlayer.manager.removeEventListener(panoramaEventClass.PANORAMA_LOADED, onPanoramaLoaded_runmove);
		}
		
		private function  swingComplete():void
		{
			var timer:Timer = new Timer(8000,1);
			timer.addEventListener(TimerEvent.TIMER, function():void { pointer.visible=false; }, false, 0, true);
			timer.start();
		}
		
		private function onPanoramaStartedLoading(panoramaEvent:Object):void {
			__currentDirection = qjPlayer.manager.currentPanoramaData.direction;
		}
		
		private function onPanoramaLoaded(panoramaEvent:Object):void {
			if(firstPanorama == null)
			{
				ExternalInterface.call("onFirstEnter", qjPlayer.manager.currentPanoramaData.id);
			}
			firstPanorama = qjPlayer.manager.currentPanoramaData.id;
			ExternalInterface.call("onEnter", qjPlayer.manager.currentPanoramaData.id);
			
		}
		
		private function onTransitionEnded(panoramaEvent:Object):void {
			ExternalInterface.call("onTransitionEnd", qjPlayer.manager.currentPanoramaData.id);
		}
		
		private function onMoveEnded(panoSaladoEvent:Object):void {
			ExternalInterface.call("onMoveEnd", qjPlayer.manager.currentPanoramaData.id);
		}
		
		private var __pan:Number = 0;
		private var __tilt:Number = 0;
		private var __fov:Number = 0;
		private var __currentDirection:Number = 0;
		private function onEnterFrame(e:Event):void {
			if (__pan == qjPlayer.manager._pan && __tilt == qjPlayer.manager._tilt && __fov == qjPlayer.manager._fieldOfView) return;
			__pan = qjPlayer.manager._pan;
			__tilt = qjPlayer.manager._tilt;
			__fov = qjPlayer.manager._fieldOfView;
			ExternalInterface.call("onViewChange", __pan.toFixed(0), __tilt.toFixed(0), __fov.toFixed(0), __currentDirection.toFixed(0));
		}
		
		private function getReference(input:String):Object {
			return getReferenceR(input.split("."), 0, this);
		}
		
		private function getReferenceR(path:Array, currentIndex:int, inputObject:Object):Object {
			if (currentIndex < path.length) {
				return getReferenceR(path, currentIndex + 1, autocall(inputObject, path[currentIndex]));
			}else {
				return inputObject;
			}
		}
		
		private function autocall(obj:Object, next:String):Object {
			if (next.match(/^.+\(.*\)$/)) {
				return (obj[next.match(/^.+(?=\()/)[0]] as Function).apply(this, ((next.match(/(?<=\()(.+)(?=\))/)[0]) as String).split(","));
			}else {
				return obj[next];
			}
		}
		
///////////////////////////////////////////////////////////////////////////////
//  Exposed functions 
///////////////////////////////////////////////////////////////////////////////
		
		public function run(jsfunctionId:String):void {
			for each(var jsfunction:JSFunction in jsgatewayData.jsfuncttions.getChildrenOfGivenClass(JSFunction)) {
				if (jsfunction.id == jsfunctionId) {
					if (jsfunction.text == null){
						ExternalInterface.call(jsfunction.name);
					}else {
						ExternalInterface.call(jsfunction.name, jsfunction.text);
					}
					return;
				}
			}
			printWarning("Calling nonexistant jsfunction: " + jsfunctionId);
		}
	}
}
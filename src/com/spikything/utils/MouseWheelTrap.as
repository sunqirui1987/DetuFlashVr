package com.spikything.utils {
	
	import com.panozona.player.module.global;
	
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Point;
	
	/**
	 * MouseWheelTrap - Simultaneous browser/Flash mousewheel scroll issue work-around
	 * This software is released under the MIT License http://www.opensource.org/licenses/mit-license.php
	 * (c) 2009 spikything.com see http://www.spikything.com/blog/?s=mousewheeltrap for updates
	 * @version 0.1
	 * @author Liam O'Donnell
	 * @usage Simply call the static method MouseWheelTrap.setup(stage)
	 */
	public class MouseWheelTrap {
		
		private static var _mouseWheelTrapped :Boolean;
		private static var _stage:Stage;
		
		private static var rand:String = (Math.floor(10*Math.random()+100*Math.random()+200*Math.random()+1000*Math.random())+20000).toString(); 
		
		public static function setup(stage:Stage):void {
			_stage = stage;
			_stage.addEventListener(MouseEvent.MOUSE_OVER, function():void {allowBrowserScroll(false);});
			_stage.addEventListener(Event.MOUSE_LEAVE, function():void {allowBrowserScroll(true);});
		
			try
			{
			
				if(ExternalInterface.available)
				{
					
					var ran:String = MouseWheelTrap.rand;
					ExternalInterface.addCallback("onMouseWheel"+ran,onMouseWheel);
				}
			} catch (error:Error) {
				
			}
		
		}
		
		private static function allowBrowserScroll(allow:Boolean):void {
			try
			{
				createMouseWheelTrap();
				if (ExternalInterface.available) {
					var ran:String = MouseWheelTrap.rand;
					ExternalInterface.call("allowBrowserScroll"+ran, allow);
				}
			} catch (error:Error) {
				
			}
		}
		
		private static function createMouseWheelTrap():void {
			/*
			if (_mouseWheelTrapped) {
				return;
			}
			_mouseWheelTrapped = true;
			if (ExternalInterface.available) {
				ExternalInterface.call("eval",
					"var browserScrolling;" +
					"function allowBrowserScroll(value){" + 
						"browserScrolling = value;" +
					"}" +
					"function handle(delta){" +
						"if(!browserScrolling){" +
							"return false;" +
						"}" +
						"return true;" +
					"}" +
					"function wheel(event){" +
						
						"var delta = 0;" +
						"if(!event){" +
							"event = window.event;" +
						"}" +
						"if(event.wheelDelta){" +
							"delta = event.wheelDelta / 120;" +
							"if(window.opera){" +
								"delta = -delta;" +
							"}" +
						"}else if(event.detail){" +
							"delta = -event.detail / 3;" +
						"}" +
						"if(delta){" +
							"handle(delta);" +
						"}" +
						"if(!browserScrolling){" +
							"if(event.preventDefault){" +
								"event.preventDefault();" +
							"}" +
							"event.returnValue = false;" +
						"}" +
					"}" +
					"if(window.addEventListener){" +
						"window.addEventListener('DOMMouseScroll', wheel, false);" +
					"}" +
					"window.onmousewheel = document.onmousewheel = wheel;" +
					"allowBrowserScroll(true);"
				);
			}
			*/
			
			
			if (_mouseWheelTrapped) {
				return;
			}
			_mouseWheelTrapped = true;
			if (ExternalInterface.available) {
				var ran:String = MouseWheelTrap.rand;
			//	ExternalInterface.call("eval", "var browserScrolling;function allowBrowserScroll(value){browserScrolling=value;}function handle(delta){if(!browserScrolling){return false;}return true;}function wheel(event){var delta=0;if(!event){event=window.event;}if(event.wheelDelta){delta=event.wheelDelta/120;if(window.opera){delta=-delta;}}else if(event.detail){delta=-event.detail/3;}if(delta){handle(delta);}if(!browserScrolling){if(event.preventDefault){event.preventDefault();}event.returnValue=false;var flashs=document.getElementsByTagName('object');for(var i=0;i<flashs.length;++i){flashs[i].onMouseWheel(delta);}}}if(window.addEventListener){window.addEventListener('DOMMouseScroll',wheel,false);}window.onmousewheel=document.onmousewheel=wheel;allowBrowserScroll(true);");
				ExternalInterface.call("eval", "var browserScrolling"+ran+";" +
					"function allowBrowserScroll"+ran+"(value)" +
					"{" +
						"browserScrolling"+ran+"=value;" +
					"}" +
					"" +
					"function handle(delta){" +
						"if(!browserScrolling"+ran+")" +
						"{" +
							"return false;" +
						"}" +
						"return true;" +
					"}" +
					"" +
					"function wheel"+ran+"(event){" +
					"var delta=0;" +
					"if(!event){event=window.event;}" +
					"if(event.wheelDelta)" +
					"{" +
						"delta=event.wheelDelta/120;" +
						"if(window.opera){delta=-delta;}" +
					"}" +
					"else if(event.detail){delta=-event.detail/3;}" +
					"" +
					"if(delta){handle(delta);}" +
					"" +
					"if(!browserScrolling"+ran+"){" +
						"if(event.preventDefault){event.preventDefault();}" +
						"event.returnValue=false;" +
						"var flashs=document.getElementsByTagName('object');" +
						"for(var i=0;i<flashs.length;++i){" +
							"if(flashs[i].onMouseWheel"+ran+")" +
							"{" +
								"flashs[i].onMouseWheel"+ran+"(delta);" +
							"}" +
						"}" +
						"}" +
					"}" +
					"" +
					"if(window.addEventListener){" +
					"window.addEventListener('DOMMouseScroll',wheel"+ran+",false);" +
					"}" +
					"window.onmousewheel=document.onmousewheel=wheel"+ran+";" +
					"allowBrowserScroll"+ran+"(true);");
				
			}
		}
		

		
		private static function onMouseWheel(delta:int):void
		{
			if(!global.MOUSE_ENABLE)
				return;
			var objects:Array = _stage.getObjectsUnderPoint(new Point(_stage.mouseX, _stage.mouseY));
			var i:int, len:int, object:DisplayObject;
			len = objects.length;
			var hasImageMap:Boolean;
			for(i = 0; i < len; ++i) {
				object = objects[i];
				if(isImageMap(object))
					hasImageMap = true;
			}
			for(i = 0; i < len; ++i) {
				object = objects[i];
				if(hasImageMap){
					if(isImageMap(object))
						object.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_WHEEL, true, false, object.mouseX, object.mouseY, null, false, false, false, false, delta));
				}else{
					object.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_WHEEL, true, false, object.mouseX, object.mouseY, null, false, false, false, false, delta));
				}
			}
		}
		
		private static function isImageMap(obj:Object):Boolean{
			if(obj.hasOwnProperty("moduleDescription") && obj.moduleDescription.name == "ImageMap")
				return true;
			if(!obj.parent)
				return false;
			return isImageMap(obj.parent);
		}
	}
}
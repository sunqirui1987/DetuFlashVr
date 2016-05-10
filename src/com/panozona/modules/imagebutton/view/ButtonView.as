/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.imagebutton.view{
	
	import com.panozona.modules.imagebutton.model.WindowData;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	public class ButtonView extends Sprite{
		
		private var _windowData:WindowData;
		
		public const subButtonsContainer:Sprite = new Sprite();
		
		private var tipsprite:DisplayObject;
		
		private var tip_isenable:Boolean=false;
		
		public function ButtonView(windowData:WindowData) {
			_windowData = windowData;
			if (_windowData.button.action != null) {
				buttonMode = true;
			}
			if (_windowData.button.jsaction != null) {
				buttonMode = true;
			}

			addChild(subButtonsContainer);
			
			addEventListener(MouseEvent.MOUSE_OVER,onMouseOver,false,0,true);
			addEventListener(MouseEvent.MOUSE_OUT,onMouseOut,false,0,true);
		}
		
		public function get windowData():WindowData {
			return _windowData;
		}
		
		private function onMouseOut(e:MouseEvent):void {
			tip_isenable=false;
			if(tipsprite != null)
			{
				tipsprite.visible=false;
			}
		}
		
		private function onMouseOver(e:MouseEvent):void {
			
			var tipurl:String = _windowData.button.tipurl;
			if(tipurl != "")
			{
				
				tip_isenable=true;
				if(tipsprite!=null && this.contains(tipsprite))
				{
					tipsprite.visible=true;
					return;
				}

				var load:Loader=new Loader();
				load.contentLoaderInfo.addEventListener(Event.COMPLETE,completehandler);
				load.load(new URLRequest(tipurl), new LoaderContext(true,ApplicationDomain.currentDomain));
				
				
				
				
			}
			
		}
		
		
		private function completehandler(e:Event):void
		{
			if( tip_isenable==true)
			{
				tipsprite = (e.target).content;
				tipsprite.x = 0;
				tipsprite.y = -tipsprite.height;
				
				addChild(tipsprite);
				
				
			}
		}
	}
}
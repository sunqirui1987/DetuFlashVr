/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.buttonbar.view{
	
	import com.panozona.modules.buttonbar.model.ButtonBarData;
	import com.panozona.modules.buttonbar.model.ButtonData;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.Timer;
	
	public class ButtonView extends Sprite{
		
		public const bitmap:Bitmap = new Bitmap();
		
		private var _buttonData:ButtonData;
		private var _buttonBarData:ButtonBarData;
		
		private var _bitmapDataPlain:BitmapData;
		private var _bitmapDataActive:BitmapData;
		
		private var tipsprite:DisplayObject;
		
		private var tip_isenable:Boolean=false;
		
		public function ButtonView(buttonData:ButtonData, buttonBarData:ButtonBarData){
			_buttonData = buttonData;
			_buttonBarData = buttonBarData;
			
			buttonMode = true;
			
			addChild(bitmap);
			
			addEventListener(MouseEvent.MOUSE_DOWN, onMousePress, false, 0, true);
			addEventListener(MouseEvent.MOUSE_UP, onMouseRelease, false, 0, true);
			addEventListener(MouseEvent.ROLL_OUT, onMouseRelease, false, 0, true);
			
			addEventListener(MouseEvent.MOUSE_OVER,onMouseOver,false,0,true);
			addEventListener(MouseEvent.MOUSE_OUT,onMouseOut,false,0,true);
		}
		
		public function get buttonData():ButtonData {
			return _buttonData;
		}
		
		public function get buttonBarData():ButtonBarData {
			return _buttonBarData;
		}
		
		public function set bitmapDataPlain(value:BitmapData):void {
			_bitmapDataPlain = value;
			if(!_buttonData.isActive){
				setPlain();
			}
		}
		
		public function set bitmapDataActive(value:BitmapData):void {
			_bitmapDataActive = value;
			if (_buttonData.isActive) {
				setActive();
			}
		}
		
		public function setPlain():void {
			if(_bitmapDataPlain != null){
				bitmap.bitmapData = _bitmapDataPlain;
			}
		}
		
		public function setActive():void {
			if(_bitmapDataActive != null){
				bitmap.bitmapData = _bitmapDataActive;
			}
		}
		
		private function onMousePress(e:MouseEvent):void {
			_buttonData.mousePress = true;
		}
		
		private function onMouseRelease(e:MouseEvent):void {
			_buttonData.mousePress = false;
			
			tip_isenable=false;
			if(tipsprite != null)
			{
				tipsprite.visible=false;
				tip_isenable=false;
			}
		}
		
		private function onMouseOut(e:MouseEvent):void {
			tip_isenable=false;
			if(tipsprite != null)
			{
				tipsprite.visible=false;
			}
			//this._buttonData.isActive = false;
		}
		
		private function onMouseOver(e:MouseEvent):void {
		//	this._buttonData.isActive = true;
			var tipurl:String = _buttonData.button.tipurl;
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
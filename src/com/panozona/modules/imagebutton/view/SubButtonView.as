/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.imagebutton.view{
	
	import com.panozona.modules.imagebutton.model.SubButtonData;
	import com.panozona.modules.imagebutton.model.WindowData;
	import flash.events.MouseEvent;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	public class SubButtonView extends Sprite{
		
		public const bitmap:Bitmap = new Bitmap();
		
		private var _subButtonData:SubButtonData;
		private var _windowData:WindowData;
		
		public function SubButtonView(subButtonData:SubButtonData, windowData:WindowData){
			_subButtonData = subButtonData;
			_windowData = windowData;
			
			bitmap.x = subButtonData.subButton.move.horizontal;
			bitmap.y = subButtonData.subButton.move.vertical;
			addChild(bitmap);
			
			if (subButtonData.subButton.action != null) {
				buttonMode = true;
			}
			
			addEventListener(MouseEvent.MOUSE_DOWN, onMousePress, false, 0, true);
			addEventListener(MouseEvent.MOUSE_UP, onMouseRelease, false, 0, true);
			addEventListener(MouseEvent.ROLL_OUT, onMouseRelease, false, 0, true);
		}
		
		public function get subButtonData():SubButtonData {
			return _subButtonData;
		}
		
		public function get windowData():WindowData {
			return _windowData;
		}
		
		private function onMousePress(e:MouseEvent):void {
			_subButtonData.mousePress = true;
		}
		
		private function onMouseRelease(e:MouseEvent):void {
			_subButtonData.mousePress = false;
		}
	}
}
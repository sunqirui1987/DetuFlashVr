/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.imagemap.view {
	
	import com.panozona.modules.imagemap.model.NavigationData;
	import com.panozona.modules.imagemap.model.ViewerData;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class NavigationView extends Sprite {
		
		private var bitmap:Bitmap;
		private var _bitmapDataActive:BitmapData;
		private var _bitmapDataPlain:BitmapData;
		
		private var _navigationData:NavigationData;
		private var _viewerData:ViewerData;
		
		public function NavigationView(navigationData:NavigationData, viewerData:ViewerData){
			_navigationData = navigationData;
			_viewerData = viewerData;
			buttonMode = true;
			
			bitmap = new Bitmap();
			
			addChild(bitmap);
//			addEventListener(MouseEvent.MOUSE_DOWN, onMousePress, false, 0, true);
//			addEventListener(MouseEvent.MOUSE_UP, onMouseRelease, false, 0, true);
			addEventListener(MouseEvent.ROLL_OUT, onMouseRelease, false, 0, true);
			addEventListener(MouseEvent.ROLL_OVER, onMousePress, false, 0, true);
		}
		
		public function get navigationData():NavigationData{
			return _navigationData;
		}
		
		public function get viewerData():ViewerData {
			return _viewerData;
		}
		
		public function set bitmapDataPlain(value:BitmapData):void {
			_bitmapDataPlain = value;
			if (!_navigationData.isActive) {
				bitmap.bitmapData = _bitmapDataPlain;
			}
		}
		
		public function set bitmapDataActive(value:BitmapData):void {
			_bitmapDataActive = value;
			if (_navigationData.isActive) {
				bitmap.bitmapData = _bitmapDataActive;
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
			_navigationData.isActive = true;
		}
		
		private function onMouseRelease(e:MouseEvent):void {
			_navigationData.isActive = false;
		}
	}
}
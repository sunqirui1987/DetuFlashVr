/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.zoomslider.model {
	
	import com.panozona.modules.zoomslider.events.SliderEvent;
	import com.panozona.modules.zoomslider.model.structure.Slider;
	import flash.events.EventDispatcher;
	
	public class SliderData extends EventDispatcher{
		
		public const slider:Slider = new Slider();
		
		private var _zoomIn:Boolean;
		private var _zoomOut:Boolean;
		
		private var _maxFov:Number;
		private var _minFov:Number;
		
		private var _mouseDrag:Boolean;
		
		public function get zoomIn():Boolean {return _zoomIn;}
		public function set zoomIn(value:Boolean):void {
			if (value == _zoomIn) return;
			_zoomIn = value;
			dispatchEvent(new SliderEvent(SliderEvent.CHANGED_ZOOM));
		}
		
		public function get zoomOut():Boolean {return _zoomOut;}
		public function set zoomOut(value:Boolean):void {
			if (value == _zoomOut) return;
			_zoomOut = value;
			dispatchEvent(new SliderEvent(SliderEvent.CHANGED_ZOOM));
		}
		
		public function get maxFov():Number {return _maxFov;}
		public function set maxFov(value:Number):void {
			if (isNaN(value) || value == _maxFov) return;
			_maxFov = value;
			dispatchEvent(new SliderEvent(SliderEvent.CHANGED_FOV_LIMIT));
		}
		
		public function get minFov():Number {return _minFov;}
		public function set minFov(value:Number):void {
			if (isNaN(value) || value == _minFov) return;
			_minFov = value;
			dispatchEvent(new SliderEvent(SliderEvent.CHANGED_FOV_LIMIT));
		}
		
		public function get mouseDrag():Boolean {return _mouseDrag;}
		public function set mouseDrag(value:Boolean):void {
			if (value == _mouseDrag) return;
			_mouseDrag = value;
			dispatchEvent(new SliderEvent(SliderEvent.CHANGED_MOUSE_DRAG));
		}
	}
}
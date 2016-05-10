
package com.panosalado.controller{
	
	import com.panosalado.controller.ICamera;
	import com.panosalado.core.PanoSalado;
	import com.panosalado.events.ViewEvent;
	import com.panosalado.model.Characteristics;
	import com.panosalado.model.SimpleTransitionData;
	import com.panosalado.model.ViewData;
	import com.panosalado.utils.Animation;
	import com.panosalado.utils.AnimationFilter;
	import com.panosalado.utils.Filter;
	import com.panosalado.utils.SkewTransform;
	import com.panozona.player.module.global;
	import com.robertpenner.easing.Expo;
	import com.robertpenner.easing.Linear;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filters.DisplacementMapFilter;
	import flash.geom.Point;
	
	public class SimpleTransition extends EventDispatcher implements ICamera {
		
		Linear;
		Expo;
		
		protected var _data:SimpleTransitionData;
		protected var _viewData:ViewData;
		
		public function SimpleTransition(){
		}
		
		public function processDependency(reference:Object,characteristics:*):void {
			if (characteristics == Characteristics.SIMPLE_TRANSITION_DATA) data = reference as SimpleTransitionData;
			else if (characteristics == Characteristics.VIEW_DATA) viewData = reference as ViewData;
		}
		
		public function get data():SimpleTransitionData { return _data; }
		public function set data(value:SimpleTransitionData):void {
			if (value === _data) return;
			_data = value;
		}
		
		public function get viewData():ViewData { return _viewData; }
		public function set viewData(value:ViewData):void {
			if (value === _viewData) return;
			if (value != null){
				value.addEventListener(ViewEvent.PATH, catchFirstRender, false, 0, true);
			}else{
				_viewData.removeEventListener(ViewEvent.PATH, catchFirstRender);
			}
			_viewData = value;
		}
		
		protected function catchFirstRender(e:ViewEvent):void {
			if (_data == null) return;
			e.preventDefault(); //NB must call this to keep the secondary pano until transition is over.
			_viewData.addEventListener(ViewEvent.RENDERED, startTransition, false, 0, true);
		}
		
		protected var counter:int = 0;
		protected function startTransition(e:ViewEvent):void {
			var canvas:Sprite = e.canvas;
			if (canvas == null) return;
			_viewData.removeEventListener(ViewEvent.RENDERED, startTransition);
			
//			var bd:BitmapData = new BitmapData(canvas.width/2, canvas.height/2);
//			bd.draw(canvas);
//			var bmp:Bitmap = new Bitmap(bd);
//			canvas.addChild(bmp);
//			
//			var alphaTransition:AnimationFilter = new AnimationFilter(bd,"twirlFilter", Vector.<String>(["amount"]), Vector.<Number>([1]), Vector.<Number>([3]), 2);
//			alphaTransition.addEventListener(Event.COMPLETE, endTransition, false, 0, true);
			
		
			if(global.IS_WALK_AWARD_EFFECT_NOW){
				global.IS_WALK_AWARD_EFFECT_NOW = false;
				while ((_viewData as PanoSalado).background.numChildren) {
					(_viewData as PanoSalado).background.removeChildAt(0);
				}
				dispatchEvent(new Event(Event.COMPLETE));
				return;
			}
			
			canvas[_data.property] = _data.startValue;
			counter++;
			var alphaTransition:Animation = new Animation(canvas, Vector.<String>([_data.property]), Vector.<Number>([_data.endValue]), _data.time, _data.tween);
			alphaTransition.addEventListener(Event.COMPLETE, endTransition, false, 0, true);			

		}
		
		protected function endTransition(e:Event):void {
			_viewData.secondaryViewData.path = null; // this is what the default PATH handler WOULD have done.
			(e.target as EventDispatcher).removeEventListener(Event.COMPLETE, endTransition);
			if (counter == 1) {
				while ((_viewData as PanoSalado).background.numChildren) {
					(_viewData as PanoSalado).background.removeChildAt(0);
				}
				dispatchEvent(new Event(Event.COMPLETE));
			}
			counter--;
		}
	}
}
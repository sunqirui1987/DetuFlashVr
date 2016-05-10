/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.menuscroller.controller {
	
	import com.panozona.modules.menuscroller.events.ElementEvent;
	import com.panozona.modules.menuscroller.model.ElementData;
	import com.panozona.modules.menuscroller.model.structure.Element;
	import com.panozona.modules.menuscroller.model.structure.Expand;
	import com.panozona.modules.menuscroller.model.structure.ExtraElement;
	import com.panozona.modules.menuscroller.view.ElementView;
	import com.panozona.player.module.Module;
	import com.panozona.player.module.data.property.Size;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	import caurina.transitions.Tweener;
	
	public class ElementController {
		
		private var contentInitScale:Number;
		
		private var _elementView:ElementView;
		private var _module:Module;
		
		public function ElementController(elementView:ElementView, module:Module) {
			_elementView = elementView;
			_module = module;
			
			elementView.elementData.addEventListener(ElementEvent.CHANGED_IS_SHOWING, handleIsShowingChange, false, 0, true);
			
			if (elementView.elementData.rawElement is Element){
				var panoramaEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.events.PanoramaEvent") as Class;
				_module.qjPlayer.manager.addEventListener(panoramaEventClass.PANORAMA_LOADED, onPanoramaLoaded, false, 0, true);
			}
		}
		
		private function onPanoramaLoaded(panoramaEvent:Object):void {
			if (_module.qjPlayer.manager.currentPanoramaData.id == (_elementView.elementData.rawElement as Element).target) {
				_elementView.elementData.isActive = true;
			}else {
				_elementView.elementData.isActive = false;
			}
		}
		
		private function handleIsShowingChange(e:Event):void {
			if (_elementView.elementData.isShowing) {
				if (_elementView.elementData.loaded) {
					_elementView.visible = true;
				}else {
					trace("_elementView.elementData.rawElement.path"+_elementView.elementData.rawElement.path);
					var imageLoader:Loader = new Loader();
					imageLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, imageLost, false, 0, true);
					imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoaded, false, 0, true);
					imageLoader.load(new URLRequest(_elementView.elementData.rawElement.path),new LoaderContext(true));
					_elementView.elementData.loaded = true;
				}
			}else {
				_elementView.visible = false;
			}
		}
		
		private function imageLost(error:IOErrorEvent):void {
			error.target.removeEventListener(IOErrorEvent.IO_ERROR, imageLost);
			error.target.removeEventListener(Event.COMPLETE, imageLoaded);
			_module.printError(error.text);
		}
		
		private function imageLoaded(e:Event):void {
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, imageLost);
			e.target.removeEventListener(Event.COMPLETE, imageLoaded);
			
			var displayObject:DisplayObject = e.target.content;
			
			var sp:Sprite = new Sprite();
			sp.addChild(displayObject);
			
			if (displayObject is Bitmap) {
				(displayObject as Bitmap).smoothing = true;
			}
			
			var size:Size = new Size(
				_elementView.elementData.scroller.scrollsVertical ? _elementView.elementData.scroller.sizeLimit : NaN,
				_elementView.elementData.scroller.scrollsVertical ? NaN : _elementView.elementData.scroller.sizeLimit);
			
			if (_elementView.elementData.scroller.scrollsVertical) { // constant width
				size.height = (displayObject.height * _elementView.elementData.scroller.sizeLimit) / displayObject.width;
				sp.scaleX = sp.scaleY = size.height / displayObject.height;
			} else { // constant height
				size.width = (displayObject.width * _elementView.elementData.scroller.sizeLimit) / displayObject.height;
				sp.scaleX = sp.scaleY = size.width / displayObject.width;
			}
			contentInitScale = sp.scaleX;
			_elementView.elementData.size = size; // ScrollerController listenes to size change
			_elementView.content = sp;
			
			
			//_elementView.addEventListener(MouseEvent.CLICK, handleMouseClick, false, 0, true);
			_elementView.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown, false, 0, true);
			_elementView.addEventListener(MouseEvent.MOUSE_UP, handleMouseUP, false, 0, true);
			
			_elementView.elementData.addEventListener(ElementEvent.CHANGED_IS_ACTIVE, handleMouseOverChange, false, 0, true);
			_elementView.elementData.addEventListener(ElementEvent.CHANGED_MOUSE_OVER, handleMouseOverChange, false, 0, true);
			handleMouseOverChange();
		}
		
		private var _mousepoint:Point = new Point();
		private function handleMouseDown(e:MouseEvent):void {
			_mousepoint = new Point(e.stageX,e.stageY);
		}
		
		private function handleMouseUP(e:MouseEvent):void {
			var upmousepoint:Point = new Point(e.stageX,e.stageY);
			
			if(Math.abs(upmousepoint.x - _mousepoint.x) < 2 && Math.abs(upmousepoint.y - _mousepoint.y) < 2)
			{
				if (_elementView.elementData.rawElement is Element){
					if(_elementView.elementData.rawElement.action != null)
					{
						_module.qjPlayer.manager.runAction(_elementView.elementData.rawElement.action);
					}
					else
					{
						if (_module.qjPlayer.manager.currentPanoramaData.id != (_elementView.elementData.rawElement as Element).target){
							_module.qjPlayer.manager.loadPanoThen((_elementView.elementData.rawElement as Element).target);
						}
					}
				}else{
					_module.qjPlayer.manager.runAction((_elementView.elementData.rawElement as ExtraElement).action);
				}
			}
		}
		
		private function handleMouseClick(e:Event):void {
		
			if (_elementView.elementData.rawElement is Element){
				if(_elementView.elementData.rawElement.action != null)
				{
					_module.qjPlayer.manager.runAction(_elementView.elementData.rawElement.action);
				}
				else
				{
					if (_module.qjPlayer.manager.currentPanoramaData.id != (_elementView.elementData.rawElement as Element).target){
						_module.qjPlayer.manager.loadPankThen((_elementView.elementData.rawElement as Element).target);
					}	
				}
				
			}else{
				_module.qjPlayer.manager.runAction(_elementView.elementData.rawElement.action);
			}
		}
		
		private function handleMouseOverChange(e:Event = null):void {
			if (_elementView.elementData.mouseOver) {
				onHover();
			}else {
				onPlain();
			}
		}
		
		private function onPlain():void {
			if (_elementView.elementData.isActive) {
				Tweener.addTween(_elementView._content, {
					scaleX: contentInitScale * ((_elementView.elementData.scroller.mouseOver.scale - 1)/2 + 1),
					scaleY: contentInitScale * ((_elementView.elementData.scroller.mouseOver.scale - 1)/2 + 1),
					x: -_elementView.elementData.size.width * ((_elementView.elementData.scroller.mouseOver.scale - 1)/2 + 1) * 0.5,
					y: -_elementView.elementData.size.height * ((_elementView.elementData.scroller.mouseOver.scale - 1)/2 + 1) * 0.5,
					time:_elementView.elementData.scroller.mouseOut.time * 0.5,
					transition:_elementView.elementData.scroller.mouseOut.transition
				});
			}else{
				_elementView.isSelect = false;
				Tweener.addTween(_elementView._content, {
					scaleX: contentInitScale,
					scaleY: contentInitScale,
					x: -_elementView.elementData.size.width * 0.5,
					y: -_elementView.elementData.size.height * 0.5,
					time:_elementView.elementData.scroller.mouseOut.time,
					transition:_elementView.elementData.scroller.mouseOut.transition
				});
			}
		}
		
		private function onHover():void {
			var s:Expand = _elementView.elementData.scroller.mouseOver
			if (_elementView.elementData.isActive) {
				Tweener.addTween(_elementView._content, {
					scaleX: contentInitScale * _elementView.elementData.scroller.mouseOver.scale,
					scaleY: contentInitScale * _elementView.elementData.scroller.mouseOver.scale,
					x: -_elementView.elementData.size.width * _elementView.elementData.scroller.mouseOver.scale * 0.5,
					y: -_elementView.elementData.size.height * _elementView.elementData.scroller.mouseOver.scale * 0.5,
					time:s.time * 0.5,
					transition:s.transition
				});
			}else {
				_elementView.isSelect = true;
//				var glowfilter:GlowFilter = _elementView._content.filters[0];
//				var baseXBlur:Number = glowfilter.blurX;
//				var baseYBlur:Number = glowfilter.blurY;
				Tweener.addTween(_elementView._content, {
					scaleX: contentInitScale * _elementView.elementData.scroller.mouseOver.scale,
					scaleY: contentInitScale * _elementView.elementData.scroller.mouseOver.scale,
					x: -_elementView.elementData.size.width * _elementView.elementData.scroller.mouseOver.scale * 0.5,
					y: -_elementView.elementData.size.height * _elementView.elementData.scroller.mouseOver.scale * 0.5,
					time:_elementView.elementData.scroller.mouseOver.time,
					transition:_elementView.elementData.scroller.mouseOver.transition
//					,
//					onUpdate:function():void{
//						glowfilter.blurX = baseXBlur*_elementView._content.scaleX;
//						glowfilter.blurY = baseYBlur*_elementView._content.scaleY;
//						_elementView._content.filters = [];
//						_elementView._content.filters = [glowfilter];
//						trace("glowfilter.blurX="+glowfilter.blurX);
//					}
				});
				
			}
		}
	}
}
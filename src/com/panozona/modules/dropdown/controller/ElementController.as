/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.dropdown.controller{
	
	import com.panozona.modules.dropdown.events.ElementEvent;
	import com.panozona.modules.dropdown.model.structure.Element;
	import com.panozona.modules.dropdown.model.structure.ExtraElement;
	import com.panozona.modules.dropdown.view.ElementView;
	import com.panozona.player.module.Module;
	import flash.events.MouseEvent;
	import flash.system.ApplicationDomain;
	
	public class ElementController{
		
		private var _elementView:ElementView;
		private var _module:Module;
		
		public function ElementController(elementView:ElementView, module:Module){
			_elementView = elementView;
			_module = module;
			
			_elementView.elementData.addEventListener(ElementEvent.CHANGED_MOUSE_OVER, handleElementMouseOverChange, false, 0, true);
			_elementView.elementData.addEventListener(ElementEvent.CHANGED_IS_ACTIVE, handleElementActiveChange, false, 0, true);
			
			_elementView.elementData.addEventListener(ElementEvent.CHANGED_WIDTH, handleElementWidthChange, false, 0, true); // to trzeba bedzie wywalic
			
			_elementView.addEventListener(MouseEvent.CLICK, handleMouseClick, false, 0, true);
			
			if(_elementView.elementData.rawElement is Element){
				var panoramaEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.events.PanoramaEvent") as Class;
				_module.qjPlayer.manager.addEventListener(panoramaEventClass.PANORAMA_STARTED_LOADING, onPanoramaStartedLoading, false, 0, true);
			}
		}
		
		private function handleElementMouseOverChange(e:ElementEvent):void {
			if (_elementView.elementData.mouseOver) {
				onHover();
			}else {
				onPlain();
			}
		}
		
		private function handleElementActiveChange(e:ElementEvent):void {
			if (_elementView.elementData.mouseOver) {
				onHover();
			}else {
				onPlain();
			}
		}
		
		private function handleElementWidthChange(e:ElementEvent):void {
			if (_elementView.textField.width != _elementView.elementData.width) {
				_elementView.textField.width = _elementView.elementData.width;
			}
		}
		
		private function onPanoramaStartedLoading(panoramaEvent:Object):void {
			if(_elementView.elementData.rawElement is Element){
				if ((_elementView.elementData.rawElement as Element).target == _module.qjPlayer.manager.currentPanoramaData.id){
					_elementView.elementData.isActive = true;
				}else {
					_elementView.elementData.isActive = false;
				}
			}
		}
		
		private function handleMouseClick(e:MouseEvent):void {
			if (_elementView.elementData.rawElement is Element){
				if (_module.qjPlayer.manager.currentPanoramaData.id != (_elementView.elementData.rawElement as Element).target){
					_module.qjPlayer.manager.loadPano((_elementView.elementData.rawElement as Element).target);
				}
			}else{
				_module.qjPlayer.manager.runAction((_elementView.elementData.rawElement as ExtraElement).action);
			}
			_elementView.dropDownData.boxData.open = false;
		}
		
		private function onPlain():void {
			if (_elementView.elementData.isActive) {
				_elementView.textField.backgroundColor = _elementView.dropDownData.boxData.box.style.activeColor;
			}else {
				_elementView.textField.backgroundColor = _elementView.dropDownData.boxData.box.style.plainColor;
			}
		}
		
		private function onHover():void {
			if (_elementView.elementData.isActive) {
				_elementView.textField.backgroundColor = _elementView.dropDownData.boxData.box.style.activeColor;
			}else {
				_elementView.textField.backgroundColor = _elementView.dropDownData.boxData.box.style.hoverColor;
			}
		}
	}
}
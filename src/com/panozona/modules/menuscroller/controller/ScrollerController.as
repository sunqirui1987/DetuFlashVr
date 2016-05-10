/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.menuscroller.controller{
	
	import com.panozona.modules.menuscroller.events.ElementEvent;
	import com.panozona.modules.menuscroller.events.ScrollerEvent;
	import com.panozona.modules.menuscroller.events.WindowEvent;
	import com.panozona.modules.menuscroller.model.ElementData;
	import com.panozona.modules.menuscroller.model.structure.Element;
	import com.panozona.modules.menuscroller.model.structure.RawElement;
	import com.panozona.modules.menuscroller.model.structure.Style;
	import com.panozona.modules.menuscroller.view.ElementView;
	import com.panozona.modules.menuscroller.view.IconView;
	import com.panozona.modules.menuscroller.view.ScrollerView;
	import com.panozona.player.module.Module;
	
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.system.ApplicationDomain;
	
	import caurina.transitions.Tweener;
	
	public class ScrollerController {
		
		private var _scrollerView:ScrollerView;
		private var _module:Module;
		
		private var elementControlers:Vector.<ElementController>;
		
		private var elementsView:Vector.<ElementView>;
		private var _preelementsView:Vector.<ElementView>;
		
		private var overDimension:Number;
		private var overOverlay:Number;
		private var difference:Number;
		
		
		
		
		public function ScrollerController(scrollerView:ScrollerView, module:Module){
			_scrollerView = scrollerView;
			_module = module;
			
			elementControlers = new Vector.<ElementController>();
			elementsView = new Vector.<ElementView>();
			
			overDimension = _scrollerView.menuScrollerData.scrollerData.scroller.sizeLimit * _scrollerView.menuScrollerData.scrollerData.scroller.mouseOver.scale + 10;
			overOverlay = overDimension - _scrollerView.menuScrollerData.scrollerData.scroller.sizeLimit;
			
			var elementData:ElementData;
			var elementView:ElementView;
			var elementController:ElementController;
			for each (var rawElement:RawElement in _scrollerView.menuScrollerData.elements.getAllChildren()) {
				elementData = new ElementData(rawElement, _scrollerView.menuScrollerData.scrollerData.scroller);
				elementView = new ElementView(elementData);
				
				if (rawElement.style != null){
					for each(var style:Style in scrollerView.menuScrollerData.styles.getChildrenOfGivenClass(Style)){
						if (style.id == rawElement.style) {
							elementView.setText(rawElement.text, style.content);
						}
					}
				}
				
				scrollerView.elementsContainer.addChild(elementView);
				elementController = new ElementController(elementView, _module);
				elementControlers.push(elementController);
				elementsView.push(elementView);
				
				elementData.addEventListener(ElementEvent.CHANGED_SIZE, onElementSizeChanged, false, 0, true);
				
				if (rawElement.mouse.onOver != null) {
					elementView.addEventListener(MouseEvent.ROLL_OVER, getMouseEventHandler(rawElement.mouse.onOver));
				}
				if (rawElement.mouse.onOut != null) {
					elementView.addEventListener(MouseEvent.ROLL_OUT, getMouseEventHandler(rawElement.mouse.onOut));
				}
				
				
			}
			//保存状态
			_preelementsView = elementsView.concat();
			
			
			_scrollerView.menuScrollerData.windowData.addEventListener(WindowEvent.CHANGED_ELASTIC_WIDTH, handleResize, false, 0, true);
			_scrollerView.menuScrollerData.windowData.addEventListener(WindowEvent.CHANGED_ELASTIC_HEIGHT, handleResize, false, 0, true);
			onElementSizeChanged();
			
			_scrollerView.menuScrollerData.scrollerData.addEventListener(ScrollerEvent.CHANGED_TOTAL_SIZE, handleResize, false, 0, true);
			
			//_scrollerView.menuScrollerData.scrollerData.addEventListener(ScrollerEvent.CHANGED_MOUSE_OVER, handleMouseOverChange, false, 0, true);
			_scrollerView.addEventListener(MouseEvent.MOUSE_DOWN,handleMouseDownChange, false, 0, true);
			_scrollerView.addEventListener(MouseEvent.MOUSE_MOVE,handleMouseMOVEChange, false, 0, true);
			_module.qjPlayer.addEventListener(MouseEvent.MOUSE_UP,handleMouseUPChange, false, 0, true);
			
			
			//_scrollerView.filters = [new DropShadowFilter(1.0,45,0xffffff,0.9)];
			
	
			var panoramaEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.events.PanoramaEvent") as Class;
			_module.qjPlayer.manager.addEventListener(panoramaEventClass.PANORAMA_LOADED, onPanoramaLoaded, false, 0, true);
			
			_scrollerView.menuScrollerData.scrollerData.addEventListener(ScrollerEvent.CHANGED_SCROLL_VALUE, onChangeScrollValue, false, 0, true);
	
		
		}
		
		protected function onChangeScrollValue(event:Event):void
		{
			for each(var elementView:ElementView in elementsView) {
				if(!elementView.elementData.loaded)
					return;
			}
			var toTemp:Number;
			if(!_scrollerView.menuScrollerData.scrollerData.scroller.scrollsVertical)
				toTemp = _scrollerView.elementsContainer.x+_scrollerView.menuScrollerData.scrollerData.scrollVal;
			else
				toTemp = _scrollerView.elementsContainer.y+_scrollerView.menuScrollerData.scrollerData.scrollVal;
			Tweener.removeTweens(_scrollerView.elementsContainer);
			if(!_scrollerView.menuScrollerData.scrollerData.scroller.scrollsVertical){
				toTemp = Math.max(toTemp,-(_scrollerView.elementsContainer.width - _scrollerView.menuScrollerData.windowData.elasticWidth));
				toTemp = Math.min(0,toTemp);
				Tweener.addTween(_scrollerView.elementsContainer,{x:toTemp,time:0.5});
			}else{
				toTemp = Math.max(toTemp,-(_scrollerView.elementsContainer.height - _scrollerView.menuScrollerData.windowData.elasticHeight));
				toTemp = Math.min(0,toTemp);
				Tweener.addTween(_scrollerView.elementsContainer,{y:toTemp,time:0.5});
			}			
		}
		
		private var mousedownbool:Boolean =false;
		private var mousedownx:Number =0;
		private var mousedowny:Number =0;
		private function handleMouseDownChange(e:MouseEvent):void
		{
			mousedownbool= true;
			mousedownx = e.stageX;
			mousedowny = e.stageY;
		}
		private function handleMouseMOVEChange(e:MouseEvent):void
		{
			if(mousedownbool == true)
			{
				var diffy:Number = e.stageY - mousedowny;
				var diffx:Number = e.stageX - mousedownx;
				mousedownx = e.stageX;
				mousedowny = e.stageY;
				
				if (_scrollerView.menuScrollerData.scrollerData.scroller.scrollsVertical) {
					var d:Number = _scrollerView.menuScrollerData.scrollerData.totalSize -
						_scrollerView.menuScrollerData.windowData.elasticHeight;
					if(d > 0)
					{
						_scrollerView.elementsContainer.y = _scrollerView.elementsContainer.y + diffy;
						if(_scrollerView.elementsContainer.y < -d  )
						{
							_scrollerView.elementsContainer.y =   -d;
						}
						else if(_scrollerView.elementsContainer.y > 0)
						{
							_scrollerView.elementsContainer.y = -5;
						}
						
					}
				}else {
					d = _scrollerView.menuScrollerData.scrollerData.totalSize -
						_scrollerView.menuScrollerData.windowData.elasticWidth;
					if(d > 0)
					{
						_scrollerView.elementsContainer.x = _scrollerView.elementsContainer.x + diffx;
						if(_scrollerView.elementsContainer.x < -d  )
						{
							_scrollerView.elementsContainer.x =   -d;
						}
						else if(_scrollerView.elementsContainer.x > 0)
						{
							_scrollerView.elementsContainer.x = -5;
						}
						
					}
				}

			}
		}
		
		private function handleMouseUPChange(e:MouseEvent):void
		{
			mousedownbool = false;
		}
	
		
		private function onPanoramaLoaded(panoramaEvent:Object):void {
			this.ifcheck_pano();
			
			if(_scrollerView.menuScrollerData.scrollerData.scroller.isClickItemHide){
				_scrollerView.menuScrollerData.windowData.open = false;
			}
			if(!_scrollerView.menuScrollerData.scrollerData.scroller.scrollsVertical && _scrollerView.elementsContainer.width < _scrollerView.menuScrollerData.windowData.elasticWidth)
				return;
			if(_scrollerView.menuScrollerData.scrollerData.scroller.scrollsVertical && _scrollerView.elementsContainer.height < _scrollerView.menuScrollerData.windowData.elasticHeight)
				return;
			var toTemp:Number=-1;
			for each(var elementView:ElementView in elementsView) {
				
				var element:Element = elementView.elementData.rawElement as Element;
			
				if (element != null && _module.qjPlayer.manager.currentPanoramaData && element.target == _module.qjPlayer.manager.currentPanoramaData.id) 
				{
					//var dr:flash.filters.GlowFilter=new GlowFilter(0xFFFFFF,0.9,8.0,8.0,3);
					//elementView.filters=[dr];
					if(!_scrollerView.menuScrollerData.scrollerData.scroller.scrollsVertical)
						toTemp = -((elementView.x+elementView.width/2) - _scrollerView.menuScrollerData.windowData.elasticWidth/2);
					else
						toTemp = -((elementView.y+elementView.height/2) - _scrollerView.menuScrollerData.windowData.elasticHeight/2);
				}
				else
				{
				//	elementView.filters=[];
				}
			}
			if(toTemp == -1)
				return;
			Tweener.removeTweens(_scrollerView.elementsContainer);
			if(!_scrollerView.menuScrollerData.scrollerData.scroller.scrollsVertical){
				toTemp = Math.max(toTemp,-(_scrollerView.elementsContainer.width - _scrollerView.menuScrollerData.windowData.elasticWidth));
				toTemp = Math.min(0,toTemp);
				Tweener.addTween(_scrollerView.elementsContainer,{x:toTemp,time:0.5});
			}else{
				toTemp = Math.max(toTemp,-(_scrollerView.elementsContainer.height - _scrollerView.menuScrollerData.windowData.elasticHeight));
				toTemp = Math.min(0,toTemp);
				Tweener.addTween(_scrollerView.elementsContainer,{y:toTemp,time:0.5});
			}
			
			
		}
		
		
		
		private function getMouseEventHandler(actionId:String):Function{
			return function(e:MouseEvent):void {
				_module.qjPlayer.manager.runAction(actionId);
			}
		}
		
		private function handleResize(e:Object = null):void {
			if (_scrollerView.menuScrollerData.scrollerData.scroller.scrollsVertical) {
				_scrollerView.elementsContainer.x = (_scrollerView.menuScrollerData.windowData.window.size.width -
					_scrollerView.menuScrollerData.scrollerData.scroller.sizeLimit) * 0.5;
					
				_scrollerView.elementsContainer.y = _scrollerView.menuScrollerData.scrollerData.scrollValue +
					(_scrollerView.menuScrollerData.windowData.elasticHeight -
					_scrollerView.menuScrollerData.scrollerData.totalSize) * 0.5;
			}else {
				_scrollerView.elementsContainer.y = (_scrollerView.menuScrollerData.windowData.window.size.height -
					_scrollerView.menuScrollerData.scrollerData.scroller.sizeLimit) * 0.5;
					
				_scrollerView.elementsContainer.x = _scrollerView.menuScrollerData.scrollerData.scrollValue +
					(_scrollerView.menuScrollerData.windowData.elasticWidth -
					_scrollerView.menuScrollerData.scrollerData.totalSize) * 0.5;
			}
			
			// draw mask 
			_scrollerView.elementsContainerMask.graphics.clear();
			_scrollerView.elementsContainerMask.graphics.beginFill(0x000000);
			if (_scrollerView.menuScrollerData.scrollerData.scroller.scrollsVertical) {
				_scrollerView.elementsContainerMask.graphics.drawRect(
					-(overDimension - _scrollerView.menuScrollerData.windowData.elasticWidth) * 0.5,
					_scrollerView.menuScrollerData.scrollerData.scroller.maskPadding,
					overDimension,
					_scrollerView.menuScrollerData.windowData.elasticHeight-_scrollerView.menuScrollerData.scrollerData.scroller.maskPadding*2);
			}else {
				_scrollerView.elementsContainerMask.graphics.drawRect(
				_scrollerView.menuScrollerData.scrollerData.scroller.maskPadding,
				-(overDimension - _scrollerView.menuScrollerData.windowData.elasticHeight) * 0.5,
				_scrollerView.menuScrollerData.windowData.elasticWidth-_scrollerView.menuScrollerData.scrollerData.scroller.maskPadding*2,
					overDimension);
			}
			_scrollerView.elementsContainerMask.graphics.endFill();
			
			if (_scrollerView.menuScrollerData.scrollerData.scroller.scrollsVertical) {
				difference = _scrollerView.menuScrollerData.scrollerData.totalSize -
					_scrollerView.menuScrollerData.windowData.elasticHeight;
			}else {
				difference = _scrollerView.menuScrollerData.scrollerData.totalSize -
					_scrollerView.menuScrollerData.windowData.elasticWidth;
			}
			onPanoramaLoaded(null);
			_scrollerView.drawBoundMask();
			var w:Number = isNaN(_scrollerView.menuScrollerData.windowData.window.size.width)?_module.qjPlayer.manager.boundsWidth:_scrollerView.menuScrollerData.windowData.window.size.width;
			var h:Number = isNaN(_scrollerView.menuScrollerData.windowData.window.size.height)?_module.qjPlayer.manager.boundsHeight:_scrollerView.menuScrollerData.windowData.window.size.height;
			_scrollerView.drawBorder(w,h);
		}
		
		
		private function ifcheck_pano():void
		{
			elementsView = _preelementsView.concat();//复制
			
			for each(var pre_elementView:ElementView in _preelementsView) {
				pre_elementView.visible = true;
			}
			
			
			//反向遍历删除数组  
			for (var i:int = elementsView.length - 1; i >= 0; i--)  
			{
				var elementView:ElementView  = elementsView[i];
				if(_module.ifcheck(elementView.elementData.rawElement)  == false)
				{
					elementView.visible = false;
					//删除
					elementsView.splice(i,1);
				}
			}
			
			onElementSizeChanged();
		}
		
		private function onElementSizeChanged(e:Event = null):void {
			var counter:Number = _scrollerView.menuScrollerData.scrollerData.scroller.spacing * 3;
			if (_scrollerView.menuScrollerData.scrollerData.scroller.scrollsVertical) {
				counter += ((elementsView[0].elementData.size.height * 
					_scrollerView.menuScrollerData.scrollerData.scroller.mouseOver.scale) -
					elementsView[0].elementData.size.height) * 0.5;
			}else {
				counter += ((elementsView[0].elementData.size.width *
					_scrollerView.menuScrollerData.scrollerData.scroller.mouseOver.scale) -
					elementsView[0].elementData.size.width) * 0.5;
			}
			
			
			
			for each(var elementView:ElementView in elementsView) {
				
				if (_scrollerView.menuScrollerData.scrollerData.scroller.scrollsVertical) {
					elementView.x = 0;
					elementView.y = counter;
					counter += elementView.elementData.size.height;
				}else {
					elementView.x = counter;
					elementView.y = 0;
					counter += elementView.elementData.size.width
				}
				counter += _scrollerView.menuScrollerData.scrollerData.scroller.spacing * 3;
				elementView.elementData.isShowing = true; // TODO: should be calculated for "lazy loading"
				
			}
			if (_scrollerView.menuScrollerData.scrollerData.scroller.scrollsVertical) {
				counter += ((elementsView[elementsView.length -1].elementData.size.height *
					_scrollerView.menuScrollerData.scrollerData.scroller.mouseOver.scale) -
					elementsView[elementsView.length -1].elementData.size.height) * 0.5;
			}else {
				counter += ((elementsView[elementsView.length -1].elementData.size.width *
					_scrollerView.menuScrollerData.scrollerData.scroller.mouseOver.scale) -
					elementsView[elementsView.length -1].elementData.size.width) * 0.5;
			}
			_scrollerView.menuScrollerData.scrollerData.totalSize = counter;
			
			// draw transparent rectangle under elements for mouse interaction
			_scrollerView.elementsContainer.graphics.clear();
			_scrollerView.elementsContainer.graphics.beginFill(0x000000, 0);
			if (_scrollerView.menuScrollerData.scrollerData.scroller.scrollsVertical) {
				_scrollerView.elementsContainer.graphics.drawRect(-overOverlay * 0.5, 0,
					overDimension,
					_scrollerView.menuScrollerData.scrollerData.totalSize);
			}else {
				_scrollerView.elementsContainer.graphics.drawRect(0, -overOverlay * 0.5,
					_scrollerView.menuScrollerData.scrollerData.totalSize,
					overDimension);
			}
			_scrollerView.elementsContainer.graphics.endFill();
		}
		
		private function handleMouseOverChange(e:Event):void {
			if(_scrollerView.menuScrollerData.scrollerData.mouseOver && difference > 0){
				_module.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
			}else {
				_module.stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
		}
		
		private function onEnterFrame(e:Event):void {
		
			if (_scrollerView.menuScrollerData.scrollerData.scroller.scrollsVertical) {
				_scrollerView.elementsContainer.y = -(difference) * _scrollerView.mouseY /
					_scrollerView.menuScrollerData.windowData.elasticHeight;
			}else {
				_scrollerView.elementsContainer.x = -(difference) * _scrollerView.mouseX /
					_scrollerView.menuScrollerData.windowData.elasticWidth;
			}
			
			
		}
		
		
		
	}
}
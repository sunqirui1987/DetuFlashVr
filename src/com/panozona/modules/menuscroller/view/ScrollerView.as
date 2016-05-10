/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.menuscroller.view{
	
	import com.panozona.modules.menuscroller.model.MenuScrollerData;
	import com.panozona.modules.menuscroller.model.structure.BorderStyle;
	import com.panozona.player.module.data.property.Size;
	
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class ScrollerView extends Sprite{
		
		public const elementsContainer:Sprite = new Sprite();
		public const elementsContainerMask:Sprite = new Sprite();
		
		private var _menuScrollerData:MenuScrollerData;
		
		public var leftMask:Sprite = new Sprite();
		
		public var rightMask:Sprite = new Sprite();
		
		public var borderSp:Sprite = new Sprite();
		
		public function ScrollerView(menuScrollerData:MenuScrollerData){
			_menuScrollerData = menuScrollerData;
			
			alpha = 1 / _menuScrollerData.windowData.window.alpha;
			
			addChild(elementsContainer);
			addChild(elementsContainerMask);
			elementsContainer.mask = elementsContainerMask;
			
			addChild(leftMask);
			addChild(rightMask);
			addChild(borderSp);
			leftMask.mouseEnabled = leftMask.mouseChildren = false;
			rightMask.mouseEnabled = rightMask.mouseChildren = false;
			drawBoundMask();
			
			elementsContainer.addEventListener(MouseEvent.ROLL_OVER, onOver, false, 0, true);
			elementsContainer.addEventListener(MouseEvent.ROLL_OUT, onOut, false, 0, true);
			
		}
		
		public function get menuScrollerData():MenuScrollerData {
			return _menuScrollerData;
		}
		
		private function onOver(e:Event):void {
			_menuScrollerData.scrollerData.mouseOver = true;
		}
		private function onOut(e:Event):void {
			_menuScrollerData.scrollerData.mouseOver = false;
		}
		
		public function drawBoundMask():void{
			if(_menuScrollerData.scrollerData.scroller.boundMaskSize == 0)
				return;
			var ratiostemp:String = _menuScrollerData.scrollerData.scroller.ratios;
			var ratios:Array = _menuScrollerData.scrollerData.scroller.ratios.split(",");
			leftMask.graphics.clear();
			leftMask.graphics.beginGradientFill(GradientType.LINEAR,[_menuScrollerData.windowData.window.color,_menuScrollerData.windowData.window.color],[_menuScrollerData.windowData.window.alpha,.01],ratios);
			if(_menuScrollerData.scrollerData.scroller.scrollsVertical){
				leftMask.graphics.drawRect(0,0,_menuScrollerData.windowData.window.size.width,_menuScrollerData.scrollerData.scroller.boundMaskSize);
			}else{
				leftMask.graphics.drawRect(0,0,_menuScrollerData.scrollerData.scroller.boundMaskSize,_menuScrollerData.windowData.window.size.height);
			}
			
			leftMask.graphics.endFill();
			if(_menuScrollerData.scrollerData.scroller.scrollsVertical){
				leftMask.y = _menuScrollerData.scrollerData.scroller.maskPadding;
			}else{
				leftMask.x = _menuScrollerData.scrollerData.scroller.maskPadding;
			}
			setChildIndex(leftMask,numChildren-1);
			
			rightMask.graphics.clear();
			rightMask.graphics.beginGradientFill(GradientType.LINEAR,[_menuScrollerData.windowData.window.color,_menuScrollerData.windowData.window.color],[_menuScrollerData.windowData.window.alpha,.01],ratios);
			rightMask.graphics.drawRect(0,0,leftMask.width,leftMask.height);
			rightMask.graphics.endFill();
			rightMask.scaleX = -1;
			if(_menuScrollerData.scrollerData.scroller.scrollsVertical){
				rightMask.y = elementsContainerMask.height+_menuScrollerData.scrollerData.scroller.maskPadding;
			}else{
				rightMask.x = elementsContainerMask.width+_menuScrollerData.scrollerData.scroller.maskPadding;
			}
			setChildIndex(rightMask,numChildren-1);
		}
		
		public function drawBorder(w:Number,h:Number):void{
			borderSp.graphics.clear();
			var border:BorderStyle = menuScrollerData.scrollerData.scroller.topBorder;
			borderSp.graphics.lineStyle(border.thickness,border.color,border.alpha);
			borderSp.graphics.moveTo(0,0);
			if(!_menuScrollerData.scrollerData.scroller.scrollsVertical){
				borderSp.graphics.lineTo(w,0);
			}else{
				borderSp.graphics.lineTo(0,h);
			}
			
			border = menuScrollerData.scrollerData.scroller.bottomBorder;
			borderSp.graphics.lineStyle(border.thickness,border.color,border.alpha);
			
			if(!_menuScrollerData.scrollerData.scroller.scrollsVertical){
				borderSp.graphics.moveTo(0,h);
				borderSp.graphics.lineTo(w,h);
			}else{
				borderSp.graphics.moveTo(w,0);
				borderSp.graphics.lineTo(w,h);
			}
		}
	}
}
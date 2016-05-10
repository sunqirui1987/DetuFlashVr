package com.panozona.modules.menuscroller.controller
{
	import com.panozona.modules.menuscroller.events.WindowEvent;
	import com.panozona.modules.menuscroller.model.structure.Element;
	import com.panozona.player.module.utils.ZLoader;
	import com.panozona.modules.menuscroller.view.ElementView;
	import com.panozona.modules.menuscroller.view.ShowView;
	import com.panozona.player.module.Module;
	import com.panozona.player.module.data.property.Align;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.system.ApplicationDomain;
	
	import caurina.transitions.Tweener;

	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-6-26 下午1:14:19
	 * 功能描述:
	 */
	public class ShowViewController
	{
		
		private var _showView:ShowView;
		
		private var _module:Module;
		
		public function ShowViewController(_showView:ShowView,_module:Module)
		{
			this._showView = _showView;
			this._module = _module;
			
			
			_showView.menuScrollerData.windowData.addEventListener(WindowEvent.CHANGED_OPEN, onOpenChange, false, 0, true);
			
			var ViewEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panosalado.events.ViewEvent") as Class;
			_module.qjPlayer.manager.addEventListener(ViewEventClass.BOUNDS_CHANGED, showAlign, false, 0, true);
			showAlign();
			
			var panoramaEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.events.PanoramaEvent") as Class;
			_module.qjPlayer.manager.addEventListener(panoramaEventClass.PANORAMA_STARTED_LOADING, onPanoramaStartedLoading, false, 0, true);
			
			
			if(_showView.item.mouse.onClick){
				_showView.buttonMode = true;
				_showView.addEventListener(MouseEvent.CLICK,onClick, false, 0, true);
			}
		}
		
		protected function onClick(event:MouseEvent):void
		{
			_module.qjPlayer.manager.runAction(_showView.item.mouse.onClick);
		}
		
		protected function onPanoramaStartedLoading(event:Event):void
		{
			var arr:Array = _showView.menuScrollerData.elements.getChildrenOfGivenClass(Element);
			for(var i:int=0;i<arr.length;i++){
				var ell:Element = arr[i] as Element;
				if( _module.qjPlayer.manager.currentPanoramaData && ell.target == _module.qjPlayer.manager.currentPanoramaData.id){
					curElement = ell;
					if(!_preElement){
						preElement = arr[0];
					}
					break;
				}
			}
		}
		
		protected function onOpenChange(event:Event):void
		{
			var toAlpha:Number = _showView.menuScrollerData.windowData.open?0:1;
			Tweener.removeTweens(_showView);
			if(_showView.menuScrollerData.windowData.open){
				Tweener.addTween(_showView,{alpha:toAlpha,time:_showView.menuScrollerData.windowData.window.openTween.time,onComplete:function():void{
					_showView.visible = false;	
				}});
			}else{
				_showView.visible = true;
				_showView.alpha = 0;
				Tweener.addTween(_showView,{alpha:toAlpha,time:_showView.menuScrollerData.windowData.window.closeTween.time});
			}
			
		}
		
		private function showAlign(event:Event = null):void {
			_showView.x = getWindowOpenX();
			_showView.y = getWindowOpenY();
		}
		
		private function getWindowOpenX():Number {
			var result:Number = 0;
			switch(_showView.item.align.horizontal) {
				case Align.RIGHT:
					result += _module.qjPlayer.manager.boundsWidth
					- _showView.width
					+ _showView.item.move.horizontal;
					break;
				case Align.LEFT:
					result += _showView.item.move.horizontal;
					break;
				default: // CENTER
					result += (_module.qjPlayer.manager.boundsWidth
						- _showView.width) * 0.5 
					+ _showView.item.move.horizontal;
			}
			return result;
		}
		
		private function getWindowOpenY():Number{
			var result:Number = 0;
			switch(_showView.item.align.vertical) {
				case Align.TOP:
					result += _showView.item.move.vertical;
					break;
				case Align.BOTTOM:
					result += _module.qjPlayer.manager.boundsHeight
					- _showView.height
					+ _showView.item.move.vertical;
					break;
				default: // MIDDLE
					result += (_module.qjPlayer.manager.boundsHeight
						- _showView.height) * 0.5
					+ _showView.item.move.vertical;
			}
			return result;
		}
		
		private var _curElement:Element;
		private var _preElement:Element;
		
		public function set curElement(_curElement:Element):void{
			this.preElement = this._curElement;
			this._curElement = _curElement;
			if(this._curElement && _showView){
				new ZLoader().load(this._curElement.path,imageLost,curCmp);
			}
		}
		
		public function set preElement(_preElement:Element):void{
			this._preElement = _preElement;
			if(this._preElement && _showView){
				new ZLoader().load(this._preElement.path,imageLost,preCmp);
			}
		}
		
		private function preCmp(e:Event):void
		{
			var bmd:BitmapData = new BitmapData(e.target.content.width*_showView.item.scale, e.target.content.height*_showView.item.scale, false, 0);  
			var matrix:Matrix = new Matrix();  
			matrix.scale(_showView.item.scale, _showView.item.scale);  
			bmd.draw(e.target.content, matrix); 
			_showView.preBmd = bmd;
			showAlign();			
		}
		
		private function curCmp(e:Event):void
		{
			var bmd:BitmapData = new BitmapData(e.target.content.width*_showView.item.scale, e.target.content.height*_showView.item.scale, false, 0);  
			var matrix:Matrix = new Matrix();  
			matrix.scale(_showView.item.scale, _showView.item.scale);  
			bmd.draw(e.target.content, matrix); 
			_showView.curBmd = bmd;
			showAlign();			
		}
		
		private function imageLost(error:IOErrorEvent):void {
			_module.printError(error.text);
		}
	}
}
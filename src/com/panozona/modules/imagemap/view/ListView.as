package com.panozona.modules.imagemap.view
{
	import com.panozona.modules.imagemap.events.ListEvent;
	import com.panozona.modules.imagemap.model.ImageMapData;
	import com.panozona.player.module.Module;
	import com.panozona.player.module.data.property.Align;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-3-10 下午5:11:53
	 * 功能描述:
	 */
	public class ListView extends Sprite
	{
		
		private var _imageMapData:ImageMapData;
		
		private var numNavigateView:NumNavigateView;
		
		private var dropDownNavigateView:DropDownNavigateView;
		
		private var _module:Module;
		
		
		public function ListView(imageMapData:ImageMapData) {
			this._imageMapData = imageMapData;
		}
		
		public function init(module):void{
			this._module = module;
			
			if(imageMapData.listData.lists.model == 1){
				numNavigateView = new NumNavigateView(imageMapData,_module);
				numNavigateView.addEventListener(ListEvent.LIST_VIEW_BUILDED,onNumNavigateBuilded);
				addChild(numNavigateView);
				numNavigateView.printErrorFun = printError;
				numNavigateView.init();
			}else if(imageMapData.listData.lists.model == 2){
				dropDownNavigateView = new DropDownNavigateView(imageMapData,_module);
				dropDownNavigateView.addEventListener(ListEvent.LIST_VIEW_BUILDED,onNumNavigateBuilded);
				addChild(dropDownNavigateView);
				dropDownNavigateView.printErrorFun = printError;
				dropDownNavigateView.init();
			}
			placeonWindow();
		}
		
		protected function onNumNavigateBuilded(event:Event):void
		{
			if(numNavigateView)
				numNavigateView.removeEventListener(ListEvent.LIST_VIEW_BUILDED,onNumNavigateBuilded);	
			if(dropDownNavigateView)
				dropDownNavigateView.removeEventListener(ListEvent.LIST_VIEW_BUILDED,onNumNavigateBuilded);
			placeonWindow();
		}
		
		private function placeonWindow():void {
			if (_imageMapData.listData.lists.align.horizontal == Align.LEFT) {
				this.x = 0;
			}else if (_imageMapData.listData.lists.align.horizontal == Align.RIGHT) {
				this.x = _imageMapData.windowData.window.size.width - this.width;
			}else { // CENTER
				this.x = (_imageMapData.windowData.window.size.width - this.width) * 0.5;
			}
			if (_imageMapData.listData.lists.align.vertical == Align.TOP){
				this.y = 0;
			}else if (_imageMapData.listData.lists.align.vertical == Align.BOTTOM) {
				this.y = _imageMapData.windowData.window.size.height - this.height;
			}else { // MIDDLE
				this.y = (_imageMapData.windowData.window.size.height - this.height) * 0.5;
			}
			this.x += _imageMapData.listData.lists.move.horizontal;
			this.y += _imageMapData.listData.lists.move.vertical;
		}
		
		public function get imageMapData():ImageMapData{
			return _imageMapData;
		}
		
		public function showListSelect():void{
			if(numNavigateView){
				numNavigateView.showListSelect();
			}
			if(dropDownNavigateView){
				dropDownNavigateView.showListSelect();
			}
		}
		
		private function printError(info:String):void{
			var event:ListEvent = new ListEvent(ListEvent.ERROR_INFO);
			event.errInfo = info;
			dispatchEvent(event);
		}
	}
}
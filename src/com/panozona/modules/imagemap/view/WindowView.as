/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.imagemap.view{
	
	import com.panozona.modules.imagemap.model.ImageMapData;
	import com.panozona.modules.imagemap.model.WindowData;
	
	import flash.display.Sprite;
	
	public class WindowView extends Sprite{
		
		private var _closeView:CloseView;
		private var _viewerView:ViewerView;
		private var textContainer:Sprite;
		
		private var window:Sprite;
		
		private var _imageMapData:ImageMapData;
		
		private var _listView:ListView;
		
		private var _panelView:PanelView;
		
		private var _tabview:TabView;
		
		public function WindowView(imageMapData:ImageMapData,managerData:Object) {
			
			
			
			_imageMapData = imageMapData;
			
			this.alpha = _imageMapData.windowData.window.alpha;
			
			// draw map window
			window = new Sprite();
			window.graphics.beginFill(0xFFFFFF,0);
			window.graphics.drawRect(0, 0, _imageMapData.windowData.window.size.width, _imageMapData.windowData.window.size.height);
			window.graphics.endFill();
			addChild(window);
			
			visible = _imageMapData.windowData.open;
			
			
			
			if(_imageMapData.tab){
				
				_tabview = new TabView(_imageMapData,managerData);
				window.addChild(_tabview);
				_viewerView = new ViewerView(_imageMapData,_tabview.box.width,_tabview.box.height);
				_tabview.box.addChildAt(_viewerView,0);
				var mask:Sprite = new Sprite();
				mask.graphics.beginFill(1,0);
				mask.graphics.drawRect(3,3,_tabview.box.width-6,_tabview.box.height-6);
			//	mask.graphics.drawRect(0,0,_tabview.box.width,_tabview.box.height);
				mask.graphics.endFill();
				_tabview.box.addChild(mask);
				_viewerView.mask = mask;
			}else{
				_viewerView = new ViewerView(_imageMapData);
				window.addChild(_viewerView);
			}
			
			
			_panelView = new PanelView(_imageMapData);
			window.addChild(_panelView);
			
			_closeView = new CloseView(_imageMapData);
			window.addChild(_closeView);
			
			if(_imageMapData.windowData.window.istext==true)
			{
			
				textContainer = new Sprite();
				textContainer.name="textcontainer";
				textContainer.x = 130;
				textContainer.y = -17;
				window.addChild(textContainer);
			
			}
			
			
			
			_listView = new ListView(_imageMapData);
			window.addChild(_listView);
			
			if(_imageMapData.tab){
				_listView.visible = false;
				_panelView.visible = false;
				_closeView.visible = false;
			}
		}
		
		public function get windowData():WindowData {
			return _imageMapData.windowData;
		}
		
		public function get closeView():CloseView {
			return _closeView;
		}
		
		public function get viewerView():ViewerView {
			return _viewerView;
		}
		
		public function get listView():ListView {
			return _listView;
		}
		
		public function get panelView():PanelView {
			return _panelView;
		}
		public function get tabView():TabView {
			return _tabview;
		}
		
		public function get imageMapData():ImageMapData {
			return _imageMapData;
		}
		public function get container():Sprite {
			return window;
		}
		
		public function setMask(mask:Sprite):void{
			container.mask = mask;
		}
	}
}
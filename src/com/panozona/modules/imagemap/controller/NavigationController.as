/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.imagemap.controller {
	
	import com.panozona.modules.imagemap.events.NavigationEvent;
	import com.panozona.modules.imagemap.view.NavigationView;
	import com.panozona.player.module.Module;
	
	public class NavigationController {
		
		private var _module:Module;
		private var _navigationView:NavigationView;
		
		public function NavigationController(navigationView:NavigationView, module:Module){
			_navigationView = navigationView;
			_module = module;
			
			_navigationView.navigationData.addEventListener(NavigationEvent.CHANGED_IS_ACTIVE, handleActiveStateChange, false, 0, true);
		}
		
		private function handleActiveStateChange(e:NavigationEvent):void {
			if (_navigationView.navigationData.isActive) {
				_navigationView.navigationData.onPress();
				_navigationView.setActive();
			}else {
				_navigationView.navigationData.onRelease();
				_navigationView.setPlain();
			}
		}
	}
}
package com.panozona.modules.imagemap.controller
{
	import com.panozona.modules.imagemap.events.MapEvent;
	import com.panozona.modules.imagemap.view.TabView;
	import com.panozona.player.module.Module;
	
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	
	import morn.core.handlers.Handler;

	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-8-13 下午1:17:28
	 * 功能描述:
	 */
	public class TabViewController
	{
		private var _tabView:TabView;
		private var _module:Module;
		
		public function TabViewController(_tabView:TabView, module:Module){
			this._tabView = _tabView;
			_module = module;
			
			_tabView.clickLinkBtnHandel = new Handler(changePano);
			
			_tabView.imageMapData.mapData.addEventListener(MapEvent.CHANGED_CURRENT_MAP_ID, handleCurrentMapIdChange, false, 0, true);
		
			var panoramaEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.events.PanoramaEvent") as Class;
			_module.qjPlayer.manager.addEventListener(panoramaEventClass.PANORAMA_LOADED, onPanoramaLoaded, false, 0, true);
		
			if(_module.qjPlayer.manager.currentPanoramaData)
				onPanoramaLoaded();
			
			handleCurrentMapIdChange();
		}
		
		private function onPanoramaLoaded(panoramaEvent:Object = null):void {
			_tabView.panoLabel = (_tabView.cmb.selectedLabel?(_tabView.cmb.selectedLabel+' - '):"")+_module.qjPlayer.manager.currentPanoramaData.title;
			_tabView.selectPanoId = _module.qjPlayer.manager.currentPanoramaData.id;
		}
		
		private function changePano(pid:String):void
		{
			if (_module.qjPlayer.manager.currentPanoramaData.id != pid){
				_module.qjPlayer.manager.loadPano(pid);
			}			
		}
		
		protected function handleCurrentMapIdChange(event:Event = null):void
		{
			var mapId:String = 	_tabView.imageMapData.mapData.currentMapId;
			_tabView.mapId = mapId;
		}
	}
}
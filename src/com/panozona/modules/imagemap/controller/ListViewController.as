package com.panozona.modules.imagemap.controller
{
	import com.panozona.modules.imagemap.events.ListEvent;
	import com.panozona.modules.imagemap.events.MapEvent;
	import com.panozona.modules.imagemap.view.ListView;
	import com.panozona.player.module.Module;
	
	import flash.events.Event;
	

	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-3-11 下午1:51:56
	 * 功能描述:
	 */
	public class ListViewController
	{
		private var _listView:ListView;
		private var _module:Module;
		
		
		public function ListViewController(_listView:ListView, module:Module) {
			this._module = module;
			this._listView = _listView;
			
			_listView.imageMapData.mapData.addEventListener(MapEvent.CHANGED_CURRENT_MAP_ID, handleCurrentMapIdChange, false, 0, true);
			_listView.addEventListener(ListEvent.ERROR_INFO,onErrInfo);
			this._listView.init(_module);
		}
		
		protected function onErrInfo(event:ListEvent):void
		{
			_module.printError(event.errInfo);
		}
		
		protected function handleCurrentMapIdChange(event:Event):void
		{
			var mapId:String = 	_listView.imageMapData.mapData.currentMapId;
			_listView.showListSelect();
		}
	}
}
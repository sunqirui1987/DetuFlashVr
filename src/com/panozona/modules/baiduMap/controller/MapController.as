package com.panozona.modules.baiduMap.controller
{
	import com.panozona.modules.baiduMap.events.BaiduMapEvent;
	import com.panozona.modules.baiduMap.view.MapView;
	import com.panozona.player.manager.data.panoramas.PanoramaData;
	import com.panozona.player.module.Module;
	
	import flash.events.Event;
	import flash.system.ApplicationDomain;

	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-3-13 上午10:06:41
	 * 功能描述:
	 */
	public class MapController
	{
		private var _mapView:MapView;
		private var _module:Module;
		
		public function MapController(_mapView:MapView, _module:Module){
			this._mapView = _mapView;
			this._module = _module;
			
			_mapView.addEventListener(BaiduMapEvent.BAIDU_MAP_LOADED,onInitMarks);
		}
		
		private function onPanoramaLoaded(panoramaEvent:Object = null):void {
			_mapView.map.setSelect(_module.qjPlayer.manager.currentPanoramaData.id);
			drawRadar();
		}
		
		protected function onInitMarks(event:Event):void
		{
			var panoramasData:Vector.<PanoramaData> = _module.qjPlayer.managerData.panoramasData;
			var arr:Array = [];
			for(var i:int = 0;i<panoramasData.length;i++){
				var obj:Object = {id:panoramasData[i].id,lng:panoramasData[i].lngLat.lng,lat:panoramasData[i].lngLat.lat}
				arr.push(obj);
			}
			
			if(_module.qjPlayer.manager.currentPanoramaData)
				_mapView.map.initData(arr,_module.qjPlayer.manager.currentPanoramaData.id);
			
			_mapView.map.addEventListener("CLICK_BAIDU_MAP_MARK",onChangePano);
			
			var panoramaEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.events.PanoramaEvent") as Class;
			_module.qjPlayer.manager.addEventListener(panoramaEventClass.PANORAMA_LOADED, onPanoramaLoaded, false, 0, true);
			
			_module.stage.addEventListener(Event.ENTER_FRAME, handleEnterFrame, false, 0, true);
			handleEnterFrame();
			drawRadar();
		}
		
		private var _fov:Number = NaN;
		private var _tilt:Number = NaN;
		private var _pan:Number = NaN;
		
		private function handleEnterFrame(e:Event = null):void
		{
			if (_fov != _module.qjPlayer.manager._fieldOfView) {
				drawRadar();
				_fov = _module.qjPlayer.manager._fieldOfView;
			}
			
			if (_pan != _module.qjPlayer.manager._pan) {
				drawRadar();
				_pan = _module.qjPlayer.manager._pan;
			}
		}
		
		private function drawRadar():void{
			var startAngle:Number = (-_module.qjPlayer.manager._fieldOfView - 180) * Math.PI / 180 * 0.5;
			var endAngle:Number = (_module.qjPlayer.manager._fieldOfView - 180) * Math.PI / 180 * 0.5;
			var divisions:Number = Math.floor(Math.abs(endAngle - startAngle) / (Math.PI / 4)) + 1;
			var span:Number = Math.abs(endAngle - startAngle) / (2 * divisions);
			if(_module.qjPlayer.manager.currentPanoramaData)
				var currentDirection:Number = _module.qjPlayer.managerData.getPanoramaDataById(_module.qjPlayer.manager.currentPanoramaData.id).direction;
			var rotationZ:Number = _module.qjPlayer.manager._pan + currentDirection;
			
			if(_mapView.map)
				_mapView.map.drawWatchArea(startAngle,endAngle,divisions,span,rotationZ);
		}
		
		private function onChangePano(event:Object):void{
			var id:String = event.clickMarkId;
			if (_module.qjPlayer.manager.currentPanoramaData.id != id){
				_module.qjPlayer.manager.loadPano(id);
			}
		}
		
	}
}
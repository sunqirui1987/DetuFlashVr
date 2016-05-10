package com.panozona.modules.panoramaTitleAndDes.controller
{
	import com.panozona.modules.panoramaTitleAndDes.events.PanoramaTitleAndDesEvent;
	import com.panozona.modules.panoramaTitleAndDes.view.TitleAndDesView;
	import com.panozona.player.module.Module;
	
	import flash.events.Event;
	import flash.system.ApplicationDomain;

	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-8-1 上午9:51:00
	 * 功能描述:
	 */
	public class TitleAndDesController
	{
		
		private var _titleAndDesView:TitleAndDesView;
		
		private var module:Module;
		
		public function TitleAndDesController(_titleAndDesView:TitleAndDesView,module:Module)
		{
			this._titleAndDesView = _titleAndDesView;
			this.module = module;
			
			var panoramaEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.events.PanoramaEvent") as Class;
			module.qjPlayer.manager.addEventListener(panoramaEventClass.PANORAMA_LOADED, onPanoramaLoaded, false, 0, true);
			onPanoramaLoaded(null);
			
			_titleAndDesView.panoramaTitleAndDesData.addEventListener(PanoramaTitleAndDesEvent.IS_SHOW_FULL_PANARAMA_TITLE_AND_DES,onShowFull);
		}
		
		protected function onShowFull(event:Event):void
		{
			if(_titleAndDesView.panoramaTitleAndDesData.isShowFull){
				_titleAndDesView.titleView.visible = false;
				_titleAndDesView.desView.visible = true;
			}else{
				_titleAndDesView.titleView.visible = true;
				_titleAndDesView.desView.visible = false;
			}
		}
		
		private function onPanoramaLoaded(e:Event):void{
			_titleAndDesView.panoramaTitleAndDesData.isShowFull = false;
			if(module.qjPlayer.manager.currentPanoramaData){
				_titleAndDesView.setData(module.qjPlayer.manager.currentPanoramaData.title,module.qjPlayer.manager.currentPanoramaData.description);
			}
		}
	}
}
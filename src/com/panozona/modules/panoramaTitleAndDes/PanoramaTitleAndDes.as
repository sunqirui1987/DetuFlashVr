package com.panozona.modules.panoramaTitleAndDes
{
	import com.panozona.modules.panoramaTitleAndDes.controller.WindowController;
	import com.panozona.modules.panoramaTitleAndDes.model.PanoramaTitleAndDesData;
	import com.panozona.modules.panoramaTitleAndDes.view.WindowView;
	import com.panozona.player.module.Module;
	import com.panozona.player.module.data.ModuleData;
	
	import flash.display.Sprite;
	
	import morn.core.handlers.Handler;
	
	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-8-1 上午9:15:13
	 * 功能描述:
	 */
	public class PanoramaTitleAndDes extends Module
	{
		
		public var panoramaTitleAndDesData:PanoramaTitleAndDesData;
		
		public var windowController:WindowController;
		
		public var windowView:WindowView;
		
		public function PanoramaTitleAndDes()
		{
			super("PanoramaTitleAndDes", "1.3", "http://ouwei.cn/wiki/Module:PanoramaTitleAndDes");
			moduleDescription.addFunctionDescription("toggleOpen");
			moduleDescription.addFunctionDescription("setOpen", Boolean);
		}
		
		override protected function moduleReady(moduleData:ModuleData):void {
			panoramaTitleAndDesData = new PanoramaTitleAndDesData(moduleData,qjPlayer);
			
			if(panoramaTitleAndDesData.settings.skinUrls){
				App.init(this.qjPlayer as Sprite);
				App.loader.loadAssets([panoramaTitleAndDesData.settings.skinUrls], new Handler(createUI));
			}else{
				createUI();
			}
		}
		
		private function createUI():void{
			windowView = new WindowView(panoramaTitleAndDesData);
			addChild(windowView);
			windowController = new WindowController(windowView,this);
		}
			
			
		
		///////////////////////////////////////////////////////////////////////////////
		//  Exposed functions 
		///////////////////////////////////////////////////////////////////////////////
		
		public function setOpen(value:Boolean):void {
			panoramaTitleAndDesData.isShowFull = value;
		}
		
		public function toggleOpen(value:Boolean):void {
			panoramaTitleAndDesData.isShowFull = !panoramaTitleAndDesData.isShowFull;
		}
	}
}
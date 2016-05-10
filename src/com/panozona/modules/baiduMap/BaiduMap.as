package com.panozona.modules.baiduMap
{
	import com.panozona.modules.baiduMap.controller.WindowController;
	import com.panozona.modules.baiduMap.model.BaiduMapData;
	import com.panozona.modules.baiduMap.view.WindowView;
	import com.panozona.player.module.Module;
	import com.panozona.player.module.data.ModuleData;
	
	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-3-12 上午10:10:05
	 * 功能描述:
	 */
	public class BaiduMap extends Module
	{
		
		private var baiduMapData:BaiduMapData;
		
		private var windowView:WindowView;
		
		private var windowController:WindowController;
		
		public function BaiduMap()
		{
			super("BaiduMap", "1.1", "http://ouwei.cn/wiki/Module:BaiduMap");
			moduleDescription.addFunctionDescription("toggleOpen");
			moduleDescription.addFunctionDescription("setOpen", Boolean);
		}
		
		override protected function moduleReady(moduleData:ModuleData):void {
			
			baiduMapData = new BaiduMapData(moduleData, qjPlayer); // always first
			
			windowView = new WindowView(baiduMapData);
			windowController = new WindowController(windowView, this);
			addChild(windowView);
			
			
		}
		
		///////////////////////////////////////////////////////////////////////////////
		//  Exposed functions 
		///////////////////////////////////////////////////////////////////////////////
		
		public function setOpen(value:Boolean):void {
			baiduMapData.windowData.open = value;
		}
		
		public function toggleOpen():void {
			baiduMapData.windowData.open = !baiduMapData.windowData.open;
		}
	}
}
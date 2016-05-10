package com.panozona.modules.guide
{
	import com.panozona.modules.guide.controller.GuideController;
	import com.panozona.modules.guide.model.GuideData;
	import com.panozona.modules.guide.view.GuideLayer;
	import com.panozona.modules.guide.view.GuideView;
	import com.panozona.player.module.Module;
	import com.panozona.player.module.data.ModuleData;
	
	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-9-4 上午11:12:13
	 * 功能描述:
	 */
	public class Guide extends Module
	{
		
		private var guideData:GuideData;
		
		private var guideController:GuideController;
		
		private var layer:GuideLayer;
		
		public function Guide()
		{
			super("Guide", "1.3", "http://ouwei.cn/wiki/Module:Guide");
			
			moduleDescription.addFunctionDescription("playGuide",String);
		}
		
		override protected function moduleReady(moduleData:ModuleData):void {
			guideData = new GuideData(moduleData,this.qjPlayer);
			layer = new GuideLayer(guideData);
			addChild(layer);
			
			guideController = new GuideController(layer,this);
		}
		
		public function playGuide(id:String):void{
			guideController.play(id);
		}
	}
}
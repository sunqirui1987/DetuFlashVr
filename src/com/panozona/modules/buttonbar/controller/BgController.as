package com.panozona.modules.buttonbar.controller
{
	import com.panozona.modules.buttonbar.events.ButtonBarEvent;
	import com.panozona.modules.buttonbar.view.BgView;
	import com.panozona.player.module.Module;
	

	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-4-10 下午1:14:56
	 * 功能描述:
	 */
	public class BgController
	{
		private var _bgView:BgView;
		private var _module:Module;
		
		public function BgController(bgView:BgView, module:Module){
			_bgView = bgView;
			_module = module;
			
			_bgView.buttonBarData.windowData.addEventListener(ButtonBarEvent.UPDATE_BUTTON,createBg);
		}
		
		protected function createBg(event:ButtonBarEvent):void
		{
			_bgView.drawBg();
		}
	}
}
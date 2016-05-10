package com.panozona.modules.buttonbar.view
{
	import com.panozona.modules.buttonbar.model.ButtonBarData;
	
	import flash.display.Sprite;
	
	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-4-10 下午1:12:41
	 * 功能描述:
	 */
	public class BgView extends Sprite
	{
		private var _buttonBarData:ButtonBarData;
		
		public function BgView(buttonBarData:ButtonBarData):void {
			_buttonBarData = buttonBarData;
		}
		
		public function get buttonBarData():ButtonBarData {
			return _buttonBarData;
		}
		
		public function drawBg():void{
			this.graphics.clear();
			this.graphics.beginFill(_buttonBarData.bg.color,_buttonBarData.bg.alpha);
			this.graphics.drawRoundRect(0,0,_buttonBarData.windowData.barWidth,_buttonBarData.windowData.barHeight,_buttonBarData.bg.radius);
			this.graphics.endFill();
		}
	}
}
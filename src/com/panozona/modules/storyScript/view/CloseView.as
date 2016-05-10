package com.panozona.modules.storyScript.view
{
	import com.panozona.modules.storyScript.model.Close;
	import com.panozona.modules.storyScript.model.StoryScriptData;
	
	import flash.display.Sprite;
	
	import morn.core.components.Component;

	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-8-14 下午1:59:06
	 * 功能描述:
	 */
	public class CloseView extends Component
	{
		
		public var data:StoryScriptData;
		
		public function CloseView(data:StoryScriptData)
		{
			this.data = data;
			this.toolTip = close.toolTips;
		}
		
		public function get close():Close{
			return data.close;
		}
	}
}
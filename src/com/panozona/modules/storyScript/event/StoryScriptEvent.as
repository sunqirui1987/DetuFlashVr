package com.panozona.modules.storyScript.event
{
	import flash.events.Event;

	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-8-14 下午2:22:54
	 * 功能描述:
	 */
	public class StoryScriptEvent extends Event{
		
		public static const IS_SHOW_CLOSE_BTN_CHANGED:String = "IS_SHOW_CLOSE_BTN_CHANGED";
		
		public function StoryScriptEvent(type:String){
			super(type);
		}
	}
}
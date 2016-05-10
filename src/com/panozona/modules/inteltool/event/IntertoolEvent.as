package com.panozona.modules.inteltool.event
{
	import flash.events.Event;
	
	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-5-9 下午9:00:13
	 * 功能描述:
	 */
	public class IntertoolEvent extends Event
	{
		
		public static const PLAY_STATE_CHANGE:String = "PLAY_STATE_CHANGE";
		
		public static const SOURCE_LOADED:String = "SOURCE_LOADED";
		
		public function IntertoolEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
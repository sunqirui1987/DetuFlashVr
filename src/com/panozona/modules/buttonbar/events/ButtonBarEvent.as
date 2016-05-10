package com.panozona.modules.buttonbar.events
{
	import flash.events.Event;
	
	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-4-10 下午1:18:30
	 * 功能描述:
	 */
	public class ButtonBarEvent extends Event
	{
		public static const UPDATE_BUTTON:String = "UPDATE_BUTTON";
		
		public function ButtonBarEvent(type:String,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
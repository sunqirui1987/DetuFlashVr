package com.panozona.modules.guestBook.events
{
	import flash.events.Event;
	
	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-2-24
	 * 功能描述:
	 */
	public class PageEvent extends Event
	{
		public static const PAGE_CHANGE:String = "PAGE_CHANGE";
		
		public var curPage:int;
		
		public function PageEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
package com.panozona.modules.museumItem.event
{
	import flash.events.Event;
	
	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-7-21 下午5:59:33
	 * 功能描述:
	 */
	public class MuseumItemEvent extends Event
	{
		
		public static const SELECT_NEW_MUSEUM_ITEM:String = "SELECT_NEW_MUSEUM_ITEM";
		
		public function MuseumItemEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
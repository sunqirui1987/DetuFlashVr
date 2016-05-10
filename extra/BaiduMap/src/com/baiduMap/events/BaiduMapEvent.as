package com.baiduMap.events
{
	import flash.events.Event;
	
	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-3-13 上午10:41:40
	 * 功能描述:
	 */
	public class BaiduMapEvent extends Event
	{
		public var clickMarkId:String;
		public static const CLICK_BAIDU_MAP_MARK:String = "CLICK_BAIDU_MAP_MARK";
		public function BaiduMapEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
package com.panozona.modules.baiduMap.events
{
	import flash.events.Event;
	
	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-3-13 上午10:10:29
	 * 功能描述:
	 */
	public class BaiduMapEvent extends Event
	{
		
		public static const BAIDU_MAP_LOADED:String = "BAIDU_MAP_LOADED";
		
		public function BaiduMapEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
package com.panozona.modules.panoramaTitleAndDes.events
{
	import flash.events.Event;
	
	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-8-1 上午9:20:06
	 * 功能描述:
	 */
	public class PanoramaTitleAndDesEvent extends Event
	{
		
		public static const IS_SHOW_FULL_PANARAMA_TITLE_AND_DES:String = "IS_SHOW_FULL_PANARAMA_TITLE_AND_DES"; 
		
		public function PanoramaTitleAndDesEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
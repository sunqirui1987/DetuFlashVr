package com.panozona.modules.imagemap.events
{
	import com.panozona.modules.imagemap.model.structure.List;
	
	import flash.events.Event;
	
	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-3-11 上午10:52:19
	 * 功能描述:
	 */
	public class ListEvent extends Event
	{
		
		public static const LIST_VIEW_BUILDED:String = "LIST_VIEW_BUILDED";
		
		public static const ERROR_INFO:String = "ERROR_INFO";
		
		public var errInfo:String;
		
		public function ListEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
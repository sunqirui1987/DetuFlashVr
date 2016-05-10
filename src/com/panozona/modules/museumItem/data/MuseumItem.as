package com.panozona.modules.museumItem.data
{
	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-6-10 下午2:08:51
	 * 功能描述:
	 */
	public class MuseumItem
	{
		public var id:String = "";
		public var title:String = "";
		public var info:String = "";
		
		public var citiaoUrl:String;
		public var jiangJieUrl:String;
		
		public var showItemUrl:String;
		
		public var isOnlyShowPic:Boolean;//为true时只显示右边部分
		
		public var picUrl:String;//列表中显示的图片
		
		public var panoId:String;//对应的全景ID
		
		public var hotId:String;//对应的热点ID
		
		public function MuseumItem()
		{
		}
	}
}
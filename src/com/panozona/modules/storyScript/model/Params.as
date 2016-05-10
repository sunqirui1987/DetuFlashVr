package com.panozona.modules.storyScript.model
{
	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-8-14 下午1:14:03
	 * 功能描述:
	 */
	public class Params
	{
		//--------wait 命令 ---------
		public var wait_time:Number;
		
		//--------hideOtherModule 命令 ---------
		public var hideOtherModule_names:String="";
		
		//--------loadPano命令 ---------
		public var panoId:String="";
		
		//--------moveToHotspotThen命令 ---------
		public var hotId:String="";
		public var fieldOfView:Number;
		public var speed:Number=30;
		
		public var pan:Number;
		public var tilt:Number;
		
		public var museumId:String;
		public var autoCloseTime:Number = 0;
		
		public var autoRotation:Number = 360;
		
		public var actioncontent:String = "";
		public var actionid:String = "";
		
		public function Params()
		{
			
		}
	}
}
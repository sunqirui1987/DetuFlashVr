package com.panozona.modules.storyScript.model
{
	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-8-14 上午10:56:21
	 * 功能描述:
	 */
	public class Command
	{
		
		public static const WAIT:String = "wait";
		public static const HIDE_OTHER_MODULE:String = "hideOtherModule";
		public static const LOAD_PANO:String = "loadPano";
		public static const LOAD_PANO_THEN:String = "loadPanoThen";
		public static const MOVE_TO_HOTSPOT_THEN:String = "moveToHotspotThen";
		public static const ADVANCED_MOVE_TO_HOTSPOT_THEN:String = "advancedMoveToHotspotThen";
		public static const ADVANCED_MOVE_TO_VIEW_THEN:String = "advancedMoveToViewThen";
		
		public static const JUMP_MUSEUMITEM:String = "jumpMuseumItem";
		
		public static const AUTO_ROTATION_PANO:String = "autoRotationPano";
		
		public static const RUNACTION:String = "runAction";
		public static const RUNACTIONCONTENT:String = "runActionContent";
		
		public var commandName:String;
		
		public var params:Params = new Params;
		
		public function Command()
		{
		}
	}
}
package com.panozona.modules.guide.model
{
	import com.panozona.player.module.data.structure.DataParent;
	
	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-9-4 上午11:21:10
	 * 功能描述:
	 */
	public class GuideItem extends DataParent
	{
		public function GuideItem()
		{
			super();
		}
		
		override public function getChildrenTypes():Vector.<Class>{
			var result:Vector.<Class> = new Vector.<Class>();
			result.push(GuideStep);
			return result;
		}
		
		public var id:String;
		
		public var isOnlyPlayOnce:Boolean;
		
		public var hasPlayed:Boolean;
	}
}
package com.panozona.modules.museumItem.data
{
	import com.panozona.modules.museumItem.data.struct.Info;
	import com.panozona.modules.museumItem.data.struct.Title;
	import com.panozona.player.module.data.structure.DataParent;

	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-10-30 下午1:13:32
	 * 功能描述:
	 */
	public class DressItem extends DataParent {
		
		public var id:String;
		public var infoWebUrl:String;
		public var buyWebUrl:String;
		public var showItemUrl:String;
		public var title:Title ;
		public var info:Info;
		
		override public function getChildrenTypes():Vector.<Class>{
			var result:Vector.<Class> = new Vector.<Class>();
			result.push(Title);
			result.push(Info);
			return result;
		}
		
	
	}
}
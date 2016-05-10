package com.panozona.modules.storyScript.model
{
	import com.panozona.player.module.data.structure.DataParent;

	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-8-14 上午10:55:15
	 * 功能描述:
	 */
	public class ScriptItem extends DataParent
	{
		
		public var id:String;
		
		public var nextId:String;
		
		public var panoId:String;
		
		override public function getChildrenTypes():Vector.<Class>{
			var result:Vector.<Class> = new Vector.<Class>();
			result.push(Command);
			return result;
		}
		
		public function ScriptItem()
		{
		}
	}
}
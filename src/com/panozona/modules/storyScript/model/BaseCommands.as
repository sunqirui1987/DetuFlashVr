package com.panozona.modules.storyScript.model
{
	import com.panozona.player.module.data.structure.DataParent;
	
	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-8-21 下午5:16:23
	 * 功能描述:
	 */
	public class BaseCommands extends DataParent
	{
		public function BaseCommands()
		{
			super();
		}
		
		override public function getChildrenTypes():Vector.<Class>{
			var result:Vector.<Class> = new Vector.<Class>();
			result.push(Command);
			return result;
		}
	}
}
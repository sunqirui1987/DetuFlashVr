package com.panozona.modules.guestBook.model.structure
{
	import com.panozona.player.module.data.structure.DataParent;
	
	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-2-21
	 * 功能描述:
	 */
	public class Messages extends DataParent
	{
		public function Messages()
		{
			super();
		}
		
		override public function getChildrenTypes():Vector.<Class>{
			var result:Vector.<Class> = new Vector.<Class>();
			result.push(Message);
			return result;
		}
		
		public function addNewMessage(message:Message):void{
			_children.unshift(message);
		}
	}
}
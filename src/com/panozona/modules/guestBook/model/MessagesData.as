package com.panozona.modules.guestBook.model
{
	import com.panozona.modules.guestBook.events.WindowEvent;
	import com.panozona.modules.guestBook.model.structure.Message;
	import com.panozona.modules.guestBook.model.structure.Messages;
	import com.panozona.player.module.data.DataNode;
	
	import flash.events.EventDispatcher;
	
	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-2-21
	 * 功能描述:
	 */
	public class MessagesData extends EventDispatcher
	{
		public var  nodes:Vector.<DataNode> = new Vector.<DataNode>();
		
		public var messages:Messages = new Messages();
		
		public function MessagesData()
		{
			super();
		}
		
		public function addNewMessage(message:Message):void{
			messages.addNewMessage(message);
			dispatchEvent(new WindowEvent(WindowEvent.ADD_NEW_MESSAGE));
		}
	}
}
package com.panozona.modules.guestBook.model
{
	import com.panozona.modules.guestBook.model.structure.Setting;
	import com.panozona.modules.guestBook.model.structure.Skin;
	import com.panozona.modules.infobox.model.structure.Close;
	import com.panozona.player.module.data.DataNode;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.utils.DataNodeTranslator;

	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-2-20
	 * 功能描述:
	 */
	public class GuestBookData
	{
		public const windowData:WindowData = new WindowData();
		public const setting:Setting = new Setting();
		public const skin:Skin = new Skin();
		public const messagesData:MessagesData = new MessagesData();
		
		private var debugMode:Boolean;
		
		public function GuestBookData(moduleData:ModuleData, qjPlayer:Object)
		{
			this.debugMode = qjPlayer.managerData.debugMode;
			var tarnslator:DataNodeTranslator = new DataNodeTranslator(debugMode);
			for each(var dataNode:DataNode in moduleData.nodes) {
				if (dataNode.name == "window") {
					tarnslator.dataNodeToObject(dataNode, windowData.window);
				}else if (dataNode.name == "setting") {
					tarnslator.dataNodeToObject(dataNode, setting);
				}else if (dataNode.name == "skin") {
					tarnslator.dataNodeToObject(dataNode, skin);
				}else{
					throw new Error("Invalid node name: " + dataNode.name);
				}
			}
			
			windowData.open = windowData.window.open;
		}
		
		public function parseMessageData():void{
			var tarnslator:DataNodeTranslator = new DataNodeTranslator(debugMode);
			for each(var dataNode:DataNode in messagesData.nodes) {
				if (dataNode.name == "messages") {
					tarnslator.dataNodeToObject(dataNode, messagesData.messages);
				}else{
					throw new Error("Invalid node name: " + dataNode.name);
				}
			}
		}
	}
}
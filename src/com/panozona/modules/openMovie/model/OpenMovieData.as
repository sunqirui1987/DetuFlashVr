package com.panozona.modules.openMovie.model
{
	import com.panozona.modules.openMovie.model.WindowData;
	import com.panozona.modules.openMovie.model.structure.Setting;
	import com.panozona.player.module.data.DataNode;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.utils.DataNodeTranslator;

	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-3-3 上午9:44:04
	 * 功能描述:留言板模块
	 */
	public class OpenMovieData
	{
		public const windowData:WindowData = new WindowData();
		public const setting:Setting = new Setting();
		
		private var debugMode:Boolean;
		
		public function OpenMovieData(moduleData:ModuleData, qjPlayer:Object)
		{
			this.debugMode = qjPlayer.managerData.debugMode;
			var tarnslator:DataNodeTranslator = new DataNodeTranslator(debugMode);
			for each(var dataNode:DataNode in moduleData.nodes) {
				if (dataNode.name == "window") {
					tarnslator.dataNodeToObject(dataNode, windowData.window);
				}else if (dataNode.name == "setting") {
					tarnslator.dataNodeToObject(dataNode, setting);
				}else{
					throw new Error("Invalid node name: " + dataNode.name);
				}
			}
			
			windowData.open = windowData.window.open;
		}
	}
}
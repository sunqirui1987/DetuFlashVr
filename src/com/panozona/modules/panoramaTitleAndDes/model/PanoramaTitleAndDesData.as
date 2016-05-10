package com.panozona.modules.panoramaTitleAndDes.model
{
	import com.panozona.modules.panoramaTitleAndDes.events.PanoramaTitleAndDesEvent;
	import com.panozona.modules.panoramaTitleAndDes.model.WindowData;
	import com.panozona.modules.panoramaTitleAndDes.model.structure.Settings;
	import com.panozona.modules.panoramaTitleAndDes.model.structure.SourceItem;
	import com.panozona.player.module.data.DataNode;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.utils.DataNodeTranslator;
	
	import flash.events.EventDispatcher;

	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-8-1 上午9:17:51
	 * 功能描述:
	 */
	public class PanoramaTitleAndDesData extends EventDispatcher
	{
		
		private var _isShowFull:Boolean;
		
		public function get isShowFull():Boolean{
			return this._isShowFull;
		}
		
		public function set isShowFull(_isShowFull:Boolean):void{
			if(this._isShowFull == _isShowFull)
				return;
			this._isShowFull = _isShowFull;
			dispatchEvent(new PanoramaTitleAndDesEvent(PanoramaTitleAndDesEvent.IS_SHOW_FULL_PANARAMA_TITLE_AND_DES));
		}
		
		
		public const windowData:WindowData = new WindowData();
		public var sources:Vector.<SourceItem> = new Vector.<SourceItem>();
		public const settings:Settings = new Settings();
		public function PanoramaTitleAndDesData(moduleData:ModuleData, qjPlayer:Object) {
			var tarnslator:DataNodeTranslator = new DataNodeTranslator(qjPlayer.managerData.debugMode);
			for each(var dataNode:DataNode in moduleData.nodes) {
				if (dataNode.name == "window") {
					tarnslator.dataNodeToObject(dataNode, windowData.window);
					windowData.open = windowData.window.open;
				}else if (dataNode.name == "source") {
					var item2:SourceItem = new SourceItem();
					tarnslator.dataNodeToObject(dataNode, item2);
					sources.push(item2);
				}else if (dataNode.name == "settings") {
					tarnslator.dataNodeToObject(dataNode, settings);
				}else {
					throw new Error("Invalid node name: " + dataNode.name);
				}
			}
		}
		
		public function getSourceItemByName(name:String):SourceItem{
			var len:int = sources.length;
			for(var i:int=0;i<len;i++){
				if(sources[i].name == name)
					return sources[i];
			}
			return null;
		}
	}
}
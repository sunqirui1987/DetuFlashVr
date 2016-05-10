package com.panozona.modules.storyScript.model
{
	import com.panozona.modules.storyScript.event.StoryScriptEvent;
	import com.panozona.player.module.data.DataNode;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.utils.DataNodeTranslator;
	
	import flash.events.EventDispatcher;

	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-8-14 上午10:38:49
	 * 功能描述:
	 */
	public class StoryScriptData extends EventDispatcher
	{
		
		public const items:Vector.<ScriptItem> = new Vector.<ScriptItem>();
		public const close:Close = new Close();
		public const baseCommands:BaseCommands = new BaseCommands;
		
		public function StoryScriptData(moduleData:ModuleData, qjPlayer:Object) {
			var tarnslator:DataNodeTranslator = new DataNodeTranslator(qjPlayer.managerData.debugMode);
			for each(var dataNode:DataNode in moduleData.nodes) {
				if (dataNode.name == "scriptItem") {
					var item:ScriptItem = new ScriptItem();
					tarnslator.dataNodeToObject(dataNode,item);
					items.push(item);
				}else if (dataNode.name == "baseCommands") {
					tarnslator.dataNodeToObject(dataNode,baseCommands);
				}else if (dataNode.name == "close") {
					tarnslator.dataNodeToObject(dataNode,close);
				}else {
					throw new Error("Invalid node name: " + dataNode.name);
				}
			}
			
			addBaseToScript();
		}
		
		private function addBaseToScript():void
		{
			var arr:Array = baseCommands.getChildrenOfGivenClass(Command);
			for(var i:int=0,n:int=items.length;i<n;i++){
				items[i].getAllChildren().unshift(baseCommands.getChildrenOfGivenClass(Command));
				
				for(var j:int=arr.length-1;j>=0;j--){
					items[i].getAllChildren().unshift(arr[j]);
				}
			}	
		}
		
		public function getScriptItemById(id:String):ScriptItem{
			for(var i:int=0,n:int=items.length;i<n;i++){
				if(items[i].id == id)
					return items[i];
			}
			return null;
		}
		
		public function getScriptItemByPanoId(panoId:String):ScriptItem{
			for(var i:int=0,n:int=items.length;i<n;i++){
				if(items[i].panoId == panoId)
					return items[i];
			}
			return null;
		}
		
		private var _isShowCloseBtn:Boolean;
		
		public function get isShowCloseBtn():Boolean{
			return this._isShowCloseBtn;
		}
		
		public function set isShowCloseBtn(_isShowCloseBtn:Boolean):void{
			if(this._isShowCloseBtn == _isShowCloseBtn)
				return;
			this._isShowCloseBtn = _isShowCloseBtn;
			dispatchEvent(new StoryScriptEvent(StoryScriptEvent.IS_SHOW_CLOSE_BTN_CHANGED));
		}
	}
}
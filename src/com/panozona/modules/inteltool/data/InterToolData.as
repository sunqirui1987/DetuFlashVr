package com.panozona.modules.inteltool.data
{
	
	import com.panozona.modules.inteltool.event.IntertoolEvent;
	import com.panozona.player.module.data.DataNode;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.utils.DataNodeTranslator;
	
	import flash.events.EventDispatcher;
	
	public class InterToolData extends EventDispatcher{
		
		public var mysettings:AutoMySetting = new AutoMySetting();
		public var dysettings:AutoDySetting = new AutoDySetting();
		public var zzzsettings:AutoZzzSetting = new AutoZzzSetting();
		public var speaker:Speaker = new Speaker();
		
		public var _isPlay:Boolean;
		public function get isPlay():Boolean{
			return _isPlay;
		}
		
		public function set isPlay(_isPlay:Boolean):void{
			if(this._isPlay == _isPlay)
				return;
			this._isPlay = _isPlay;
			dispatchEvent(new IntertoolEvent(IntertoolEvent.PLAY_STATE_CHANGE));
		}
		
		public function InterToolData(moduleData:ModuleData, qjPlayer:Object) {
			
			var translator:DataNodeTranslator = new DataNodeTranslator(qjPlayer.managerData.debugMode);
			
			for each(var dataNode:DataNode in moduleData.nodes) {
				if (dataNode.name == "mysettings") {
					translator.dataNodeToObject(dataNode, mysettings);
				}
				else if(dataNode.name=="dysettings") {
					translator.dataNodeToObject(dataNode, dysettings);
				}
				else if(dataNode.name == "zzzsettings"){
					translator.dataNodeToObject(dataNode, zzzsettings);
				}
				else if(dataNode.name == "speaker"){
					translator.dataNodeToObject(dataNode, speaker);
				}
				else {
					throw new Error("Invalid node name: " + dataNode.name);
				}
			}
			
			
			
		}
	}
	
}
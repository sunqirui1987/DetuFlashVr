package com.panozona.modules.storyScript
{
	import com.panozona.modules.storyScript.controller.CloseContoller;
	import com.panozona.modules.storyScript.controller.StoryScriptController;
	import com.panozona.modules.storyScript.model.ScriptItem;
	import com.panozona.modules.storyScript.model.StoryScriptData;
	import com.panozona.modules.storyScript.view.CloseView;
	import com.panozona.player.manager.data.actions.ActionData;
	import com.panozona.player.manager.data.actions.FunctionData;
	import com.panozona.player.module.Module;
	import com.panozona.player.module.data.ModuleData;
	
	
	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-8-14 上午10:08:16
	 * 功能描述:
	 */
	public class StoryScript extends Module
	{
		
		private var controller:StoryScriptController;
		
		private var data:StoryScriptData;
		
		private var closeView:CloseView;
		
		private var closeController:CloseContoller;
		
		public static const ACTION_CALLBACK_ID:String = "storyScriptCallBack";
		
		public function StoryScript()
		{
			super("StoryScript", "1.3", "http://ouwei.cn/wiki/Module:StoryScript");
			
			moduleDescription.addFunctionDescription("playScript",String);
			moduleDescription.addFunctionDescription("playScriptByPano");
			moduleDescription.addFunctionDescription("callBack");
		}
		
		override protected function moduleReady(moduleData:ModuleData):void {
			
			App.init(this);
			
			var actionData:ActionData = new ActionData(ACTION_CALLBACK_ID);
			actionData.functions.push(new FunctionData(moduleDescription.name,"callBack"));
			qjPlayer.manager.managerData.actionsData.push(actionData);
			
			data = new StoryScriptData(moduleData,qjPlayer);
			controller = new StoryScriptController(data,this);
			
			closeView = new CloseView(data);
			closeView.visible = false;
			qjPlayer.addChild(closeView);
			closeController = new CloseContoller(closeView,this);
		}
		
		
		public function playScript(id:String):void{
			controller.playScript(id);
		}
		
		public function playScriptByPano():void{
			if(!qjPlayer.manager.currentPanoramaData)
				return;
			var item:ScriptItem = data.getScriptItemByPanoId(qjPlayer.manager.currentPanoramaData.id);
			if(!item)
				return;
			var id:String = item.id;
			controller.playScript(id);
		}
		
		public function callBack():void{
			controller.callBack();
		}
		
		public function stopScript():void{
			controller.stop();
		}
	}
}
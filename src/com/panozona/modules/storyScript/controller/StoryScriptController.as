package com.panozona.modules.storyScript.controller
{
	import com.panozona.modules.ModuleName;
	import com.panozona.modules.storyScript.StoryScript;
	import com.panozona.modules.storyScript.model.Command;
	import com.panozona.modules.storyScript.model.ScriptItem;
	import com.panozona.modules.storyScript.model.StoryScriptData;
	import com.panozona.player.module.Module;
	import com.panozona.player.module.global;
	
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	
	import caurina.transitions.Tweener;

	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-8-14 上午10:39:23
	 * 功能描述:
	 */
	public class StoryScriptController
	{
		
		private var data:StoryScriptData;
		
		private var module:Module;
		
		private var isPlaying:Boolean;
		
		private var stepIndex:int=0;
		
		private var playingCommands:Array;
		
		private var curplayingCommand:Command;
		
		private var manager:Object;
		
		private var panoramaEventClass:Class;
		
		private var curPlayingItem:ScriptItem;
		
		public function StoryScriptController(data:StoryScriptData,module:Module)
		{
			this.data = data;
			this.module = module;
			
			manager = module.qjPlayer.manager;
			
			panoramaEventClass = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.events.PanoramaEvent") as Class;
		}
		
		public function playScript(id:String):void{
			if(isPlaying)
				return;
			curPlayingItem = data.getScriptItemById(id);
			if(!curPlayingItem)
				return;
			playingCommands = curPlayingItem.getChildrenOfGivenClass(Command);
			stepIndex = -1;
			module.parent.setChildIndex(module,module.parent.numChildren-1);
			isPlaying = true;
			playNextCommand();
			
			data.isShowCloseBtn = true;
			global.MOUSE_ENABLE = false;
			module.qjPlayer.moduleLayer.canMouse = false;
		}
		
		public function stop():void{
			data.isShowCloseBtn = false;
			global.MOUSE_ENABLE = true;
			module.qjPlayer.moduleLayer.canMouse = true;
			module.qjPlayer.moduleLayer.restoreModules();
			isPlaying = false;
			stepIndex = -1;
			manager.stopSwingToChild();
			Tweener.removeTweens(this);
			
			module.qjPlayer.managerData.controlData.autorotationCameraData.isAutorotating = false;
			module.qjPlayer.managerData.controlData.autorotationCameraData.enabled = false;
		}
		
		public function playNextCommand():void{
			if(!isPlaying)
				return;
			if(stepIndex >= playingCommands.length-1){
				stop();
				if(curPlayingItem.nextId){
					playScript(curPlayingItem.nextId);
				}
				return;
			}
			stepIndex++;
			doCommand();
			
		}
		
		private function doCommand():void
		{
			curplayingCommand = playingCommands[stepIndex] as Command;
			if(!curplayingCommand){
				playNextCommand();
				return;
			}
		//	trace("curplayingCommand.commandName"+curplayingCommand.commandName);
			switch(curplayingCommand.commandName){
				case Command.WAIT:
					Tweener.addTween(this,{time:curplayingCommand.params.wait_time,onComplete:function():void{playNextCommand();}});
					break;
				case Command.HIDE_OTHER_MODULE:
					hideOtherModules(curplayingCommand.params.hideOtherModule_names.split("-"));
					playNextCommand();
					break;
				case Command.LOAD_PANO:
					var pid:String = curplayingCommand.params.panoId;
					if(manager.currentPanoramaData && manager.currentPanoramaData.id == pid){
						playNextCommand();
						return;
					}
					manager.addEventListener(panoramaEventClass.PANORAMA_LOADED, onPanoramaLoaded, false, 0, true);
					loadPano(pid);
					break;
				case Command.LOAD_PANO_THEN:
					pid = curplayingCommand.params.panoId;
					if(manager.currentPanoramaData && manager.currentPanoramaData.id == pid){
						playNextCommand();
						return;
					}
					manager.addEventListener(panoramaEventClass.PANORAMA_LOADED, onPanoramaLoaded, false, 0, true);
					loadPanoThen(pid);
					break;
				case Command.MOVE_TO_HOTSPOT_THEN:
					var hid:String = curplayingCommand.params.hotId;
					var fieldOfView:Number = curplayingCommand.params.fieldOfView;
					moveToHotspotThen(hid,fieldOfView);
					break;
				case Command.ADVANCED_MOVE_TO_HOTSPOT_THEN:
					var hid2:String = curplayingCommand.params.hotId;
					var fieldOfView2:Number = curplayingCommand.params.fieldOfView;
					var speed:Number = curplayingCommand.params.speed;
					advancedMoveToHotspotThen(hid2,fieldOfView2,speed);
					break;
				case Command.JUMP_MUSEUMITEM:
					var obj:Object = module.qjPlayer.getModuleByName(ModuleName.MuseumItem) as Object;
					if(!obj){
						playNextCommand();
						return;
					}
					obj.museumItemData.onClose = StoryScript.ACTION_CALLBACK_ID;
					var museumId:String = curplayingCommand.params.museumId;
					var autoCloseTime:Number = curplayingCommand.params.autoCloseTime;
					obj.jumpItem(museumId,autoCloseTime);
					break;
				case Command.ADVANCED_MOVE_TO_VIEW_THEN:
					fieldOfView = curplayingCommand.params.fieldOfView;
					speed = curplayingCommand.params.speed;
					var pan:Number = curplayingCommand.params.pan;
					var tilt:Number = curplayingCommand.params.tilt;
					manager.advancedMoveToViewThen(pan,tilt,fieldOfView,speed,null,StoryScript.ACTION_CALLBACK_ID);
					break;
				case Command.AUTO_ROTATION_PANO:
					var autoRotation:Number = curplayingCommand.params.autoRotation;
					module.qjPlayer.autorotationCamera.doAutoMoveThenRunAction(autoRotation,StoryScript.ACTION_CALLBACK_ID);
					break;
				case Command.RUNACTIONCONTENT:
					var content:String = curplayingCommand.params.actioncontent;
					manager.runActionContent(content);
					playNextCommand();
					break;
				case Command.RUNACTION:
					var actionid:String = curplayingCommand.params.actionid;
					manager.runAction(actionid);
					playNextCommand();
					break;
				default:
					playNextCommand();
					break;
			}
//			var tip:StarHtmlText = new StarHtmlText(curplayingCommand.commandName);
//			tip.x = 300;
//			tip.y = 300+stepIndex*5;
//			module.addChild(tip);
		}
		
		protected function onPanoramaLoaded(event:Event):void
		{
			manager.removeEventListener(panoramaEventClass.PANORAMA_LOADED, onPanoramaLoaded);	
			playNextCommand();
		}
		
		public function callBack(event:Event=null):void{
			playNextCommand();
		}
		//	-------------命令执行----------
		/**
		 * 隐藏其他的模块 
		 * @param arr
		 * 
		 */		
		public function hideOtherModules(arr:Array):void{
			module.qjPlayer.moduleLayer.hideOtherModules(arr);
		}
		
		/**
		 * 加载全景
		 * @param arr
		 * 
		 */		
		public function loadPano(pid:String):void{
			manager.loadPano(pid);
		}
		
		/**
		 * 前进再加载
		 * @param arr
		 * 
		 */		
		public function loadPanoThen(pid:String):void{
			manager.loadPanoThen(pid);
		}
		
		/**
		 * 移动到某个热点
		 * @param arr
		 * 
		 */		
		public function moveToHotspotThen(hotId:String,fieldOfView:Number):void{
			manager.moveToHotspotThen(hotId,fieldOfView,StoryScript.ACTION_CALLBACK_ID);
		}
		
		/**
		 * 移动到某个热点
		 * @param arr
		 * 
		 */		
		public function advancedMoveToHotspotThen(hotId:String,fieldOfView:Number,speed:Number):void{
			manager.advancedMoveToHotspotThen(hotId,fieldOfView,speed,null,StoryScript.ACTION_CALLBACK_ID);
		}
	}
}
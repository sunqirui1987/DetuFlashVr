package com.panozona.modules.museumItem.controller
{
	import com.panozona.modules.museumItem.controller.ScrollViewController;
	import com.panozona.modules.museumItem.data.DressItem;
	import com.panozona.modules.museumItem.data.MuseumItem;
	import com.panozona.modules.museumItem.data.MuseumItemData;
	import com.panozona.modules.museumItem.event.MuseumItemEvent;
	import com.panozona.modules.museumItem.util.BackgroundMusicPlayer;
	import com.panozona.modules.museumItem.view.JumpDressWnd;
	import com.panozona.modules.museumItem.view.JumpWnd;
	import com.panozona.player.manager.events.PanoSoundEvent;
	import com.panozona.player.module.Module;
	
	import flash.events.Event;
	import flash.system.ApplicationDomain;

	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-6-10 下午2:20:26
	 * 功能描述:
	 */
	public class JumpWndController
	{
		
		public var jumpWnd:JumpWnd;
		
		public var jumpDressWnd:JumpDressWnd;
		
		private var module:Module;
		
		private var museumItemData:MuseumItemData;
		
		private var backMusicPlayer:BackgroundMusicPlayer;
		
		private var scrollController:ScrollViewController;
		
		public function JumpWndController(museumItemData:MuseumItemData,module:Module)
		{
			this.module = module;
			
			this.museumItemData = museumItemData;
			
			backMusicPlayer = new BackgroundMusicPlayer();
			
			
			
			var ViewEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panosalado.events.ViewEvent") as Class;
			module.qjPlayer.manager.addEventListener(ViewEventClass.BOUNDS_CHANGED, handleResize, false, 0, true);
			handleResize();
			
			museumItemData.addEventListener(MuseumItemEvent.SELECT_NEW_MUSEUM_ITEM,onSelect);
		}
		
		private var isFirst:Boolean = true;
		
		protected function onSelect(event:Event):void
		{
			if(isFirst){
				isFirst = false;
				return;
			}
			if(jumpWnd){
				jumpWnd.resetData(museumItemData.selectItem);
			}
		}
		
		private function handleResize(e:Event = null):void
		{
			if(jumpWnd)
				jumpWnd.handleResize(module.qjPlayer.manager.boundsWidth,module.qjPlayer.manager.boundsHeight);
			if(jumpDressWnd)
				jumpDressWnd.handleResize(module.qjPlayer.manager.boundsWidth,module.qjPlayer.manager.boundsHeight);
		}
		
		public function showJumpDressWnd(item:DressItem,timeToAutoClose:Number=0):void{
			jumpDressWnd = new JumpDressWnd(item,jumpCallBack,museumItemData,module);
			module.qjPlayer.manager.stage.addChild(jumpDressWnd);
		
			if(timeToAutoClose > 0){
				jumpDressWnd.timeToAutoClose = timeToAutoClose;
			}
		}
		
		public function showJumpWnd(item:MuseumItem,timeToAutoClose:Number=0,isShowList:Boolean=false):void{
			if(!jumpWnd){
				jumpWnd = new JumpWnd(item,jumpCallBack,museumItemData,module,isShowList);
				module.qjPlayer.manager.stage.addChild(jumpWnd);
				
				if(museumItemData.scrollData){
					scrollController = new ScrollViewController(jumpWnd.scrollView,module);
				}
				museumItemData.selectItem = item;
			}else{
				museumItemData.selectItem = item;
				jumpWnd.isShowList = isShowList;
				jumpWnd.jump();
			}
			
			if(timeToAutoClose > 0){
				jumpWnd.timeToAutoClose = timeToAutoClose;
			}
			
		}
		
		public function jumpCallBack(obj:Object):void{
			if(!obj) return;
			switch(obj.type){
				case "playJiangjie":
					if(backMusicPlayer._soundPlayStatus){
						backMusicPlayer.pause();
						module.qjPlayer.manager.dispatchEvent(new PanoSoundEvent(PanoSoundEvent.SOUNDCHANGE,"stop","citiao"));
					}else{
						backMusicPlayer.play(obj.url);
						module.qjPlayer.manager.dispatchEvent(new PanoSoundEvent(PanoSoundEvent.SOUNDCHANGE,"play","citiao"));
					}
					break;
				case "close":
					if(jumpDressWnd)
						jumpDressWnd = null;
					backMusicPlayer.stopAndClear();
					module.qjPlayer.manager.dispatchEvent(new PanoSoundEvent(PanoSoundEvent.SOUNDCHANGE,"stop","citiao"));
					if(museumItemData.onClose){
						module.qjPlayer.manager.runAction(museumItemData.onClose);
						museumItemData.onClose = null;
					}else{
						if(museumItemData.selectItem && museumItemData.selectItem.hotId && museumItemData.selectItem.panoId){
					//		module.qjPlayer.manager.loadPanoToNextAndMoveToHotspot(museumItemData.selectItem.panoId,museumItemData.selectItem.hotId)
						}
					}
				case "changeItem":
					backMusicPlayer.stopAndClear();
					module.qjPlayer.manager.dispatchEvent(new PanoSoundEvent(PanoSoundEvent.SOUNDCHANGE,"stop","citiao"));
					break;
			}
		}
	}
}
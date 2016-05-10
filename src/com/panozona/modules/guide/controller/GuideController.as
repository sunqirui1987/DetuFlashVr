package com.panozona.modules.guide.controller
{
	import com.panozona.modules.guide.model.GuideItem;
	import com.panozona.modules.guide.model.GuideStep;
	import com.panozona.modules.guide.view.GuideLayer;
	import com.panozona.player.module.Module;
	import com.panozona.player.module.data.property.Align;
	
	import flash.events.MouseEvent;
	
	import caurina.transitions.Tweener;

	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-9-4 上午11:27:35
	 * 功能描述:
	 */
	public class GuideController
	{
		
		private var view:GuideLayer;
		private var module:Module;
		
		private var isPlaying:Boolean;
		private var stepIndex:int=0;
		private var curPlayingItem:GuideItem;
		
		private var playingCommands:Array;
		
		private var curplayingCommand:GuideStep;
		
		public function GuideController(view:GuideLayer,module:Module)
		{
			this.view = view;
			this.module = module;
		}
		
		public function play(id:String):void{
			if(isPlaying)
				return;
			curPlayingItem = view.guideData.getItemById(id);
			if(!curPlayingItem ||(curPlayingItem.hasPlayed && curPlayingItem.isOnlyPlayOnce))
				return;
			playingCommands = curPlayingItem.getChildrenOfGivenClass(GuideStep);
			stepIndex = -1;
			module.parent.setChildIndex(module,module.parent.numChildren-1);
			isPlaying = true;
			playNextCommand();
		}
		
		public function stop():void{
			isPlaying = false;
			stepIndex = -1;
			Tweener.removeTweens(this);
			view.guideView.isShow = false;
		}
		
		public function playNextCommand():void{
			Tweener.removeTweens(this);
			removeClick();
			view.guideView.isShow = false;
			if(!isPlaying)
				return;
			if(stepIndex >= playingCommands.length-1){
				curPlayingItem.hasPlayed = true;
				stop();
				return;
			}
			stepIndex++;
			doCommand();
		}
		
		private function doCommand():void
		{
			curplayingCommand = playingCommands[stepIndex] as GuideStep;
			if(!curplayingCommand){
				playNextCommand();
				return;
			}
			view.guideView.setData(view,curplayingCommand.showText,curplayingCommand.dir,getWindowOpenX(),getWindowOpenY(),curplayingCommand.picUlr);
			view.guideView.isShow = true;
			if(curplayingCommand.timeToNext){
				Tweener.addTween(this,{time:curplayingCommand.timeToNext,onComplete:function():void{playNextCommand();}});
			}
			module.stage.addEventListener(MouseEvent.MOUSE_UP,onClick);
		}
		
		protected function onClick(event:MouseEvent):void
		{
			removeClick();
			playNextCommand();
		}
		
		private function removeClick():void{
			if(module.stage.hasEventListener(MouseEvent.MOUSE_UP))
				module.stage.addEventListener(MouseEvent.MOUSE_UP,onClick);
		}
		
		private function getWindowOpenX():Number {
			var result:Number = 0;
			switch(curplayingCommand.align.horizontal) {
				case Align.RIGHT:
					result += module.qjPlayer.manager.boundsWidth 
					+ curplayingCommand.move.horizontal;
					break;
				case Align.LEFT:
					result += curplayingCommand.move.horizontal;
					break;
				default: // CENTER
					result += (module.qjPlayer.manager.boundsWidth ) * 0.5 
					+ curplayingCommand.move.horizontal;
			}
			return result;
		}
		
		private function getWindowOpenY():Number{
			var result:Number = 0;
			switch(curplayingCommand.align.vertical) {
				case Align.TOP:
					result += curplayingCommand.move.vertical;
					break;
				case Align.BOTTOM:
					result += module.qjPlayer.manager.boundsHeight 
					+ curplayingCommand.move.vertical;
					break;
				default: // MIDDLE
					result += (module.qjPlayer.manager.boundsHeight 
						) * 0.5
					+ curplayingCommand.move.vertical;
			}
			return result;
		}
	}
}
package com.panozona.modules.museumItem.controller
{
	import com.panozona.modules.museumItem.event.MuseumItemEvent;
	import com.panozona.modules.museumItem.view.ScrollItemView;
	import com.panozona.modules.museumItem.view.ScrollView;
	import com.panozona.player.module.Module;
	
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	
	import caurina.transitions.Tweener;

	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-7-21 下午3:00:31
	 * 功能描述:
	 */
	public class ScrollViewController{
		
		private var module:Module;
		
		private var scrollView:ScrollView;
		
		private var arrControllers:Array = [];
		private var arrViews:Array = [];
		
		public function ScrollViewController(scrollView:ScrollView,module:Module)
		{
			this.module = module;
			this.scrollView = scrollView;
			
			var tempX:Number = 0;
			
			for(var i:int=0;i<scrollView.museumItemData.items.length;i++){
				if(!scrollView.museumItemData.items[i].picUrl)
					continue;
				var itemView:ScrollItemView = new ScrollItemView(scrollView.museumItemData.items[i],scrollView.museumItemData,module);
				itemView.x = tempX;
				itemView.y = (scrollView.museumItemData.scrollData.height-scrollView.museumItemData.scrollData.itemSize.height)*0.5;
				scrollView.elementsContainer.addChild(itemView);
				var controller:ScrollItemViewController = new ScrollItemViewController(itemView,module);
				arrControllers.push(controller);
				arrViews.push(itemView);
				tempX += (scrollView.museumItemData.scrollData.itemSize.width+scrollView.museumItemData.scrollData.gap)+scrollView.museumItemData.scrollData.gap;
			}
			
			var ViewEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panosalado.events.ViewEvent") as Class;
			module.qjPlayer.manager.addEventListener(ViewEventClass.BOUNDS_CHANGED, handleResize, false, 0, true);
			handleResize();
			
			scrollView.museumItemData.addEventListener(MuseumItemEvent.SELECT_NEW_MUSEUM_ITEM,onSelectd);
		}
		
		protected function onSelectd(event:Event):void
		{
			for(var i:int=0;i<arrViews.length;i++){
				var view:ScrollItemView = arrViews[i];
				if(view.itemData == scrollView.museumItemData.selectItem){
					if(view.x+scrollView.elementsContainer.x< 0 || view.x+view.width+scrollView.museumItemData.scrollData.gap+scrollView.elementsContainer.x>scrollView.elementsContainerMask.width){
						var tox:Number = -view.x;
						tox = Math.max(scrollView.elementsContainerMask.width-scrollView.elementsContainer.width,tox);
						tox = Math.min(0,tox);
						if(tox == scrollView.elementsContainer.x)
							return;
						Tweener.pauseTweens(scrollView.elementsContainer);
						Tweener.addTween(scrollView.elementsContainer,{x:tox,time:1});
					}
				}
			}
		}
		
		private function handleResize(e:Event=null):void
		{
			scrollView.drawBg();
			scrollView.showBtnAlign();
			scrollView.elementsContainerMask.graphics.clear();
			scrollView.elementsContainerMask.graphics.beginFill(1,0);
			scrollView.elementsContainerMask.graphics.drawRect(0,0,module.qjPlayer.manager.boundsWidth-scrollView.museumItemData.scrollData.leftpadding*2,scrollView.museumItemData.scrollData.height);
			scrollView.elementsContainerMask.graphics.endFill();
			scrollView.elementsContainer.mask = scrollView.elementsContainerMask;
		}
	}
}
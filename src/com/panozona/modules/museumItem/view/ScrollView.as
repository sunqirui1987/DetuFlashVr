package com.panozona.modules.museumItem.view
{
	import com.panozona.modules.museumItem.data.MuseumItemData;
	import com.panozona.modules.museumItem.data.SourceItem;
	import com.panozona.player.module.Module;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import caurina.transitions.Tweener;
	
	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-7-21 下午2:56:03
	 * 功能描述:
	 */
	public class ScrollView extends Sprite
	{
		
		public var museumItemData:MuseumItemData;
		
		private var module:Module;
		
		public var elementsSp:Sprite;
		
		public const elementsContainer:Sprite = new Sprite();
		public const elementsContainerMask:Sprite = new Sprite();
		
		public var leftBtn:IconView;
		public var rightBtn:IconView;
		
		
		public function ScrollView(museumItemData:MuseumItemData,module:Module)
		{
			this.museumItemData = museumItemData;
			this.module = module;
			drawBg();
			
			elementsSp = new Sprite();
			addChild(elementsSp);
			
			elementsSp.addChild(elementsContainer);
			elementsSp.addChild(elementsContainerMask);
			elementsContainer.mask = elementsContainerMask;
			elementsSp.x = museumItemData.scrollData.leftpadding;
			
			var item2:SourceItem  = museumItemData.getSourceItemByName("btn_scrollLeft");
			if(item2){
				leftBtn = new IconView(item2.baseUrl,item2.mouseOverUrl,function():void{
					leftBtn.y = (museumItemData.scrollData.height-leftBtn.height)*0.5;
					leftBtn.x = (museumItemData.scrollData.leftpadding-leftBtn.width)*0.5;
				});
				addChild(leftBtn);
				leftBtn.buttonMode = true;
				leftBtn.addEventListener(MouseEvent.CLICK,onClick,false,0,true);
			}
			
			item2  = museumItemData.getSourceItemByName("btn_scrollRight");
			if(item2){
				rightBtn = new IconView(item2.baseUrl,item2.mouseOverUrl,function():void{
					rightBtn.y = (museumItemData.scrollData.height-rightBtn.height)*0.5;
					showBtnAlign();
				});
				addChild(rightBtn);
				rightBtn.buttonMode = true;
				rightBtn.addEventListener(MouseEvent.CLICK,onClick,false,0,true);
			}
			super();
		}
		
		protected function onClick(event:MouseEvent):void
		{
			if(event.currentTarget == leftBtn){
				doScroll(-1);
			}else{
				doScroll(1);
			}
		}
		
		public function doScroll(dir:int):void{
			if(elementsContainer.width <= elementsContainerMask.width)
				return;
			var dx:Number = elementsContainerMask.width-elementsContainerMask.width%(museumItemData.scrollData.itemSize.width+museumItemData.scrollData.gap);
			var tox:Number = elementsContainer.x + (dir>0?-dx:dx);
			tox = Math.max(elementsContainerMask.width-elementsContainer.width,tox);
			tox = Math.min(0,tox);
			if(tox == elementsContainer.x)
				return;
			Tweener.pauseTweens(elementsContainer);
			Tweener.addTween(elementsContainer,{x:tox,time:1});
		}
		
		public function drawBg():void{
			this.graphics.clear();
			this.graphics.lineStyle(1,museumItemData.scrollData.borderColor);
			this.graphics.beginFill(museumItemData.scrollData.backColor,museumItemData.scrollData.backAlpha);
			this.graphics.drawRect(0,0,module.qjPlayer.manager.boundsWidth,museumItemData.scrollData.height);
			this.graphics.endFill();
		}
		
		public function showBtnAlign():void{
			rightBtn.x = module.qjPlayer.manager.boundsWidth - rightBtn.width-(museumItemData.scrollData.leftpadding-rightBtn.width)*0.5;
		}
	}
}
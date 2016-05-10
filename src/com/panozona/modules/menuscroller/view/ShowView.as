package com.panozona.modules.menuscroller.view
{
	import com.panozona.modules.menuscroller.model.MenuScrollerData;
	import com.panozona.modules.menuscroller.model.structure.ShowViewItem;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	
	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-6-26 下午1:13:28
	 * 功能描述:
	 */
	public class ShowView extends Sprite
	{
		private var _item:ShowViewItem;
		private var _menuScrollerData:MenuScrollerData;
		
		private var curBmp:Bitmap;
		
		private var preBmp:Bitmap;
		
		public function ShowView(_item:ShowViewItem,_menuScrollerData:MenuScrollerData)
		{
			super();
			this._item = _item;
			this._menuScrollerData = _menuScrollerData;
			this.visible = !_menuScrollerData.windowData.open;
		}
		
		public function get item():ShowViewItem{
			return this._item;
		}
		
		public function get menuScrollerData():MenuScrollerData{
			return this._menuScrollerData;
		}
		
		public function set curBmd(_curBmd:BitmapData):void{
			if(!curBmp){
				curBmp = new Bitmap(_curBmd);
				addChild(curBmp);
				curBmp.filters = [new GlowFilter(0xFFFFFF, 1.0, 5.0, 5.0, 10, 1, false, false)];  
			}
			curBmp.bitmapData = _curBmd;
		}
		
		public function set preBmd(_preBmd:BitmapData):void{
			if(!preBmp){
				preBmp = new Bitmap(_preBmd);
				preBmp.x = item.spaceX;
				preBmp.y = item.spaceY;
				addChildAt(preBmp,0);
				preBmp.filters = [new GlowFilter(0xFFFFFF, 1.0, 5.0, 5.0, 10, 1, false, false)];  
			}
			preBmp.bitmapData = _preBmd;
		}
	}
}
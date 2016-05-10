package com.panozona.modules.menuscroller.view
{
	import com.panozona.modules.menuscroller.model.MenuScrollerData;
	import com.panozona.modules.menuscroller.model.structure.IconItem;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-6-25 下午5:03:49
	 * 功能描述:
	 */
	public class IconView extends Sprite
	{
		private var _item:IconItem;
		
		private var _menuScrollerData:MenuScrollerData;
		
		private var _baseBmd:BitmapData;
		
		private var _mouseOverBmd:BitmapData;
		
		private var bmt:Bitmap;
		
		public function IconView(_item:IconItem,_menuScrollerData:MenuScrollerData)
		{
			super();
			this._item = _item;
			this._menuScrollerData = _menuScrollerData;
		}
		
		public function get item():IconItem{
			return this._item;
		}
		
		public function get menuScrollerData():MenuScrollerData{
			return this._menuScrollerData;
		}
		
		public function set mouseOverBmd(_mouseOverBmd:BitmapData):void{
			this._mouseOverBmd = _mouseOverBmd;
			buttonMode = true;
			addEventListener(MouseEvent.ROLL_OVER, onMouseRoll, false, 0, true);
			addEventListener(MouseEvent.ROLL_OUT, onMouseRoll, false, 0, true);
		}
		
		protected function onMouseRoll(event:MouseEvent):void
		{
			if(!bmt)
				return;
			if(event.type == MouseEvent.ROLL_OVER){
				bmt.bitmapData = _mouseOverBmd;
			}else{
				bmt.bitmapData = _baseBmd;
			}
		}
		
		public function destroy():void{
			if(hasEventListener(MouseEvent.ROLL_OVER))
				removeEventListener(MouseEvent.ROLL_OVER, onMouseRoll);
			if(hasEventListener(MouseEvent.ROLL_OUT))
				removeEventListener(MouseEvent.ROLL_OUT, onMouseRoll);
		}
		
		public function set baseBmd(_baseBmd:BitmapData):void{
			this._baseBmd = _baseBmd;
			if(_baseBmd){
				bmt = new Bitmap(_baseBmd);
				addChild(bmt);
			}
		}
	}
}
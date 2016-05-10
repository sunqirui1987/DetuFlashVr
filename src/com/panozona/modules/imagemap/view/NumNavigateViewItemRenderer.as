package com.panozona.modules.imagemap.view
{
	import com.panozona.modules.imagemap.model.structure.List;
	import com.panozona.modules.imagemap.utils.ShineControler;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-3-11 上午10:06:22
	 * 功能描述:
	 */
	public class NumNavigateViewItemRenderer extends Sprite
	{
		
		private var baseBmd:BitmapData;
		private var selectBmd:BitmapData;
		public var itemData:List;
		
		private var bitmap:Bitmap;
		
		public function NumNavigateViewItemRenderer(baseBmd:BitmapData,selectBmd:BitmapData,itemData:List)
		{
			super();
			this.baseBmd = baseBmd;
			this.selectBmd = selectBmd;
			this.itemData = itemData;
			
			bitmap = new Bitmap();
			bitmap.bitmapData = baseBmd;
			addChild(bitmap);
			
			addEventListener(MouseEvent.ROLL_OVER,onRollOver);
			addEventListener(MouseEvent.ROLL_OUT,onRollOut);
			
			this.buttonMode = true;
		}
		
		private function onRollOver(e:MouseEvent):void{
		//	ShineControler.setBrightness(this,0.15);
		}
		
		private function onRollOut(e:MouseEvent):void{
		//	ShineControler.setBrightness(this,0);
		}
		
		public function destroy():void{
			removeEventListener(MouseEvent.ROLL_OVER,onRollOver);
			removeEventListener(MouseEvent.ROLL_OUT,onRollOut);
		}
		
		private var _select:Boolean;
		public function set select(_select:Boolean):void{
			this._select = _select;
			if(_select){
				bitmap.bitmapData = selectBmd;
			}else{
				bitmap.bitmapData = baseBmd;
			}
		}
	}
}
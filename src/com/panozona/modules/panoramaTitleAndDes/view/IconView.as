package com.panozona.modules.panoramaTitleAndDes.view
{
	
	import com.panozona.player.module.utils.ZLoader;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-5-8 下午5:06:38
	 * 功能描述:
	 */
	public class IconView extends Sprite
	{
		
		private var baseurl:String;
		
		private var mouseOverUrl:String;
		
		private var bmd:Bitmap;
		
		private var baseBmt:BitmapData;
		private var mouseOverBmt:BitmapData;
		
		private var loadedFun:Function;
		private var errFun:Function;
		
		public function IconView(baseurl:String,errFun:Function=null,mouseOverUrl:String=null,loadedFun:Function=null)
		{
			this.baseurl = baseurl;
			this.mouseOverUrl = mouseOverUrl;
			this.loadedFun = loadedFun;
			this.errFun = errFun;
			
			if(baseurl){
				new ZLoader().load(baseurl,errFun,function(event:Event):void{
					var loaderInfo:LoaderInfo = event.target as LoaderInfo;
					baseBmt = (loaderInfo.content as Bitmap).bitmapData.clone();
					bmd = new Bitmap(baseBmt);
					addChildAt(bmd,0);
					loadFinish();
				});
			}
			
			if(mouseOverUrl){
				new ZLoader().load(mouseOverUrl,errFun,function(event:Event):void{
					var loaderInfo:LoaderInfo = event.target as LoaderInfo;
					mouseOverBmt = (loaderInfo.content as Bitmap).bitmapData.clone();
					addEventMouseEvent();
				});
			}
		}
		
		private function loadFinish():void{
			if(loadedFun != null){
				loadedFun();
				loadedFun = null;
			}
			
		}
		
		private function addEventMouseEvent():void
		{
			addEventListener(MouseEvent.MOUSE_OVER,onMouseRollOver);
			addEventListener(MouseEvent.MOUSE_OUT,onMouseRollOut);	
		}
		
		protected function onMouseRollOut(event:MouseEvent):void
		{
			if(bmd && baseBmt)		
				bmd.bitmapData = baseBmt;
		}
		
		protected function onMouseRollOver(event:MouseEvent):void
		{
			if(bmd && mouseOverBmt)		
				bmd.bitmapData = mouseOverBmt;
		}
		
		public function destroy():void{
			if(hasEventListener(MouseEvent.MOUSE_OVER))
				removeEventListener(MouseEvent.MOUSE_OVER,onMouseRollOver);
			if(hasEventListener(MouseEvent.MOUSE_OUT))
				addEventListener(MouseEvent.MOUSE_OUT,onMouseRollOut);	
			errFun = null;
		}
	}
}
/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.openMovie.view{
	
	import com.panozona.modules.openMovie.model.OpenMovieData;
	import com.panozona.modules.openMovie.model.WindowData;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	
	public class WindowView extends Sprite{
		
		private var _openMovieData:OpenMovieData;
		
		public var loadBar:LoadingHtmlTextBar;
		
		/**
		 * 动画对象 
		 */		
		public var movieObj:AnimationObj;
		
		private var qjPlayer:Object;
		
		public function WindowView(_openMovieData:OpenMovieData,qjPlayer:Object) {
			
			this._openMovieData  = _openMovieData;
			this.qjPlayer = qjPlayer;
			
			movieObj = new AnimationObj(_openMovieData.setting.path,1,onProgress,true,0,0,onDestroy,onloadCmp);
			addChild(movieObj);
		}
		
		private var isMovieLoaded:Boolean;
		
		/**
		 * 片头销毁
		 * @param e
		 * 
		 */		
		private function onDestroy():void{
			if(loadBar)
				loadBar.visible = false;
			if(movieObj.hasEventListener(MouseEvent.CLICK))
				movieObj.removeEventListener(MouseEvent.CLICK,jumpToEnd);
			if(movieObj){
				movieObj = null;
			}
			closeWnd(null);
			if(_openMovieData.setting.playOverAction)
				qjPlayer.manager.runAction(_openMovieData.setting.playOverAction);
		}
		
		/**
		 * 片头加载完毕
		 * @param e
		 * 
		 */		
		private function onloadCmp():void{
			if(loadBar)
				loadBar.visible = false;
			isMovieLoaded = true;
			movieObj.addEventListener(MouseEvent.CLICK,jumpToEnd);
			movieObj.buttonMode = true;
			movieObj.x = (qjPlayer.manager.boundsWidth - movieObj.width)*0.5;
			movieObj.y = (qjPlayer.manager.boundsHeight - movieObj.height)*0.5;
			movieObj.x = Math.max(movieObj.x,0);
			movieObj.y = Math.max(movieObj.y,0);
		}
		
		/**
		 * 跳过片头 
		 * @param event
		 * 
		 */		
		public function jumpToEnd(event:MouseEvent=null):void
		{
			if(movieObj)
			{
				movieObj.destroy();
			}
			
		}
		
		/**
		 * 加载片头进度 
		 * @param e
		 * 
		 */		
		private function onProgress(e:ProgressEvent):void{
			setPersent(e.bytesLoaded*100/e.bytesTotal,"正在加载片头动画 ");
		}
		
		
		public function setPersent(num:int,msg:String):void{
			if(loadBar){
				loadBar.htmlTxt = msg+num+"%";
				loadBar.setPersent(num);
			}else{
				loadBar = new LoadingHtmlTextBar("正在加载片头动画 ",jumpToEnd);
				addChild(loadBar);
			}
			loadBar.x = (qjPlayer.manager.boundsWidth-loadBar.width)*0.5;
			loadBar.y = (qjPlayer.manager.boundsHeight -loadBar.height)*0.5;
		}
		
		public function get windowData():WindowData{
			return this._openMovieData.windowData;
		}
		
		/**
		 * 关闭窗口 
		 * @param event
		 * 
		 */		
		protected function closeWnd(event:MouseEvent):void
		{
			this._openMovieData.windowData.open = false;
		}
		
	}
}
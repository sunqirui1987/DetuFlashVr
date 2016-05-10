package com.panozona.modules.openMovie
{
	import com.panozona.modules.openMovie.controller.OpenMovieController;
	import com.panozona.modules.openMovie.model.OpenMovieData;
	import com.panozona.modules.openMovie.view.OpenMovieView;
	import com.panozona.player.module.Module;
	import com.panozona.player.module.data.ModuleData;
	
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	
	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-3-3 上午9:37:38
	 * 功能描述:留言板模块
	 */
	public class OpenMovie extends Module
	{
		private var openMovieData:OpenMovieData;
		
		private var openMovieView:OpenMovieView;
		
		private var openMovieController:OpenMovieController;
		
		
		public function OpenMovie()
		{
			super("OpenMovie", "1.1", "http://panozona.com/wiki/Module:OpenMovie");
			moduleDescription.addFunctionDescription("jumpToEnd");
		}
		
		override protected function moduleReady(moduleData:ModuleData):void {
			
			openMovieData = new OpenMovieData(moduleData, qjPlayer); // always first
			
			openMovieView = new OpenMovieView(openMovieData,qjPlayer);
			openMovieController = new OpenMovieController(openMovieView, this);
			addChild(openMovieView);
			
			if(openMovieData.setting.overWhenPanoramaTransitionEnded){
				var panoramaEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.events.PanoramaEvent") as Class;
				qjPlayer.manager.addEventListener(panoramaEventClass.TRANSITION_ENDED, doJump,false, 0, true);
			}
		}
		
		private function doJump(e:Event):void{
			jumpToEnd();
		}
		
		///////////////////////////////////////////////////////////////////////////////
		//  Exposed functions 
		///////////////////////////////////////////////////////////////////////////////
		
		public function jumpToEnd():void{
			openMovieView.windowView.jumpToEnd();
		}
		
	}
}
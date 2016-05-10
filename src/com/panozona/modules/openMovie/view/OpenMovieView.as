package com.panozona.modules.openMovie.view
{
	import com.panozona.modules.openMovie.model.OpenMovieData;
	import com.panozona.modules.openMovie.view.ShadowView;
	import com.panozona.modules.openMovie.view.WindowView;
	
	import flash.display.Sprite;

	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-3-3 上午9:41:43
	 * 功能描述:片头动画
	 */
	public class OpenMovieView extends Sprite
	{
		
		public var windowView:WindowView;
		
		public var shadowView:ShadowView;
		
		public var openMovieData:OpenMovieData;
		
		public function OpenMovieView(openMovieData:OpenMovieData,qjPlayer:Object)
		{
			this.openMovieData = openMovieData;
			
			shadowView = new ShadowView(openMovieData);
			addChild(shadowView);
			
			windowView = new WindowView(openMovieData,qjPlayer);
			addChild(windowView);
			
		}
	}
}
/*
 OuWei Flash3DHDView 
*/
package com.panozona.player.manager.data.global{
	
	public class AllPanoramasData{
		
		/**
		 * id of first panorama that will be loaded,
		 * if not set, QjPlayer will load first panorama in line. 
		 */
		public var firstPanorama:String;
		
		/**
		 * id of action that will be executed on loading first panorama
		 */
		public var firstOnEnter:String;
		
		/**
		 * id of action that will be executed on when transition effect
		 * in first panorama has finished
		 */
		public var firstOnTransitionEnd:String;
		
		/**
		 * 是否自动关联全景，为true时会有箭头来关联全景 
		 */		
		public var isAutoLink:Boolean;
		
		
		/**
		 * 帮助动画的地址，会在第一个全景加载完成的时候播放
		 */		
		public var helpPath:String = null;
		
		/**
		 * 是否在帮助动画播完后自动关闭 
		 */		
		public var isAutoCloseWhenEndHelp:Boolean;
		
		/**
		 * 关联箭头的样式
		 * 0：尖角
		 * 1：带柄箭头
		 */		
		public var linkArrowDrawType:int=0;
		
		/**
		 */		
		public var linkArrowDrawHeight:int=200;
		
	}
}
package com.panozona.modules.openMovie.model.structure
{
	import com.panozona.player.module.data.property.MouseOverOut;

	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-2-20
	 * 功能描述:
	 */
	public class Setting
	{
		/**
		 * 动画地址 
		 */		
		public var path:String;
		
		/**
		 * 是否需要背影
		 */		
		public var needBackShadow:Boolean;
		
		/**
		 * 背影颜色
		 */		
		public var backShadowColor:int;
		
		/**
		 * 背影透明度
		 */		
		public var backShadowAlpha:Number;
		
		/**
		 * 鼠标事件 
		 */		
		public const mouse:MouseOverOut = new MouseOverOut();
		
		/**
		 * 是否关联
		 */	
		public var overWhenPanoramaTransitionEnded:Boolean;
		
		/**
		 * 结束后关联的action
		 */		
		public var playOverAction:String;
		
		
		public function Setting()
		{
		}
	}
}
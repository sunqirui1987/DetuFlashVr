package com.panozona.modules.guestBook.model.structure
{
	import com.panozona.player.module.data.property.Align;
	import com.panozona.player.module.data.property.Move;

	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-2-20
	 * 功能描述:
	 */
	public class Setting
	{
		/**
		 * 数据读取地址 
		 */		
		public var dataPath:String;
		
		/**
		 * 存储地址 
		 */		
		public var savePath:String;
		
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
		
		public function Setting()
		{
		}
	}
}
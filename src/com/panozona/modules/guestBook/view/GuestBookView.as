package com.panozona.modules.guestBook.view
{
	import com.panozona.modules.guestBook.model.GuestBookData;
	
	import flash.display.Sprite;
	
	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-2-20
	 * 功能描述:
	 */
	public class GuestBookView extends Sprite
	{
		
		public var windowView:WindowView;
		
		public var shadowView:ShadowView;
		
		public var guestBookData:GuestBookData;
		
		public function GuestBookView(guestBookData:GuestBookData)
		{
			super();
			
			this.guestBookData = guestBookData;
			
			shadowView = new ShadowView(guestBookData);
			addChild(shadowView);
			
			windowView = new WindowView(guestBookData);
			addChild(windowView);
			
			
		}
	}
}
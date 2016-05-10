package com.panozona.player.manager.data.panoramas.poly
{
	import com.panozona.player.manager.Manager;

	import flash.display.Sprite;

	public class PolyAssert
	{
		public var assertSprite:Sprite = null;
		
		
		public function PolyAssert(manager:Manager,assert:String,type:String,extra:String)
		{
			if(assert == "" || assert == null || type == "" || type == null)
			{
				return ;
			}
			if(type == "swf" || type == "img")
			{
				assertSprite = new PolyImageAssert(manager,assert,extra);
			}
			else if(type == "video")
			{
				assertSprite = new PolyVideoAssert(manager,assert,extra);
			}
		}
	
	}

}

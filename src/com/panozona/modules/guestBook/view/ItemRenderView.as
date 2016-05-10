package com.panozona.modules.guestBook.view
{
	import com.panozona.modules.guestBook.model.structure.Message;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-2-21
	 * 功能描述:
	 */
	public class ItemRenderView extends Sprite
	{
		
		public var messageData:Message;
		
		public function ItemRenderView(mcCls:Object,messageData:Message)
		{
			super();
			this.messageData = messageData;
			
			var mc:MovieClip = new mcCls();
			addChild(mc);
			
			var txt_nameAndDate:TextField = mc.getChildByName("txt_nameAndDate") as TextField;
			var txt_content:TextField = mc.getChildByName("txt_content") as TextField;
			
			txt_content.text = messageData.content;
			
			txt_nameAndDate.text = messageData.name+" ："+messageData.date;
		}
		
		/**
		 * 销毁 
		 * 
		 */		
		public function destroy():void{
			
		}
	}
}
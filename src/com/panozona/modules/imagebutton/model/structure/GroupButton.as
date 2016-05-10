package com.panozona.modules.imagebutton.model.structure
{
	import com.panozona.modules.imagebutton.events.WindowEvent;
	import com.panozona.player.module.data.structure.DataParent;

	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-4-15 下午7:21:01
	 * 功能描述:
	 */
	public class GroupButton extends DataParent{
		
		override public function getChildrenTypes():Vector.<Class>{
			var result:Vector.<Class> = new Vector.<Class>();
			result.push(Window);
			result.push(Bg);
			result.push(Button);
			return result;
		}
		
		public var window:Window;
		public var bg:Bg;
		
		public var id:String;
		
		public var panoid:String=""
		
		public function GroupButton()
		{
		}
	}
}
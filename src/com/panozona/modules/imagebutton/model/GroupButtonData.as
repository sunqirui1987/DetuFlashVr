package com.panozona.modules.imagebutton.model
{
	import com.panozona.modules.imagebutton.events.WindowEvent;
	import com.panozona.modules.imagebutton.model.structure.GroupButton;
	
	import flash.events.EventDispatcher;
	
	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-4-17 下午2:11:00
	 * 功能描述:
	 */
	public class GroupButtonData extends EventDispatcher
	{
		private var _open:Boolean;
		public function get open():Boolean{return _open}
		public function set open(value:Boolean):void {
			if (value == _open) return;
			_open = value;
			dispatchEvent(new WindowEvent(WindowEvent.CHANGED_OPEN));
		}
		
		public var groupButton:GroupButton;
		
		public function GroupButtonData(groupButton:GroupButton)
		{
			this.groupButton = groupButton;
			_open = groupButton.window.open;
		}
	}
}
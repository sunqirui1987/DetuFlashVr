package com.panozona.modules.inteltool.data
{
	import com.panozona.player.module.data.structure.DataParent;

	public class AutoZzzSetting extends DataParent
	{
		public var enable:Boolean=false;
		public var isenable:Boolean=false;
		
		override public function getChildrenTypes():Vector.<Class>{
			var result:Vector.<Class> = new Vector.<Class>();
			result.push(PanoSetting);
			return result;
		}
		
	}
}
package com.panozona.modules.inteltool.data
{
	import com.panozona.player.module.data.structure.DataParent;

	public class AutoDySetting extends DataParent
	{
		public var enable:Boolean=false;
		public var playenable:Boolean=false;
		public var isenable:Boolean=false;
		public var mp3url:String="";
		public var startaction:String="";
		public var isenableauto:Boolean=true;
		
		
	   public override function getChildrenTypes():Vector.<Class>
	   {
	   		var result:Vector.<Class> = new Vector.<Class>();
			result.push(DySetting);
			
			return result;
	   }
	}
}
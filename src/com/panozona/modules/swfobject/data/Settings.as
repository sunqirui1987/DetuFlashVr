package com.panozona.modules.swfobject.data
{
	import com.panozona.player.module.data.structure.DataParent;
	

		public class Settings  extends DataParent
		{
			
			
			public override function getChildrenTypes():Vector.<Class>
			{
				var result:Vector.<Class> = new Vector.<Class>();
				result.push(SwfInfo);
				
				return result;
			}
			
		}
}

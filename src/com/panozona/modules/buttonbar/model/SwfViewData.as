package com.panozona.modules.buttonbar.model
{
	import com.panozona.modules.buttonbar.model.structure.SwfViewDataItem;
	import com.panozona.player.module.data.structure.DataParent;

	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-8-20 上午8:43:59
	 * 功能描述:
	 */
	public class SwfViewData extends DataParent
	{
		
		public var url:String;
		
		public function SwfViewData()
		{
		}
		
		override public function getChildrenTypes():Vector.<Class>{
			var result:Vector.<Class> = new Vector.<Class>();
			result.push(SwfViewDataItem);
			return result;
		}
		
		
		public function getSwfViewDataItemById(id:String):SwfViewDataItem{
			for each(var item:SwfViewDataItem in getChildrenOfGivenClass(SwfViewDataItem)){
				if(id == item.id)
					return item;
			}
			return null;
		}
	}
}
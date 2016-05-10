package com.panozona.modules.imagemap.model.structure
{
	import com.panozona.player.module.data.structure.DataParent;

	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-4-10 下午3:19:47
	 * 功能描述:
	 */
	public class Layers extends DataParent
	{
		public function Layers()
		{
		}
		
		override public function getChildrenTypes():Vector.<Class>{
			var result:Vector.<Class> = new Vector.<Class>();
			result.push(Layer);
			return result;
		}
	}
}
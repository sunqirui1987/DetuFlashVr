package com.panozona.modules.imagemap.model.structure
{
	import com.panozona.player.module.data.property.Align;
	import com.panozona.player.module.data.property.Move;
	import com.panozona.player.module.data.property.Size;
	import com.panozona.player.module.data.structure.DataParent;
	
	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-3-11 上午9:35:02
	 * 功能描述:
	 */
	public class Lists extends DataParent
	{
		
		public var model:int = 0;
		
		public var model1_num_url:String; 
		
		public var model1_tooltip_url:String; 
		
		public var model2_back_url:String; 
		
		public var model2_downListBack_url:String; 
		
		public var model2_dropListSmallArrow_url:String; 
		
		public var model2_dropListTriangle_url:String; 
		
		public const move:Move = new Move(-20, 20);
		public const align:Align = new Align(Align.RIGHT, Align.TOP);
		
		public var fontSize:int= 15;
		
		public var textHeight:int= 21;
		
		override public function getChildrenTypes():Vector.<Class>{
			var result:Vector.<Class> = new Vector.<Class>();
			result.push(List);
			return result;
		}
		
		public function Lists()
		{
			super();
		}
		
		public function getLableByMapId(mapId:String):String{
			for each(var list:List in getChildrenOfGivenClass(List)){
				if(mapId == list.mapid)
					return list.label;
			}
			return "";
		}
	}
}
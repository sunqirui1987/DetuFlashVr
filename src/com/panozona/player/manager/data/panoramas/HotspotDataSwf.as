/*
 OuWei Flash3DHDView 
*/
package com.panozona.player.manager.data.panoramas {
	
	import com.panozona.player.manager.utils.loading.ILoadable;
	import com.panozona.player.module.data.DataNode;
	
	public class HotspotDataSwf extends HotspotData implements ILoadable{
		
		protected var _path:String;
		public const nodes:Vector.<DataNode> = new Vector.<DataNode>();
		
		public function HotspotDataSwf(id:String, path:String){
			super(id);
			_path = path;
		}
		
		public function get path():String {
			return _path;
		}
	}
}
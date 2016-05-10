/*
 OuWei Flash3DHDView 
*/
package com.panozona.player.manager.data.panoramas {
	
	import com.panozona.player.manager.utils.loading.ILoadable;
	
	public class HotspotDataImage extends HotspotData implements ILoadable {
		
		protected var _path:String;
		
		public function HotspotDataImage(id:String, path:String){
			super(id);
			_path = path;
		}
		
		public function get path():String {
			return _path;
		}
	}
}
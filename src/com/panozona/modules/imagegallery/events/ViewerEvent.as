/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.imagegallery.events {
	
	import flash.events.Event;
	
	public class ViewerEvent extends Event {
		
		public static const CHANGED_CURRENT_GROUP_ID:String = "changedCurrGroupId";
		public static const CHANGED_CURRENT_IMAGE_INDEX:String = "changedCurrImgIndex";
		
		
		public function ViewerEvent(type:String) {
			super(type);
		}
	}
}
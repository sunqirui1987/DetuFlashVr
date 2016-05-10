/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.imagegallery.model {
	
	import com.panozona.modules.imagegallery.events.ViewerEvent;
	import com.panozona.modules.imagegallery.model.structure.Group;
	import com.panozona.modules.imagegallery.model.structure.Groups;
	import com.panozona.modules.imagegallery.model.structure.Viewer;
	import flash.events.EventDispatcher;
	
	public class ViewerData extends EventDispatcher{
		
		public const viewer:Viewer = new Viewer();
		public const groups:Groups = new Groups();
		
		private var _currentGroupId:String;
		private var _currentImageIndex:Number;
		
		public function getGroupById(groupId:String):Group {
			for each(var group:Group in groups.getChildrenOfGivenClass(Group)) {
				if (group.id == groupId) return group;
			}
			return null;
		}
		
		public function get currentGroupId():String {return _currentGroupId;}
		public function set currentGroupId(value:String):void {
			if (value == null || value == _currentGroupId) return;
			_currentGroupId = value;
			dispatchEvent(new ViewerEvent(ViewerEvent.CHANGED_CURRENT_GROUP_ID));
		}
		
		public function get currentImageIndex():Number { return _currentImageIndex;}
		public function set currentImageIndex(value:Number):void {
			if (isNaN(value) || value == _currentImageIndex) return;
			_currentImageIndex = value;
			dispatchEvent(new ViewerEvent(ViewerEvent.CHANGED_CURRENT_IMAGE_INDEX));
		}
	}
}
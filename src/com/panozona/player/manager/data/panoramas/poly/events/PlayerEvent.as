/*
 OuWei Flash3DHDView 
*/
package  com.panozona.player.manager.data.panoramas.poly.events {
	
	import flash.events.Event;
	
	public class PlayerEvent extends Event{
		
		public static const CHANGED_NAVIGATION_ACTIVE:String = "chngdNaviActive";
		
		public function PlayerEvent(type:String) {
			super(type);
		}
	}
}
/*
 OuWei Flash3DHDView 
*/
package  com.panozona.player.manager.data.panoramas.poly.events{
	
	import flash.events.Event;
	
	public class StreamEvent extends Event {
		
		public static const CHANGED_STREAM_STATE:String = "chngdStreamState";
		public static const CHANGED_BYTES_LOADED:String = "chngdBytesLoaded";
		public static const CHANGED_VIEW_TIME:String = "chngdViewTime";
		public static const CHANGED_SEEK_TIME:String = "chngdSeekTime";
		public static const CHANGED_IS_BUFFERING:String = "chngdIsBuffering";
		public static const CHANGED_VOLUME_VALUE:String = "chngdVolumeValue";
		
		public function StreamEvent(type:String) {
			super(type);
		}
	}
}
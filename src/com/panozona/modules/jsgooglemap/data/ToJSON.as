/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.jsgooglemap.data{
	
	import com.panozona.modules.jsgooglemap.data.structure.*;
	
	public class ToJSON{
		
		public function translate(jsGoogleMapData:JSGoogleMapData):String {
			var result:String = "{"+q("data") +":{";
			result += formatSettings(jsGoogleMapData.settings) + ",";
			result += formatWaypoints(jsGoogleMapData.waypoints) + ",";
			result += formatMarkers(jsGoogleMapData.waypoints) + ",";
			result += formatTracks(jsGoogleMapData.tracks) + "}}";
			return result;
		}
		
		private function formatSettings(settings:Settings):String {
			var result:String = q("settings") + ":{}";
			return result;
		}
		
		private function formatWaypoints(waypoints:Waypoints):String {
			var result:String = q("waypoints") + ": [";
			for each(var waypoint:Waypoint in waypoints.getChildrenOfGivenClass(Waypoint)) {
				result += formatWaypoint(waypoint) +",";
			}
			if (result.charAt(result.length - 1) == ",") {
				result = result.substring(0, result.length - 1);
			}
			result += "]";
			return result;
		}
		
		private function formatWaypoint(waypoint:Waypoint):String {
			var result:String = "{";
			result += q("target") + ":" + q(waypoint.target) +",";
			result += q("label") + ":" + q(waypoint.label) +",";
			result += q("lat") + ":" + waypoint.geolocation.latitude +",";
			result += q("lng") + ":" + waypoint.geolocation.longitude +"}";
			return result;
		}
		
		private function formatMarkers(waypoints:Waypoints):String {
			var result:String = q("markers") + ":{";
			result += q("markerOn") + ":" + q(waypoints.markerOn) + ","
			result += q("markerOff") + ":" + q(waypoints.markerOff) + "}"
			return result;
		}
		
		private function formatTracks(tracks:Tracks):String {
			var result:String = q("tracks") + ": [";
			for each(var track:Track in tracks.getChildrenOfGivenClass(Track)) {
				result += formatTrack(track) +",";
			}
			if (result.charAt(result.length - 1) == ",") {
				result = result.substring(0, result.length - 1);
			}
			result += "]";
			return result;
		}
		
		private function formatTrack(track:Track):String {
			return "{" + q("path") + ":" + q(track.path) + "}";
		}
		
		private function q(value:String):String {
			return "\"" + value + "\"";
		}
	}
}
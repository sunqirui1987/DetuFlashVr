/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.backgroundmusic.data{
	
	import com.panozona.modules.backgroundmusic.data.structure.Settings;
	import com.panozona.modules.backgroundmusic.data.structure.Track;
	import com.panozona.modules.backgroundmusic.data.structure.Tracks;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.data.DataNode;
	import com.panozona.player.module.utils.DataNodeTranslator;
	
	public class BackgroundMusicData {
		
		public var settings:Settings = new Settings();
		public var tracks:Tracks = new Tracks();
		
		public function BackgroundMusicData(moduleData:ModuleData, qjPlayer:Object):void {
			
			var tarnslator:DataNodeTranslator = new DataNodeTranslator(qjPlayer.managerData.debugMode);
			
			for each(var dataNode:DataNode in moduleData.nodes){
				if(dataNode.name == "settings") {
					tarnslator.dataNodeToObject(dataNode, settings);
				}else if(dataNode.name == "tracks") {
					tarnslator.dataNodeToObject(dataNode, tracks);
				}else {
					qjPlayer.traceWindow.printError("Invalid node name: " + dataNode.name);
				}
			}
			
			if (qjPlayer.managerData.debugMode) {
				if (tracks.getChildrenOfGivenClass(Track).length == 0) qjPlayer.traceWindow.printError("No Tracks found.");
				if (settings.onPlay != null && qjPlayer.managerData.getActionDataById(settings.onPlay) == null)
					qjPlayer.traceWindow.printError("Action does not exist: " + settings.onPlay);
				if (settings.onStop != null && qjPlayer.managerData.getActionDataById(settings.onStop) == null)
					qjPlayer.traceWindow.printError("Action does not exist: " + settings.onStop);
				var trackIds:Object = new Object();
				for each (var track:Track in tracks.getChildrenOfGivenClass(Track)) {
					if (track.id == null) qjPlayer.traceWindow.printError("Track id not specified.");
					if (track.path == null) qjPlayer.traceWindow.printError("Path not specified in track: " + track.id);
					if (!track.path.match(/^.+\.mp3$/i)) qjPlayer.traceWindow.printError("Invalid path in track: " + track.id);
					if (trackIds[track.id] != undefined) {
						qjPlayer.traceWindow.printError("Repeating track id: " + track.id);
					}else {
						trackIds[track.id] = ""; // something
					}
				}
				for each (track in tracks.getChildrenOfGivenClass(Track)) {
					if (track.next != null && trackIds[track.next] == undefined) {
						qjPlayer.traceWindow.printError("Track does not exist: " + track.next);
					}
				}
			}
		}
	}
}
/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.backgroundmusic.data.structure{
	
	public class Settings{
		
		/**
		 * If music is played on start
		 */
		public var play:Boolean = false;
		
		/**
		 * Id of action executed when 
		 * sound changes state to unmute
		 */
		public var onPlay:String = null;
		
		/**
		 * Id of action executed when 
		 * sound changes state to mute
		 */
		public var onStop:String = null;
	}
}
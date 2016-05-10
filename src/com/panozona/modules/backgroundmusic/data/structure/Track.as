/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.backgroundmusic.data.structure{
	
	public class Track{
		
		/**
		 * Id unique among other tracks
		 */
		public var id:String = null;
		
		/**
		 * Path to mp3 file
		 */
		public var path:String = null;
		
		/**
		 * Volume 0.0 to 1.0
		 */
		public var volume:Number = 1;
		
		/**
		 * If track is looped
		 */
		public var loop:Boolean = true;
		
		/**
		 * Next track played
		 */
		public var next:String = null;
		
		/**
		 * 是否BG
		 * */
		public var isbg:Boolean = false;
		
		/**
		 * 所属的pano 
		*/
		public var panoid:String = "";
	}
}
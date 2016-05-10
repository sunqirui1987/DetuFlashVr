
package com.panosalado.model {
	
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	public class TilePyramid extends EventDispatcher {
		
		public var width:int;
		public var height:int;
		public var numTiles:int;
		public var tileSize:int;
		public var overlap:int;
		public var numTiers:int
		
		public var widths:Vector.<int>;
		public var heights:Vector.<int>;
		
		public var accurateWidths:Vector.<Number>;
		public var accurateHeights:Vector.<Number>;
		
		public var columns:Vector.<uint>;
		public var rows:Vector.<uint>;
		
		public var format:String;
		public var path:String;
		
		private static var urlPatternToSubClassConcordance:Dictionary = new Dictionary(true)
		
		public static function processDependency(reference:Object,characteristics:*):void {
			if (reference.hasOwnProperty("urlPattern") && reference.urlPattern is RegExp && reference is Class){
				urlPatternToSubClassConcordance[reference.urlPattern] = reference
			}
		}
		
		public static function guessSubClassFromURL(url:String):Class {
			for (var urlPattern:* in urlPatternToSubClassConcordance) {
				if ( url.match(urlPattern) ){
					return urlPatternToSubClassConcordance[urlPattern];
				}
			}
			// if you have gotten here there is no TilePyramid Class that has been passed into PanoSalado.initialize
			// with a matching urlPattern for your url.  Bad.  Error.
			throw new Error("Given path: " + url + " can not be resolved to a TilePyramid subclass");
			return null
		}
		
		public function loadDescriptor(path:String):void {
			throw new Error ("TilePyramid:loadDescriptor must be overriden");
		}
		
		public function disassembleDescriptorURL(path:String):DisassembledDescriptorURL{
			return new DisassembledDescriptorURL();
		}
		
		public function getTileURL( t : uint, c : uint, r : uint ) : String{
			throw new Error ("TilePyramid:getTileURL must be overriden");
		}
		
		public function clone(into:TilePyramid = null):TilePyramid {
			throw new Error ("TilePyramid:clone must be overriden");
		}
	}
}
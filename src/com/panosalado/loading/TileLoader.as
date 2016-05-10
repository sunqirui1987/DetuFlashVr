
package com.panosalado.loading {
	
	import com.panosalado.model.Tile;
	import com.panosalado.model.ViewData;
	import flash.display.Loader;
	
	public class TileLoader extends Loader {
		
		public var tile:Tile
		public var timeStamp:int;
		public var viewData:ViewData; //reference to viewData so that it can be invalidated when this loads.
	}
}
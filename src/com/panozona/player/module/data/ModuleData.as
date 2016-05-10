/*
 OuWei Flash3DHDView 
*/
package com.panozona.player.module.data {
	
	import com.panozona.player.manager.utils.loading.ILoadable;
	import com.panozona.player.module.utils.ModuleDescription;
	
	public class ModuleData implements ILoadable{
		
		public const nodes:Vector.<DataNode> = new Vector.<DataNode>();
		
		
		private var _name:String;
		private var _path:String;
		private var _descriptionReference:ModuleDescription;
		
		private var _moduleDataXml:XML;
		
		public function ModuleData(name:String, path:String,moduleDataXml:XML=null) {
			_name = name;
			_path = path;
			_moduleDataXml = moduleDataXml
		}
		
		public final function get moduleDataXml():XML {
			return _moduleDataXml;
		}
		
		public final function get name():String {
			return _name;
		}
		
		public final function get path():String {
			return _path;
		}
		
		/**
		 * Description reference can be set only once
		 * trying to set reference again will couse an error.
		 */
		public final function set descriptionReference(description:ModuleDescription):void {
			//if (_descriptionReference != null) throw new Error("Description reference allready set!");
			_descriptionReference = description;
		}
		
		/**
		 * @private
		 */
		public final function get descriptionReference():ModuleDescription {
			return _descriptionReference;
		}
	}
}
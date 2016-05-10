
package com.panosalado.model {
	
	public class DisassembledDescriptorURL {
		
		public var base:String;
		public var id:String;
		public var extension:String;
		
		public function DisassembledDescriptorURL(base:String=null,id:String=null,extension:String=null) {
			this.base = base;
			this.id = id;
			this.extension=extension;
		}
	}
}
/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.linkopener {
	
	import com.panozona.modules.linkopener.data.LinkOpenerData;
	import com.panozona.modules.linkopener.data.structure.Link;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.Module;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	
	public class LinkOpener extends Module{
		
		private var linkOpenerData:LinkOpenerData;
		
		public function LinkOpener(){
			super("LinkOpener", "1.1", "http://ouwei.cn/wiki/Module:LinkOpener");
			moduleDescription.addFunctionDescription("open", String);
		}
		
		override protected function moduleReady(moduleData:ModuleData):void {
			visible = false;
			linkOpenerData = new LinkOpenerData(moduleData, qjPlayer);
		}
		
///////////////////////////////////////////////////////////////////////////////
//  Exposed functions 
///////////////////////////////////////////////////////////////////////////////
		
		public function open(linkId:String):void {
			for each(var link:Link in linkOpenerData.links.getChildrenOfGivenClass(Link)) {
				if (link.id == linkId) {
					navigateToURL(new URLRequest(link.content), link.target);
					return;
				}
			}
			printWarning("Calling nonexistant link: " + linkId);
		}
	}
}
/*
 OuWei Flash3DHDView 
*/
package com.panozona.player.manager.data {
	
	import com.panozona.modules.imagegallery.model.structure.Group;
	import com.panozona.player.manager.data.actions.ActionData;
	import com.panozona.player.manager.data.global.AllPanoramasData;
	import com.panozona.player.manager.data.global.BrandingData;
	import com.panozona.player.manager.data.global.ContextMenuData;
	import com.panozona.player.manager.data.global.ControlData;
	import com.panozona.player.manager.data.global.StatsData;
	import com.panozona.player.manager.data.global.TraceData;
	import com.panozona.player.manager.data.panoramas.HotspotData;
	import com.panozona.player.manager.data.panoramas.PanoramaData;
	import com.panozona.player.manager.data.streetview.StreetviewData;
	import com.panozona.player.module.data.ModuleData;

	public class ManagerData{
		
		public var debugMode:Boolean = true;
		
		public var controlData:ControlData = new ControlData();
		public var allPanoramasData:AllPanoramasData = new AllPanoramasData();
		public var traceData:TraceData = new TraceData();
		public var brandingData:BrandingData = new BrandingData();
		public var statsData:StatsData = new StatsData();
		
		public var contextMenus:Vector.<ContextMenuData> = new Vector.<ContextMenuData>();
		public var panoramasData:Vector.<PanoramaData> = new Vector.<PanoramaData>();
		public var actionsData:Vector.<ActionData> = new Vector.<ActionData>();
		public var modulesData:Vector.<ModuleData> = new Vector.<ModuleData>();
		public var groupsData:Vector.<Object> =new Vector.<Object>();
		
		public var streetviewData:StreetviewData = new StreetviewData();
		public var isstreetviewModel:Boolean = false;
		
		
		public function getPanoramaDataById(id:String):PanoramaData {
			for each(var panoramaData:PanoramaData in panoramasData) {
				if (panoramaData.id == id) {
					return panoramaData;
				}
			}
			return null;
		}
		
		public function getActionDataById(id:String):ActionData{
			for each(var actionData:ActionData in actionsData) {
				if (actionData.id == id) {
					return actionData;
				}
			}
			return null;
		}
		
		public function getModuleDataByName(name:String):ModuleData{
			for each(var moduleData:ModuleData in modulesData) {
				if (moduleData.name == name) {
					return moduleData;
				}
			}
			return null;
		}
	}
}
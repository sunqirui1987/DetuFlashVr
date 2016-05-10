package com.panozona.modules.imagemap.view
{
	import com.panozona.modules.imagemap.model.ImageMapData;
	import com.panozona.modules.imagemap.model.structure.List;
	import com.panozona.modules.imagemap.model.structure.Map;
	import com.panozona.modules.imagemap.model.structure.Waypoint;
	import com.panozona.modules.imagemap.model.structure.Waypoints;
	import com.panozona.player.module.utils.StringUtil;
	
	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;
	import flash.text.TextFormatAlign;
	
	import morn.core.components.Box;
	import morn.core.components.Button;
	import morn.core.components.ComboBox;
	import morn.core.components.Label;
	import morn.core.components.List;
	import morn.core.components.Panel;
	import morn.core.components.Tab;
	import morn.core.components.View;
	import morn.core.components.ViewStack;
	import morn.core.handlers.Handler;

	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-8-11 下午1:37:35
	 * 功能描述:
	 */
	public class TabView extends View
	{
		private var _imageMapData:ImageMapData;
		private var _managerData:Object;
		public var tab:Tab;
		public var viewStack:ViewStack;
		public var box:Box;
		public var panel:Panel;
		public var list_all:morn.core.components.List;
		public var cmb:ComboBox;
		public var lab_hotName:Label;
		public var btn_close:Button;
		
		public function TabView(imageMapData:ImageMapData,managerData:Object):void{
			_imageMapData = imageMapData;
			_managerData = managerData;
			super();
		}
		
		override protected function createChildren():void {
			super.createChildren();
			createView(imageMapData.tab.uiXML);
			
			var arr:Array = [];
			
			for each(var map:Map in _imageMapData.mapData.maps.getChildrenOfGivenClass(Map)) {
				var object:Object = {
					label1:{
							text:"",
							tag:""
							},
						list1:{
							array:[]
						}
				};
				object.label1.text = _imageMapData.listData.lists.getLableByMapId(map.id);
				object.label1.tag = map.id;
				for each(var waypoints:Waypoints in map.getChildrenOfGivenClass(Waypoints)) {
					for each(var waypoint:Waypoint in waypoints.getChildrenOfGivenClass(Waypoint)) {
						var title:String = _managerData.getPanoramaDataById(waypoint.target).title;
						object.list1.array.push({button1:{
							tag:waypoint,
							label:title,
							toolTip:title,
							clickHandler:new Handler(clickLinkBtn,[waypoint.target])
						}});
						object.list1.renderHandler = new Handler(listButtonsRender)
					}
				}
				arr.push(object);
			}
			
			cmbData = imageMapData.listData.lists.getChildrenOfGivenClass(com.panozona.modules.imagemap.model.structure.List);
			var labels:Array = [];
			for (i= 0, n = cmbData.length; i < n; i++) {
				labels.push(cmbData[i].label);
			}
			cmb.labels = labels.join();
			cmb.selectHandler = new Handler(onCmbSelect);
			
			btn_close.clickHandler = new Handler(hideMap);
			
			tab.selectHandler = viewStack.setIndexHandler;
			
			if(list_all){
				list_all.array = arr;
				list_all.renderHandler = new Handler(listRender); 
				
				list_all.repeatY = list_all.array.length;
				
				
				//			list_all.commitMeasure();
				var _tempY:Number = 0;
				for (var i:int = 0, n:int = list_all.cells.length; i < n; i++) {
					_tempY += (list_all.cells[i].displayHeight+list_all.spaceY);
				}
				list_all.height = _tempY;
				_tempY = 0;
				for (i= 0, n = list_all.cells.length; i < n; i++) {
					list_all.cells[i].y = _tempY;
					_tempY += (list_all.cells[i].displayHeight+list_all.spaceY);
				}
				
				panel.vScrollBar.showButtons = false;
			
			}
			cmb.scrollBar.showButtons = false;
			cmb.scrollBarSkin = "png.comp.vscroll";
		}
		
		private function listButtonsRender(cell:Box, index:int):void {
			var button:Button = cell.getChildByName("button1") as Button;
			button.btnLabel.format.align = TextFormatAlign.LEFT;
			var s:String = button.label;
			var len:int = StringUtil.getStringLen(s);
			var w:Number = len*Number(button.btnLabel.textField.defaultTextFormat.size);
			if(button.btnLabel.textField.textWidth >= button.width){
				var n:int = Math.ceil(len*button.width/button.btnLabel.textField.textWidth);
				button.label =  StringUtil.cutStr(s,n-3)+"...";
			}else{
				button.toolTip = null;
			}
		}
		
		private function hideMap():void
		{
			imageMapData.windowData.open = false;
		}
		
		private var cmbData:Array;
		
		private function onCmbSelect(index:int):void
		{
			var list:com.panozona.modules.imagemap.model.structure.List	= cmbData[index];
			_imageMapData.mapData.currentMapId = list.mapid;
		}
		
		/**按照指定的逻辑渲染List*/
		private function listRender(cell:Box, index:int):void {
			if (index < list_all.length) {
				var list1:morn.core.components.List = cell.getChildByName("list1") as morn.core.components.List;
				var n:int = Math.ceil(list1.array.length/list1.repeatX);
				list1.repeatY = n;
				//				list1.commitMeasure();
				if(index < list_all.length-1){
					var lineSp:Sprite = new Sprite();
					
					lineSp.graphics.moveTo(1,0);
					lineSp.graphics.lineStyle(1,_imageMapData.tab.lineColor);
					lineSp.graphics.lineTo(cell.width-2,0);
					
					lineSp.y = cell.height-lineSp.height+list_all.spaceY/2+2;
					cell.addChild(lineSp);
					
					lineSp.filters = new Array( new DropShadowFilter(1,45,_imageMapData.tab.lineShadowColor,1,1,1,10,1,false,false) );
				}
			}
		}
		
		public function get imageMapData():ImageMapData {
			return _imageMapData;
		}
		
		public function get managerData():Object {
			return _managerData;
		}
		
		/**自定义List项渲染*/
		private function clickLinkBtn(pid:String):void {
			if(clickLinkBtnHandel)
				clickLinkBtnHandel.executeWith([pid]);
		}
		
		public var clickLinkBtnHandel:Handler;
		
		public function set mapId(_mapId:String):void{
			for (i= 0, n = cmbData.length; i < n; i++) {
				if(cmbData[i].mapid == _mapId){
					cmb.selectedIndex = i;
					return;
				}
			}
			if(list_all){
				for(var i:int=0,n:int=list_all.content.numChildren;i<n;i++){
					var box:Box = list_all.content.getChildAt(i) as Box;
					var label1:Label = box.getChildByName("label1") as Label;
					if(label1 && label1.tag && label1.tag == _mapId){
						var y:Number = box.y;
						panel.scrollTo(0,y);
						break;
					}
				}
			}
			
		}
		
		
		
		public function set panoLabel(_panoLabel:String):void{
			lab_hotName.text = _panoLabel;
		}
		
		private var unSelectColor:String;
		
		public function set selectPanoId(_panoId:String):void{
			if(!list_all)
				return;
			for(var i:int=0,n:int=list_all.content.numChildren;i<n;i++){
				var box:Box = list_all.content.getChildAt(i) as Box;
				var list_1:morn.core.components.List = box.getChildByName("list1") as morn.core.components.List;
				if(list_1){
					for(var j:int=0,k:int=list_1.content.numChildren;j<k;j++){
						var box2:Box = list_1.content.getChildAt(j) as Box;
						var cell:Button = box2.getChildByName("button1") as Button;
						if(cell){
							if(!unSelectColor)
								unSelectColor = cell.labelColors;
							if(cell.tag && cell.tag.target == _panoId){
								cell.btnLabel.backgroundColor = 0x3d454a;//;0x8f919f
								cell.btnLabel.background = true;
								cell.labelColors="0xffffff,0xffffff,0xffffff,0xffffff";
							}else{
								cell.btnLabel.color = unSelectColor;
								cell.btnLabel.background = false;
								cell.labelColors=unSelectColor;
							}
							cell.commitMeasure();
						}
					}
				}
			}
		}
	}
}
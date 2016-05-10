/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.imagebutton{
	
	import com.panozona.modules.imagebutton.controller.GroupButtonController;
	import com.panozona.modules.imagebutton.controller.WindowController;
	import com.panozona.modules.imagebutton.model.GroupButtonData;
	import com.panozona.modules.imagebutton.model.ImageButtonData;
	import com.panozona.modules.imagebutton.model.WindowData;
	import com.panozona.modules.imagebutton.model.structure.GroupButton;
	import com.panozona.modules.imagebutton.view.GroupButtonView;
	import com.panozona.modules.imagebutton.view.SubButtonView;
	import com.panozona.modules.imagebutton.view.WindowView;
	import com.panozona.player.module.Module;
	import com.panozona.player.module.data.ModuleData;
	
	public class ImageButton extends Module{
		
		public var imageButtonData:ImageButtonData;
		public var windowControllers:Vector.<WindowController>;
		
		public var groupButtonControllers:Vector.<GroupButtonController>;
		
		public function ImageButton(){
			super("ImageButton", "1.3", "http://ouwei.cn/wiki/Module:ImageButton");
			moduleDescription.addFunctionDescription("setOpen", String, Boolean);
			moduleDescription.addFunctionDescription("toggleOpen", String);
			moduleDescription.addFunctionDescription("setActive", String, Boolean);
			
			//当前场景无效
			this.mouseEnabled = false;
		
		}
		
		override protected function moduleReady(moduleData:ModuleData):void{
			
			imageButtonData = new ImageButtonData(moduleData, qjPlayer);
			windowControllers = new Vector.<WindowController>();
			
			var windowView:WindowView;
			var windowController:WindowController;
			for (var i:int = imageButtonData.buttons.length - 1; i >= 0; i--){
				windowView = new WindowView(new WindowData(imageButtonData.buttons[i],imageButtonData.styles));
				addChild(windowView);
				windowController = new WindowController(windowView, this);
				windowControllers.push(windowController);
			}
			
			groupButtonControllers = new Vector.<GroupButtonController>();
			
			for (i= imageButtonData.groupButtons.length - 1; i >= 0; i--){
				var groupButtonView:GroupButtonView = new GroupButtonView(new GroupButtonData(imageButtonData.groupButtons[i] as GroupButton),imageButtonData);
				addChild(groupButtonView);
				var groupButtonController:GroupButtonController = new GroupButtonController(groupButtonView,this);
				groupButtonControllers.push(groupButtonController);
			}
		}
		
///////////////////////////////////////////////////////////////////////////////
//  Exposed functions 
///////////////////////////////////////////////////////////////////////////////
		
		public function setOpen(buttonId:String, value:Boolean):void{
			for (var i:int = 0; i < numChildren; i++) {
				var temp:* = getChildAt(i);
				if(temp is WindowView){
					if (( temp as WindowView).windowData.button.id == buttonId){
						( temp as WindowView).windowData.open = value;
						return;
					}
				}else if(temp is GroupButtonView){
					if (( temp as GroupButtonView).groupButtonData.groupButton.id == buttonId){
						( temp as GroupButtonView).groupButtonData.open = value;
						return;
					}
				}
			}
			printWarning("Nonexistant button id: " + buttonId);
		}
		
		public function toggleOpen(buttonId:String):void {
			for (var i:int = 0; i < numChildren; i++) {
				var temp:* = getChildAt(i);
				if(temp is WindowView){
					if ((temp as WindowView).windowData.button.id == buttonId){
						(temp as WindowView).windowData.open = !(temp as WindowView).windowData.open;
						return;
					}
				}else if(temp is GroupButtonView){
					if (( temp as GroupButtonView).groupButtonData.groupButton.id == buttonId){
						( temp as GroupButtonView).groupButtonData.open = !(temp as GroupButtonView).groupButtonData.open;
						return;
					}
				}
			}
			printWarning("Nonexistant button id: " + buttonId);
		}
		
		public function setActive(subButtonId:String, value:Boolean):void {
			for (var i:int = 0; i < numChildren; i++) {
				var temp:* = getChildAt(i);
				if(temp is WindowView){
					for (var j:int = 0; j < (temp as WindowView).buttonView.subButtonsContainer.numChildren; j++) {
						if (((temp as WindowView).buttonView.subButtonsContainer.getChildAt(j) as SubButtonView).subButtonData.subButton.id == subButtonId) {
							((temp as WindowView).buttonView.subButtonsContainer.getChildAt(j) as SubButtonView).subButtonData.isActive = value;
							return;
						}
					}
				}else if(temp is GroupButtonView){
					for (var p:int = 0; p< (temp as GroupButtonView).numChildren; p++){
						var temp2:WindowView = temp.getChildAt(p);
						for (j = 0; j < (temp2 as WindowView).buttonView.subButtonsContainer.numChildren; j++) {
							if ((temp2.buttonView.subButtonsContainer.getChildAt(j) as SubButtonView).subButtonData.subButton.id == subButtonId) {
								(temp2.buttonView.subButtonsContainer.getChildAt(j) as SubButtonView).subButtonData.isActive = value;
								return;
							}
						}
					}
				}
			}
			printWarning("Nonexistant subButton id: " + subButtonId);
		}
		
		public function getButtonById(buttonId:String): WindowView{
			for (var i:int = 0; i < numChildren; i++) {
				var temp:* = getChildAt(i);
				if(temp is WindowView){
					if ((temp as WindowView).windowData.button.id == buttonId){
						return temp;
					}
				}else if(temp is GroupButtonView){
					if (( temp as GroupButtonView).groupButtonData.groupButton.id == buttonId){
						return temp;
					}
				}
			}
			return null;
		}
	
	}
}
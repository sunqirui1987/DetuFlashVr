package com.panozona.player.manager.data.streetview
{
	
	import com.panosalado.events.ViewEvent;
	import com.panozona.player.QjPlayer;
	import com.panozona.player.manager.StreetManager;
	
	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	public class StreeviewBranding extends Sprite{
		
		
		

		
		private var brandingButton:Sprite;
		private var fullscreenButton:Sprite;
		
		private var _streetmanager:StreetManager;
		
		[Embed(source="assert/fullscreen.png")]
		private var _fullscreen_class:Class;
		
		private var  textField:TextField ;
		
		
		
		public function StreeviewBranding(streetmanager:StreetManager)
		{
			_streetmanager = streetmanager;
			
			stageReady();
		}
		
		public function set  powerby(value:String):void
		{
			textField.text = value;
		}
		
		
		private function stageReady():void {


			var menu:ContextMenu = new ContextMenu();
			var item:ContextMenuItem = new ContextMenuItem("技术提供：得图云(www.detuyun.com)");
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, gotoPanoZona, false, 0, true);
			menu.customItems.push(item);
			_streetmanager.contextMenu = menu;
			
			_streetmanager.contextMenu.hideBuiltInItems();
			
			brandingButton = new Sprite();
			brandingButton.alpha = 1;
			brandingButton.buttonMode = true;
	
			var textFormat:TextFormat = new TextFormat();
			textFormat.font = "微软雅黑";
			textFormat.size = 12;
			textFormat.color = 0xFFFFFF;
			textFormat.bold = true;
			
			textField= new TextField();
			textField.alpha = 1;
			textField.defaultTextFormat = textFormat;
			textField.multiline = false;
			textField.selectable = false;
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.blendMode = BlendMode.LAYER;
			textField.background = false;
			textField.antiAliasType = AntiAliasType.ADVANCED;
			textField.mouseEnabled=false;
			textField.text = "";
			var gf:GlowFilter = new GlowFilter(0x000000,0.8);
			textField.filters = new Array(gf);
			brandingButton.addChild(textField);
			brandingButton.addEventListener(MouseEvent.CLICK, gotoPanoZona, false, 0, true);
			addChild(brandingButton);
			
			
			fullscreenButton = new Sprite();
			fullscreenButton.alpha = 1;
			fullscreenButton.buttonMode = true;
			fullscreenButton.addChild(new Bitmap(new _fullscreen_class().bitmapData));
			fullscreenButton.buttonMode = true;
			fullscreenButton.addEventListener(MouseEvent.CLICK, fullscreenHanlder, false, 0, true);
			addChild(fullscreenButton);
			
		
			_streetmanager.addEventListener(ViewEvent.BOUNDS_CHANGED, handleResize ,false, 0, true);
			handleResize();
			
		}
		private function fullscreenHanlder(e:MouseEvent):void
		{
			stage.displayState = (stage.displayState == StageDisplayState.NORMAL) ?
				StageDisplayState.FULL_SCREEN :
				StageDisplayState.NORMAL;
		}
		private function handleResize(e:Event = null):void {
			brandingButton.x = 5;
			brandingButton.y =_streetmanager.boundsHeight- brandingButton.height - 5;
			
			
			fullscreenButton.x = _streetmanager.boundsWidth- fullscreenButton.width - 5;
			fullscreenButton.y = 5;
		}
		
		private function gotoPanoZona(e:Event):void {
			try {
				navigateToURL(new URLRequest("http://www.detuyun.com/"), '_BLANK');
			} catch (error:Error) {
				
			}
		}
		
		
	}
}

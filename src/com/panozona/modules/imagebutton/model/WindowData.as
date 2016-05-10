/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.imagebutton.model {
	
	import com.panozona.modules.imagebutton.events.WindowEvent;
	import com.panozona.modules.imagebutton.model.structure.Button;
	import com.panozona.modules.imagebutton.model.structure.Styles;
	import com.panozona.modules.imagebutton.model.structure.Window;
	import com.panozona.modules.imagebutton.model.structure.Style;
	import com.panozona.modules.imagebutton.model.structure.StyleContent;
	import com.panozona.player.module.data.property.Size;
	
	import flash.events.EventDispatcher;
	
	public class WindowData extends EventDispatcher{
		
		private var _open:Boolean;
		private var _size:Size;
		
		private var _button:Button;
		
		public var styleContent:StyleContent;
		
		public function WindowData (button:Button,styles:Styles):void {
			_size = new Size(1, 1);
			_button = button;
			_open = _button.window.open;
			if (_button.style != null){
				for each(var style:Style in styles.getChildrenOfGivenClass(Style)){
					if (style.id == _button.style) {
						styleContent = style.content;
					}
				}
			}else{
				styleContent = new StyleContent();
			}
		}
		
		public function get open():Boolean{return _open}
		public function set open(value:Boolean):void {
			if (value == _open) return;
			_open = value;
			dispatchEvent(new WindowEvent(WindowEvent.CHANGED_OPEN));
		}
		
		public function get size():Size { return _size;}
		public function set size(value:Size):void {
			if (value.width > _size.width) {
				_size.width = value.width;
			}
			if (value.height > _size.height) {
				_size.height = value.height;
			}
			dispatchEvent(new WindowEvent(WindowEvent.CHANGED_SIZE));
		}
		
		public function get button():Button { return _button; }
		public function get window():Window { return _button.window; }
	}
}
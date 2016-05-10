package com.panozona.modules.guestBook.view.component
{
	
	import com.panozona.modules.guestBook.events.PageEvent;
	import com.panozona.modules.guestBook.utils.SwfLoader;
	
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class PageIndex extends Sprite
	{
		
		private var _curPage:int;
		
		private var _totalPage:int;
		
		public var Text_PageNam:TextField;
		
		public var Btn_PgUp:SimpleButton;
		
		public var Btn_PgOn:SimpleButton;
		
		private var mc:*;
		
		public function PageIndex(url:String,curPage:int,totalPage:int)
		{
			super();
		
			SwfLoader.load(url,init);
			
			this.curPage = curPage;
			this.totalPage = totalPage;
			
//			txt_page = getChildByName("Text_PageNam") as TextField;
//			if(txt_page)
//				txt_page.text = _curPage+'/'+_totalPage;
//			
//			btn_pre = getChildByName("Btn_PgUp") as SimpleButton;
//			if(btn_pre)
//				btn_pre.addEventListener(MouseEvent.CLICK,changePage);
//			
//			
//			btn_next = getChildByName("Btn_PgOn") as SimpleButton;
//			if(btn_next)
//				btn_next.addEventListener(MouseEvent.CLICK,changePage);
			
			
			
		}
		
		private function init(info:LoaderInfo):void{
			var Class:Object = info.applicationDomain.getDefinition("PageClass");
			mc = new Class();
			addChild(mc);
			
			Text_PageNam = mc.getChildByName("Text_PageNam") as TextField;
			Btn_PgUp = mc.getChildByName("Btn_PgUp") as SimpleButton;
			Btn_PgOn = mc.getChildByName("Btn_PgOn") as SimpleButton;
			
			if(Text_PageNam)
				Text_PageNam.text = _curPage+'/'+_totalPage;
			
			if(Btn_PgUp)
				Btn_PgUp.addEventListener(MouseEvent.CLICK,changePage);
			
			
			if(Btn_PgOn)
				Btn_PgOn.addEventListener(MouseEvent.CLICK,changePage);
		}
		
		protected function changePage(event:MouseEvent):void
		{
			var page:int = _curPage;
			if(event.target  == Btn_PgUp){
				page--;
			}else{
				page++;
			}
			if(page<1 || page>_totalPage)
				return;
			curPage = page;
			var e:PageEvent = new PageEvent(PageEvent.PAGE_CHANGE);
			e.curPage = page;
			dispatchEvent(e);
		}
		
		public function get curPage():int{
			return _curPage;
		}
		
		public function set curPage(_curPage:int):void{
			this._curPage = _curPage;
			if(Text_PageNam)
				Text_PageNam.text = _curPage+'/'+_totalPage;
		}
		
		public function get totalPage():int{
			return _totalPage;
		}
		
		public function set totalPage(_totalPage:int):void{
			this._totalPage = _totalPage;
			if(Text_PageNam)
				Text_PageNam.text = _curPage+'/'+_totalPage;
		}
		
		
		
	}
}
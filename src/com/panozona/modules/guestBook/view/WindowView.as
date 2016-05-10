/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.guestBook.view{
	
	import com.panozona.modules.guestBook.model.GuestBookData;
	import com.panozona.modules.guestBook.model.WindowData;
	import com.panozona.modules.guestBook.model.structure.Message;
	import com.panozona.modules.guestBook.utils.SwfLoader;
	import com.panozona.modules.guestBook.utils.Time;
	
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.system.IME;
	import flash.text.TextField;
	
	public class WindowView extends Sprite{
		
		private var guestBookData:GuestBookData;
		
		/**
		 * 关闭窗口按钮 
		 */		
		private var btn_close:SimpleButton;
		
		/**
		 * 提交按钮 
		 */		
		private var btn_commit:SimpleButton;
		
		/**
		 * 总条数 
		 */		
		private var txt_totalNum:TextField;
		
		/**
		 * 总页数 
		 */		
		private var txt_page:TextField;
		
		/**
		 * 姓名输入框
		 */		
		private var txtInput_name:TextField;
		
		/**
		 * 内容输入框
		 */		
		private var txtInput_content:TextField;
		
		
		
		/**
		 * 前一页按钮
		 */		
		private var btn_prePage:SimpleButton;
		
		/**
		 * 下一页按钮
		 */		
		private var btn_nextPage:SimpleButton;
		
		/**
		 * 总界面
		 */		
		private var mainMc:MovieClip;
		
		/**
		 * 渲染器的皮肤类 
		 */		
		private var itemRenderClass:Object;
		
		/**
		 * 一页显示的条数 
		 */		
		private var onePageSize:int = 10;
		
		/**
		 * 当前页数
		 */		
		private var curPage:int = 1;
		
		/**
		 * 总页数 
		 */		
		private var totalPage:int = 0;
		
		/**
		 * 滚动面板
		 */		
		private var scrollPane:*;
		private var tempSp:Sprite=new Sprite();
		
		public function WindowView(guestBookData:GuestBookData) {
			
			this.guestBookData  = guestBookData;
			
			onePageSize = guestBookData.skin.list.onePageSize;
			
			SwfLoader.load(guestBookData.skin.path,buildSkin);
		}
		
		public function get windowData():WindowData{
			return this.guestBookData.windowData;
		}
		
		/**
		 * 创建皮肤 
		 * @param loaderInfo
		 * 
		 */		
		private function buildSkin(loaderInfo:LoaderInfo):void{
			mainMc = loaderInfo.content as MovieClip;
			addChild(mainMc);
			
			btn_close = mainMc.getChildByName("btn_close") as SimpleButton;
			btn_close.addEventListener(MouseEvent.CLICK,closeWnd);
			
			btn_commit = mainMc.getChildByName("btn_commit") as SimpleButton;
			btn_commit.addEventListener(MouseEvent.CLICK,commitMessage);
			
			btn_prePage = mainMc.getChildByName("btn_prePage") as SimpleButton;
			btn_prePage.addEventListener(MouseEvent.CLICK,turnPage);
			
			btn_nextPage = mainMc.getChildByName("btn_nextPage") as SimpleButton;
			btn_nextPage.addEventListener(MouseEvent.CLICK,turnPage);
			
			txt_totalNum = mainMc.getChildByName("txt_totalNum") as TextField;
			txt_page = mainMc.getChildByName("txt_page") as TextField;
			txtInput_name = mainMc.getChildByName("txtInput_name") as TextField;
			txtInput_content = mainMc.getChildByName("txtInput_content") as TextField;
			
			txtInput_name.addEventListener( FocusEvent.FOCUS_IN,onFocusIn);
			txtInput_content.addEventListener( FocusEvent.FOCUS_IN,onFocusIn);
			
			itemRenderClass = loaderInfo.applicationDomain.getDefinition("ItemRenderCls");
			
			scrollPane = mainMc.getChildByName("scrollPane");
			scrollPane.setSize(guestBookData.skin.list.width,guestBookData.skin.list.height);
			scrollPane.source=tempSp;
			scrollPane.verticalScrollPolicy = guestBookData.skin.list.verticalScrollPolicy;
			scrollPane.horizontalScrollPolicy = "off";
			
			buildList();
		}
		
		/**
		 *  
		 * @param event
		 * 
		 */		
		protected function onFocusIn(event:FocusEvent):void
		{
			IME.enabled = true;
		}
		
		/**
		 * 创建列表 
		 * 
		 */		
		public function buildList():void
		{
			clearItems();
			var messages:Array = guestBookData.messagesData.messages.getAllChildren();
			var len:int = messages.length;
			totalPage = len%onePageSize == 0?len/onePageSize:((len/onePageSize)+1);
			
			txt_page.text = curPage+"/"+totalPage;
			txt_totalNum.text = "共"+len+"条留言";
			
			messages = messages.slice((curPage-1)*onePageSize,curPage*onePageSize);
			
			
			if(!messages || messages.length == 0)
				return;
			for(var i:int=0;i<messages.length;i++){
				var itemRenderView:ItemRenderView = new ItemRenderView(itemRenderClass,messages[i]);
				itemRenderView.y = (itemRenderView.height+10) * i;
				tempSp.addChild(itemRenderView);
				itemViewsArr.push(itemRenderView);
			}
			scrollPane.update();
		}
		
		/**
		 *临时数组，存放列表中的对象 
		 */		
		private var itemViewsArr:Array = [];
		/**
		 * 清空列表 
		 * 
		 */		
		private  function clearItems():void{
			for(var i:int=0;i<itemViewsArr.length;i++){
				var itemRenderView:ItemRenderView = itemViewsArr[i] as ItemRenderView;
				itemRenderView.destroy();
				if(tempSp.contains(itemRenderView)){
					tempSp.removeChild(itemRenderView);
					itemViewsArr.splice(i,1);
					i--;
				}
			}
		}
		
		/**
		 * 换页 
		 * @param event
		 * 
		 */		
		protected function turnPage(event:MouseEvent):void
		{
			if(event.target == btn_nextPage){
				if(curPage >= totalPage)
					return;
				curPage ++;
				buildList();
			}else{
				if(curPage <= 1)
					return;
				curPage --;
				buildList();
			}
		}
		
		/**
		 *  提交留言
		 * @param event
		 * 
		 */		
		protected function commitMessage(event:MouseEvent):void
		{
			var message:Message = new Message();	
			message.name = txtInput_name.text;
			message.content = txtInput_content.text;
			message.date = Time.getFullDateAndTimeString(new Date(),"YYYY-MM-DD hh.mm.ss");
			if(message.name && message.content){
				txtInput_name.text = "";
				txtInput_content.text = "";
				this.guestBookData.messagesData.addNewMessage(message);
			}
		}
		
		/**
		 * 关闭窗口 
		 * @param event
		 * 
		 */		
		protected function closeWnd(event:MouseEvent):void
		{
			this.guestBookData.windowData.open = false;
		}
		
	}
}
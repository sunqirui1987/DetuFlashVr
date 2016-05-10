package LLGGgame.display.assist
{
	import LLGGgame.data.GameConfig;
	import LLGGgame.display.uiDemo.GameBtnsLayView;
	import LLGGgame.display.uiDemo.GetGameData;
	import LLGGgame.display.uiDemo.base.BaseWnd;
	import LLGGgame.display.uiDemo.base.WindowManager;
	import LLGGgame.display.uiDemo.task.NpcTalk;
	import LLGGgame.display.uiDemo.task.Task;
	import LLGGgame.event.DataPassEvent;
	import LLGGgame.event.WindowEvent;
	
	import com.stroy.event.ZEventDispatcher;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class GuideManager
	{
		
		private  static var instance:GuideManager;
		
		public static function getInstance():GuideManager{
			if(!instance)
				instance = new GuideManager();
			return instance;
		}
		
		public function GuideManager()
		{
			ZEventDispatcher.getInstance().addEventListener(DataPassEvent.REFRESHTASKDATA,getTaskRep);
			ZEventDispatcher.getInstance().addEventListener(WindowEvent.WND_ON_OPEN,onWndOpen);
			ZEventDispatcher.getInstance().addEventListener(WindowEvent.WND_ON_CLOSE,onWndClose);
		}
		
		private var curTask:Object;
		
		private var curGuideId:int;
		
		private var guideData:*;
		
		private var kuang:Sprite;
		
		private function drawKuang():void{
			var Area:Array = String(guideData.@Area).split(',');
			if(!kuang)
				kuang = new Sprite;
			kuang.graphics.clear();
			kuang.graphics.lineStyle(1,1);
			kuang.graphics.moveTo(Area[0],Area[1]);
			kuang.graphics.lineTo(Area[2],Area[1]);
			kuang.graphics.lineTo(Area[2],Area[3]);
			kuang.graphics.lineTo(Area[0],Area[3]);
			kuang.graphics.lineTo(Area[0],Area[1]);
		}
		
		protected function getTaskRep(event:Event):void
		{
			guideData = null;
			clear();
			curTask = GetGameData.getMainTask();
			if(curTask ==null){
				return;
			}
			curGuideId = GameConfig.m_guideTask.element.(@TaskId == curTask.TI).(@TaskStatus == curTask.TS).@GuideId;
			
			if(curGuideId == 0){
				return;
			}
			guideData = GameConfig.m_guide.element.(@GuideId == curGuideId);
			showView();
		}
		
		private function showView():void{
			clear();
			if(!guideData)
				return;
			var wid:int = guideData.@WinId;
			var Px:Number = guideData.@Px;
			var Py:Number = guideData.@Py;
			var Area:Array = String(guideData.@Area).split(',');
			var Direction:int = guideData.@Direction;
			var NextGuideId:int = guideData.@NextGuideId;
			var desc:String = guideData.@desc;
			var isClickDisappear:int = int(guideData.@isClickDisappear);
			
			var wnd:BaseWnd = WindowManager.getInstance().findWnd(wid);
			if(wnd){
				view.setData(wnd,desc,Direction,Px,Py);
				view.isShow = true;
				
				if(isClickDisappear == 1 && wnd){
					wnd.addEventListener(MouseEvent.CLICK,onClickWnd);
				}
				
				drawKuang();
				wnd.addChild(kuang);
			}
		}
		
		protected function onWndOpen(event:WindowEvent):void
		{
			if(!guideData)
				return;
			if(event.wndId == guideData.@WinId)
				showView();
		}
		
		protected function onWndClose(event:WindowEvent):void
		{
			if(!guideData)
				return;
			if(event.wndId == guideData.@WinId){
				getTaskRep(null);
			}
		}
		
		
		public function init():void{
			view = new GuideView();
		}
		
		public var view:GuideView;
		
		public function clear():void{
			if(view){
				if(view.parent){
					if(view.parent.hasEventListener(MouseEvent.CLICK))
						view.parent.removeEventListener(MouseEvent.CLICK,onClickWnd);
					if(kuang && view.parent.contains(kuang))
						view.parent.removeChild(kuang);
					view.parent.removeChild(view);
				}
				view.isShow = false;
			}
		}
		
		private function onClickWnd(e:MouseEvent):void
		{
			// TODO Auto Generated method stub
			
			if(!guideData)
				return;
			var wnd:BaseWnd = WindowManager.getInstance().findWnd(guideData.@WinId);
			if(!wnd)
				return;
			var Area:Array = String(guideData.@Area).split(',');
			var tx:Number = e.stageX-wnd.x;
			var ty:Number = e.stageY-wnd.y;
			
			if(tx<Area[0] || ty<Area[1] || tx>Area[2] || ty>Area[3])
				return;
			clear();
			var NextGuideId:int = guideData.@NextGuideId;
			if(NextGuideId != 0){
				guideData = GameConfig.m_guide.element.(@GuideId == NextGuideId);
				showView();
			}else{
				var isClickDisappear:int = int(guideData.@isClickDisappear);
				if(isClickDisappear == 1)
					guideData = null;
			}
		}
		
		public function set isShow(_isShow:Boolean):void{
			if(view && view.parent && (view.parent is Task || view.parent is NpcTalk || view.parent is GameBtnsLayView)){
				view.isShow = _isShow;
			}
		}
	}
}
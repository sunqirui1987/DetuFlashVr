package
{
	import com.baiduMap.component.DropDownNavigateView;
	import com.baiduMap.events.BaiduMapEvent;
	import com.baiduMap.overLay.MyMarker;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import baidu.map.basetype.LngLat;
	import baidu.map.basetype.Size;
	import baidu.map.control.base.Overview;
	import baidu.map.core.Map;
	import baidu.map.event.MapEvent;
	import baidu.map.layer.Layer;
	import baidu.map.layer.RasterLayer;
	import baidu.map.layer.SateLayer;
	import baidu.map.overlay.Marker;
	
	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-3-11 下午4:17:34
	 * 功能描述:
	 */
	public class BaiduMap extends Sprite
	{
		private var w:int;
		private var h:int;
		
		private var map:Map;
		
		[Embed(source="handOpen.png")]
		private var handOpenCls:Class;
		
		[Embed(source="handClose.png")]
		private var handCloseCls:Class;
		
		public function BaiduMap(w:int=500,h:int=400,type:int=1)
		{
			this.w = w;
			this.h = h;
			this._type = type;
			
			graphics.beginFill(1,0);
			graphics.drawRect(0,0,w,h);
			graphics.endFill();
			
			if(stage){
				init();
			}else{
				addEventListener(Event.ADDED_TO_STAGE,onAddToStage);
			}
		}
		
		private function selectFun(obj:Object):void{
			if(obj.type == _type)
				return;
			setLayerType(obj.type);
		}
		
		protected function onAddToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE,onAddToStage);
			init();
		}
		
		private function init():void{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			// 创建一个大小为600*400的Map对象
			map = new Map(new Size(w, h));
			addChild(map);
			// 初始化Map的中心点和显示级别
			map.centerAndZoom(new LngLat(116.404, 39.915), 12);
			
			setLayerType(_type);
			
			//			// 添加Navigator
			//			var nav:Navigator = new Navigator(map);
			//			map.addControl(nav);
			// 添加Overview			
			var overview:Overview = new Overview(map);
			map.addControl(overview);
			//			// 添加Scaler			
			//			var scaler:Scaler = new Scaler(map);
			//			map.addControl(scaler);
			//			// 添加Ruler			
			//			var ruler:Ruler = new Ruler(map);
			//			map.addControl(ruler);
			
			map.draggingCursor = new handCloseCls();
			map.defaultCursor = new handOpenCls();
			
	//		initData([{id:"a1",lng:116.424,lat:39.915},{id:"a2",lng:116.424,lat:39.915}],"a1");
			
			var arr:Array = [{type:1,label:"普通地图"},{type:2,label:"卫星地图"}];
			var box:DropDownNavigateView = new DropDownNavigateView(arr,selectFun);
			addChild(box);
		}
		
		public function drawWatchArea(startAngle:Number,endAngle:Number,divisions:Number,span:Number,rotationZ:Number):void{
			var marker:MyMarker = getSelectMark();
			if(marker)
				marker.drawCurrentIcon(startAngle,endAngle,divisions,span,rotationZ);
		}
		
		private var markList:Array = [];
		public function getMarkById(id:String):MyMarker{
			for(var i:int=0;i<markList.length;i++){
				var marker:MyMarker = markList[i] as MyMarker;
				if(marker && marker.data.id == id)
					return marker;
			}
			return null;
		}
		
		public function getSelectMark():MyMarker{
			for(var i:int=0;i<markList.length;i++){
				var marker:MyMarker = markList[i] as MyMarker;
				if(marker && marker.isCurrent )
					return marker;
			}
			return null;
		}
		
		public function setSelect(selectId:String):void{
			for(var i:int=0;i<markList.length;i++){
				var marker:MyMarker = markList[i] as MyMarker;
				if(marker && marker.data.id == selectId){
					marker.isCurrent = true;
					map.panTo(marker.position);	
				}else{
					marker.isCurrent = false;
				}
			}
		}
		
		public function initData(arr:Array,selectId:String):void{
			for(var i:int=0;i<arr.length;i++){
				var marker:MyMarker = new MyMarker(arr[i]);
				marker.addEventListener(MouseEvent.CLICK,onClick);
				map.addOverlay(marker);
				markList.push(marker);
			}
			setSelect(selectId);
		}
		
		protected function onClick(event:MouseEvent):void
		{
			var marker:MyMarker = event.target as MyMarker;
			if(marker){
				map.panTo(marker.position);	
				var mapEvent:BaiduMapEvent = new BaiduMapEvent(BaiduMapEvent.CLICK_BAIDU_MAP_MARK);
				mapEvent.clickMarkId = marker.data.id;
				dispatchEvent(mapEvent);
			}
		}
		
		private var _type:int=-1;
		public function setLayerType(type:int=1):void{
			if(map.baseLayer)
				map.removeLayer(map.baseLayer);
			var layer:Layer;
			if(type == 1){
				_type = 1;
				layer =  new RasterLayer("BaiduMap", map);
			}else{
				_type = 2;
				layer =  new SateLayer("BaiduMap", map);
			}
			map.addLayer(layer);
		}
	}
}
package com.panozona.player.manager.data.panoramas
{
	import com.panosalado.view.ManagedChild;
	import com.panozona.player.manager.Manager;
	import com.panozona.player.manager.utils.ImageCutter;
	import com.panozona.player.manager.utils.loading.ILoadable;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.getTimer;
	
	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-4-21 上午10:35:55
	 * 功能描述:
	 */
	public class HotspotBitmapAnimation extends HotspotData implements ILoadable
	{
		public var row:int;
		public var column:int;
		public var s_path:String;
		public var interval:int;
		
		private var container:ManagedChild;
		private var manager:Manager;
		
		private var bmdArr:Array;
		
		private var bmp:Bitmap;
		
		private var index:int = -1;
		private var len:int = 0;
		
		public function HotspotBitmapAnimation(id:String,row:int,column:int,path:String,interval:int)
		{
			super(id);
			this.row = row;
			this.column = column;
			this.s_path = path;
			this.interval = interval;
		}
		
		public function get path():String
		{
			return "animation__innerDisplayObj";
		}
		
		public function render(_extraobj:Object):ManagedChild
		{
			
			
			manager = _extraobj as Manager;
			container = new ManagedChild();
			container.name = "hotspotAnimation";
			
			
			//增加事件
			manager.addHotspotEvent(container,this);
			container.x = 0;
			container.y = 0;
			container.z = 500;
			manager.addChild(container);
			
			var matrix3D:Matrix3D = new Matrix3D();
			matrix3D.appendScale(transform.scaleX, transform.scaleY, transform.scaleZ);
			//是否是新的热点模式
			if(!transform.flat && isnew == false){
				matrix3D.appendRotation(location.tilt, Vector3D.X_AXIS);
				matrix3D.appendRotation(location.pan, Vector3D.Y_AXIS);
			}else {
				container.flat = true;
			}
			/*
			
			* 球面坐标系转直角坐标系
			* @param {Number} a 仰角  pr
			* @param {Number} b 转角  tr
			* @param {Number} r 半径  distance
			
			*/
			var piOver180:Number = Math.PI / 180;
			var pr:Number = -1 * (location.pan - 90) * piOver180;
			var tr:Number = -1 * location.tilt * piOver180;
			var xc:Number = location.distance * Math.cos(pr) * Math.cos(tr);
			var yc:Number = location.distance * Math.sin(tr);
			var zc:Number = location.distance * Math.sin(pr) * Math.cos(tr);
			matrix3D.appendTranslation(xc, yc, zc); 
			matrix3D.prependRotation(transform.rotationX, Vector3D.X_AXIS);
			matrix3D.prependRotation(transform.rotationY, Vector3D.Y_AXIS);
			matrix3D.prependRotation(transform.rotationZ, Vector3D.Z_AXIS);
			
			var decomposition:Vector.<Vector3D> = matrix3D.decompose();
			container.x = decomposition[0].x;
			container.y = decomposition[0].y;
			container.z = decomposition[0].z;
			container.rotationX = decomposition[1].x;
			container.rotationY = decomposition[1].y;
			container.rotationZ = decomposition[1].z;
			container.scaleX = decomposition[2].x;
			container.scaleY = decomposition[2].y;
			container.scaleZ = decomposition[2].z;
			
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, imageLost);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoaded);
			loader.load(new URLRequest(this.s_path),new flash.system.LoaderContext(true));
			
			return null;
			
		}
		
		public function imageLost(e:IOErrorEvent):void {
			(e.target as LoaderInfo).removeEventListener(IOErrorEvent.IO_ERROR, imageLost);
			(e.target as LoaderInfo).removeEventListener(Event.COMPLETE, imageLoaded);
			manager.print(e.toString());
		}
		
		public function imageLoaded(e:Event):void {
			(e.target as LoaderInfo).removeEventListener(IOErrorEvent.IO_ERROR, imageLost);
			(e.target as LoaderInfo).removeEventListener(Event.COMPLETE, imageLoaded);
			bmdArr = ImageCutter.cut(e.target.content.bitmapData,column,row);
			bmp = new Bitmap();
			container.addChild(bmp);
			len = bmdArr.length;
			manager.addEventListener(Event.ENTER_FRAME,onRender);
		}
		
		private var t:Number;
		
		protected function onRender(event:Event):void
		{
			if(interval > 0){
				if(getTimer()-t<interval)
					return;
				t = getTimer();
			}
			index++;
			if(index >= len){
				index = 0;
			}
			bmp.bitmapData = bmdArr[index];
		}
		
	}
}
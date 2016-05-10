/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.imagemap.controller {
	
	import caurina.transitions.Tweener;
	
	import com.panozona.modules.imagemap.events.WaypointEvent;
	import com.panozona.modules.imagemap.view.WaypointView;
	import com.panozona.player.module.Module;
	
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.system.ApplicationDomain;
	
	public class WaypointController {
		
		private var _waypointView:WaypointView;
		private var _module:Module;
		
		private var _pan:Number;
		private var _tilt:Number;
		private var _fov:Number;
		
		private var _isFocused:Boolean;
		
		private var pan1:Number;
		private var pan2:Number;
		private var pan3:Number;
		
		private var currentDirection:Number;
		
		public function WaypointController(waypointView:WaypointView, module:Module) {
			_waypointView = waypointView;
			_module = module;
			
			var autorotationEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panosalado.events.AutorotationEvent") as Class;
			_module.qjPlayer.managerData.controlData.autorotationCameraData.addEventListener(autorotationEventClass.AUTOROTATION_CHANGE, onIsAutorotatingChange, false, 0, true);
			
			_waypointView.waypointData.addEventListener(WaypointEvent.CHANGED_SHOW_RADAR, handleShowRadarChange, false, 0, true);
			_waypointView.waypointData.addEventListener(WaypointEvent.CHANGED_MOUSE_OVER, handleMouseOverChange, false, 0, true);
			
			_waypointView.addEventListener(MouseEvent.CLICK, handleMouseClick, false, 0, true);
			
			var panoramaEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.events.PanoramaEvent") as Class;
			_module.qjPlayer.manager.addEventListener(panoramaEventClass.PANORAMA_LOADED, onPanoramaLoaded, false, 0, true);
			
			if(_module.qjPlayer.manager.currentPanoramaData != null){
				onPanoramaLoaded(); // in case when map just got changed
			}
			
			drawButton();
		}
		
		public function lostFocus():void {
			_isFocused = false;
		}
		
		private function handleMouseClick(e:Event):void {
			if (_module.qjPlayer.manager.currentPanoramaData.id != _waypointView.waypointData.waypoint.target){
				_module.qjPlayer.manager.loadPano(_waypointView.waypointData.waypoint.target);
			}else {
				_waypointView.viewerData.focusPoint = new Point(_waypointView.waypointData.waypoint.position.x, _waypointView.waypointData.waypoint.position.y);
			}
		}
		
		private function onPanoramaLoaded(panoramaEvent:Object = null):void {
			if (_module.qjPlayer.manager.currentPanoramaData.id == _waypointView.waypointData.waypoint.target) {
				currentDirection = _module.qjPlayer.managerData.getPanoramaDataById(_waypointView.waypointData.waypoint.target).direction;
				_waypointView.viewerData.focusPoint = new Point(_waypointView.waypointData.waypoint.position.x, _waypointView.waypointData.waypoint.position.y);
				_waypointView.waypointData.showRadar = true;
				if (!_waypointView.waypointData.radar.showTilt) {
					_waypointView.imageMapData.mapData.radarFirst = false;
				}
			}else {
				_waypointView.waypointData.showRadar = false;
			}
		}
		
		private function onIsAutorotatingChange(autorotationEvent:Object):void {
			if (_waypointView.waypointData.showRadar && !_isFocused) {
				_waypointView.viewerData.focusPoint = new Point(_waypointView.waypointData.waypoint.position.x, _waypointView.waypointData.waypoint.position.y);
				_isFocused = true;
			}
		}
		
		private function handleShowRadarChange(e:Event):void {
			drawButton();
			if (_waypointView.waypointData.showRadar){
				_pan = NaN;
				_tilt = NaN;
				_fov = NaN;
				_module.stage.addEventListener(Event.ENTER_FRAME, handleEnterFrame, false, 0, true);
				handleEnterFrame();
				_waypointView.radar.alpha = 0;
				Tweener.addTween(_waypointView.radar,
					{alpha:((1 / _waypointView.imageMapData.windowData.window.alpha) * _waypointView.waypointData.radar.alpha), time:0.5, transition:"easeInExpo" } );
			}else {
				_waypointView.radar.graphics.clear();
				_module.stage.removeEventListener(Event.ENTER_FRAME, handleEnterFrame);
			}
		}
		
		public function handleMouseOverChange(e:Event):void {
			drawButton();
		}
		
		private function handleEnterFrame(e:Event = null):void {
			if (_fov != _module.qjPlayer.manager._fieldOfView) {
				drawRadar();
				_fov = _module.qjPlayer.manager._fieldOfView;
			}
			if(_waypointView.waypointData.radar.showTilt && _tilt != _module.qjPlayer.manager._tilt){
				_waypointView.radarTilt = (1 - Math.abs(_module.qjPlayer.manager._tilt) / 100);
				if (_module.qjPlayer.manager._tilt > 0) {
					_waypointView.imageMapData.mapData.radarFirst = true;
				}else {
					_waypointView.imageMapData.mapData.radarFirst = false;
				}
				_tilt = _module.qjPlayer.manager._tilt;
			}
			if (_pan != _module.qjPlayer.manager._pan) {
				_waypointView.radar.rotationZ = _module.qjPlayer.manager._pan + currentDirection + _waypointView.waypointData.panShift + _waypointView.waypointData.radar.panShift;
				_pan = _module.qjPlayer.manager._pan;
				pan3 = pan2;
				pan2 = pan1;
				pan1 = _module.qjPlayer.manager._pan;
				if (_waypointView.waypointData.showRadar && !_isFocused) {
					if(Math.floor(Math.abs(pan1 - pan2)) > Math.floor(Math.abs(pan2 - pan3))){ // detect acceleration 
						_waypointView.viewerData.focusPoint = new Point(_waypointView.waypointData.waypoint.position.x, _waypointView.waypointData.waypoint.position.y);
						_isFocused = true;
					}
				}
			}
		}
		
		private function drawRadar():void {
			_waypointView.radar.graphics.clear();
			var startAngle:Number = (-_module.qjPlayer.manager._fieldOfView - 180) * Math.PI / 180 * 0.5;
			var endAngle:Number = (_module.qjPlayer.manager._fieldOfView - 180) * Math.PI / 180 * 0.5;
			var divisions:Number = Math.floor(Math.abs(endAngle - startAngle) / (Math.PI / 4)) + 1;
			var span:Number = Math.abs(endAngle - startAngle) / (2 * divisions);
			var controlRadius:Number = _waypointView.waypointData.radar.radius / Math.cos(span);
			_waypointView.radar.graphics.beginFill(_waypointView.waypointData.radar.color);
			/*
			// 声明一个仿射矩阵 Matrix
			var gradientBoxMatrix:Matrix = new Matrix();
			
			// createGradientBox() - Matrix 的一个专门为渐变填充提供的方法
			//     三个参数分别为渐变框的宽，渐变框的高，渐变框的旋转弧度
			gradientBoxMatrix.createGradientBox(50, 20, 0);
			_waypointView.radar.graphics.beginGradientFill(GradientType.LINEAR, [_waypointView.waypointData.radar.color, 0xFFFFFF], [1, 0.5], [0, 255], gradientBoxMatrix, SpreadMethod.REPEAT);
			
			var gradientBoxMatrix:Matrix = new Matrix();
			gradientBoxMatrix.createGradientBox(290, 290, 360);
			_waypointView.radar.graphics.beginGradientFill(GradientType.RADIAL, [_waypointView.waypointData.radar.color, 0xFFFFFF], [1, 0.5], [0, 255], gradientBoxMatrix, SpreadMethod.REPEAT);
			*/
			//_waypointView.radar.graphics.lineStyle(_waypointView.waypointData.radar.borderSize, _waypointView.waypointData.radar.borderColor);
			
			_waypointView.radar.graphics.moveTo(0, 0);
			_waypointView.radar.graphics.lineTo((Math.cos(startAngle) * _waypointView.waypointData.radar.radius), Math.sin(startAngle) * _waypointView.waypointData.radar.radius);
			var controlPoint:Point;
			var anchorPoint:Point;
			for(var i:Number=0; i < divisions; ++i){
				endAngle = startAngle + span;
				startAngle = endAngle + span;
			
				controlPoint = new Point(Math.cos(endAngle) * controlRadius, Math.sin(endAngle) * controlRadius);
				anchorPoint = new Point(Math.cos(startAngle) * _waypointView.waypointData.radar.radius, Math.sin(startAngle) * _waypointView.waypointData.radar.radius);
				_waypointView.radar.graphics.curveTo(controlPoint.x, controlPoint.y, anchorPoint.x, anchorPoint.y);
			}
			_waypointView.radar.graphics.endFill();
		}
		
		private function drawButton():void {
			if (_waypointView.waypointData.showRadar){
				_waypointView.buttonBitmapData = _waypointView.waypointData.bitmapDataActive;
			}else if (_waypointView.waypointData.mouseOver) {
				_waypointView.buttonBitmapData = _waypointView.waypointData.bitmapDataHover;
				
			}else { // !mouseOver
				_waypointView.buttonBitmapData = _waypointView.waypointData.bitmapDataPlain;
			}
			
			
		}
	}
}
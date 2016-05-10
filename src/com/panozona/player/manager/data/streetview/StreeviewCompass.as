package com.panozona.player.manager.data.streetview
{
	import com.panosalado.utils.Inertion;
	import com.panozona.player.manager.StreetManager;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;

	public class StreeviewCompass extends Sprite
	{
		private var _streetmanager:StreetManager;
		
		private var inertialFieldOfView:Inertion;
		
		[Embed(source="assert/compass.swf", mimeType = "application/octet-stream")]
		private var _compassviewaxis_class:Class;
		 

		public var loader:Loader;
		
		public var clip:MovieClip;
		
		private var _compassviewaxis:MovieClip;
		

		private var _compassviewaxissp:MovieClip ;
		private var _compassviewaxisbg:SimpleButton ;
		private var _compassviewup:SimpleButton ;
		private var _compassviewdown:SimpleButton  ;
		private var _compassviewleft:SimpleButton  ;
		private var _compassviewright:SimpleButton ;
		private var _compassviewreset:SimpleButton ;
		private var _compassviewbig:SimpleButton  ;
		private var _compassviewsmall:SimpleButton ;
		
		public function StreeviewCompass(streetmanager:StreetManager)
		{
			
			this._streetmanager = streetmanager;
			inertialFieldOfView = new Inertion(50, 5, 0.25);
			
			var bytecontent:ByteArray =  new _compassviewaxis_class();
			var locontext:LoaderContext=new LoaderContext(false,ApplicationDomain.currentDomain);
			loader = new Loader();
			loader.loadBytes(bytecontent,locontext);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,compeleHandler);
			
			
			
			
		}
		
		private function compeleHandler(e:Event):void
		{
			/**

[object sp]
[object big]
[object small]
[object reset]
[object up]
[object down]
[object right] 
[object left] 
			*/

			_compassviewaxis  = loader.content as MovieClip;
			this.addChild(_compassviewaxis);
			

			
			_compassviewaxissp = _compassviewaxis.getChildAt(0) as MovieClip;
			_compassviewaxisbg  = _compassviewaxissp.getChildAt(0) as SimpleButton
				
			_compassviewbig = _compassviewaxis.getChildAt(1) as SimpleButton
			_compassviewsmall = _compassviewaxis.getChildAt(2) as SimpleButton
			_compassviewreset= _compassviewaxis.getChildAt(3) as SimpleButton
				
			_compassviewup=_compassviewaxis.getChildAt(4) as SimpleButton
			_compassviewdown = _compassviewaxis.getChildAt(5) as SimpleButton
			_compassviewright = _compassviewaxis.getChildAt(6) as SimpleButton
			_compassviewleft = _compassviewaxis.getChildAt(7) as SimpleButton
				
			
			
	
			
				
			this._compassviewaxisbg.addEventListener(MouseEvent.MOUSE_DOWN,compassviewaxisdownHandler);
			this._compassviewaxisbg.addEventListener(MouseEvent.MOUSE_UP,compassviewaxisupHandler);
			
			this._compassviewreset.addEventListener(MouseEvent.CLICK,compassviewresetHandler);
			
			this._compassviewup.addEventListener(MouseEvent.CLICK,compassviewupHandler);
			this._compassviewdown.addEventListener(MouseEvent.CLICK,compassviewdownHandler);
			this._compassviewleft.addEventListener(MouseEvent.CLICK,compassviewleftHandler);
			this._compassviewright.addEventListener(MouseEvent.CLICK,compassviewrightHandler);
			
			
			this._compassviewbig.addEventListener(MouseEvent.CLICK,compassviewbigHandler);
			this._compassviewsmall.addEventListener(MouseEvent.CLICK,compassviewsmallHandler);
			
			this.addEventListener(Event.ENTER_FRAME,enterframeHandler);
			
			
			
	
		
		
		
		
	}
	
		
	
		
		private var viewaxis_x:Number = 0;
		private var viewaxis_y:Number = 0;
		private var viewaxis_direction:Number = 0;
		private var viewaxix_down:Boolean= false;
		private function compassviewaxisdownHandler(e:MouseEvent):void
		{
			viewaxis_x = this._streetmanager.mouseX;
			viewaxis_y = this._streetmanager.mouseX;
			
			viewaxis_direction = _streetmanager.pan + _streetmanager.currentPanoramaData.direction;
			
			viewaxix_down = true;
		}
		private function compassviewaxisupHandler(e:MouseEvent):void
		{
			if(viewaxix_down == true)
			{
				var tx:Number = this._streetmanager.mouseX;
				var ty:Number = this._streetmanager.mouseY;
				
				
				var dx:Number = Math.abs(viewaxis_x - tx);
				var dy:Number =  Math.abs(viewaxis_y - ty);
				var angle:Number = Math.atan2(dy,dx);
	
				var arrowrotation:Number = angle* 180/Math.PI;
				trace("arrowrotation"+arrowrotation);
				if(viewaxis_x > tx)
				{
					_streetmanager.pan = viewaxis_direction - arrowrotation;
				}
				else
				{
					_streetmanager.pan = viewaxis_direction + arrowrotation;
				}
				
			}
			viewaxix_down = false;
		}
		
		private function compassviewresetHandler(e:MouseEvent):void
		{
			e.preventDefault();
			var p:Number =  _streetmanager.currentPanoramaData.direction;
			_streetmanager.swingTo(p,NaN,NaN,60);
		}
		
		private function compassviewupHandler(e:MouseEvent):void
		{
			e.preventDefault();
			var p:Number = 0 - _streetmanager.currentPanoramaData.direction;
			_streetmanager.swingTo(p,NaN,NaN,60);
		}
		private function compassviewdownHandler(e:MouseEvent):void
		{
			e.preventDefault();
			var p:Number = 180 - _streetmanager.currentPanoramaData.direction;
			_streetmanager.swingTo(p,NaN,NaN,60);
		}
		private function compassviewrightHandler(e:MouseEvent):void
		{
			e.preventDefault();
			var p:Number = 270;
			_streetmanager.swingTo(p,NaN,NaN,60);
		}
		private function compassviewleftHandler(e:MouseEvent):void
		{
			e.preventDefault();
			var p:Number = 90;
			_streetmanager.swingTo(p,NaN,NaN,60);
		}
		
		private function compassviewbigHandler(e:MouseEvent):void
		{
			e.preventDefault();
			var deltaFieldOfView:Number = inertialFieldOfView.decrement(); 
			deltaFieldOfView = inertialFieldOfView.aimZero();
			
			this._streetmanager.fieldOfView += deltaFieldOfView;
			

			
		}
		private function compassviewsmallHandler(e:MouseEvent):void
		{
			e.preventDefault();
			var deltaFieldOfView:Number = inertialFieldOfView.decrement(); 
			deltaFieldOfView = inertialFieldOfView.aimZero();
			
			this._streetmanager.fieldOfView -= deltaFieldOfView;
		}
		
		private function enterframeHandler(e:Event):void
		{
			if(_compassviewaxissp != null && _streetmanager != null && _streetmanager.currentPanoramaData != null) { 
				_compassviewaxissp.rotationZ = _streetmanager.pan + _streetmanager.currentPanoramaData.direction;
			}
		}
			
	}
}
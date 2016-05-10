package com.panosalado.utils
{
	
	import com.robertpenner.easing.Expo;
	import com.robertpenner.easing.Linear;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filters.BitmapFilter;
	import flash.utils.getTimer;
	
	//(currentTime, startPosition, endPosition, totalTime) standard parameters.
	
	public class AnimationFilter extends EventDispatcher
	{
		//animationfilter.time, animationfilter.startValue, animationfilter.deltaValue, animationfilter.deltaTime
		public var target:*;
		public var filter:*;
		public var property:Vector.<String>;
		public var startValue:Vector.<Number>;
		public var deltaValue:Vector.<Number>;
		public var time:Number;
		public var deltaTime:int;
		public var tween:Function;
		
		/*

		var alphaTransition:AnimationFilter = new AnimationFilter(bitmapdata,"twirlFilter", Vector.<String>(["amount"]), Vector.<Number>([1]), Vector.<Number>([3]), 2);
		alphaTransition.addEventListener(Event.COMPLETE, endTransition, false, 0, true);
		
		*/
		
		Linear;
		Expo;
		public function AnimationFilter(target:*,filter:*, property:Vector.<String>, start:Vector.<Number>, end:Vector.<Number>, time:Number){
			if ( target == null) throw new Error("Invalid Animation: target is null");
			// 		if ( !target.hasOwnProperty(property) ) throw new Error("Invalid Animation:" + target + " does not have property:" + property);
			// 		if ( !target[property] is Number && !target[property] is int ) throw new Error("Invalid Animation: non-numeric property");
			// 		if ( isNaN(target[property]) ) throw new Error("Invalid Animation: property values is NaN (Not-A-Number)");

			this.target = target;
			this.property = property;
			this.filter = filter;
			this.deltaValue = new Vector.<Number>();
			this.startValue = new Vector.<Number>();
			var len:int = property.length;
			for (var i:int = 0; i < len; i++) {
				this.startValue[i] = start[i];
				this.deltaValue[i] = end[i] - this.startValue[i];
			}
			this.time = 0;
			this.deltaTime = int( time * 1000 );
			this.tween =  Linear.easeIn;
			
			AnimatorFilter.instance.add(this);
		}
		
		public function play():void {
			AnimatorFilter.instance.add(this);
		}
		
		public function pause():void {
			
		}
		
		public function stop():void {
			AnimatorFilter.instance.remove(this);
		}
		
		override public function toString():String {
			return "[AnimationFilter]: " + target + " " + property + " " + startValue + " " + deltaValue + " : " 
				+ time + " " + deltaTime + " " + tween;
		}
		
	}
}

import com.panosalado.utils;
import com.panosalado.utils.AnimationFilter;
import com.panosalado.utils.Filter;
import com.panozona.modules.guestBook.utils.Time;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;
import flash.filters.DisplacementMapFilter;
import flash.geom.Point;
import flash.utils.Dictionary;
import flash.utils.getTimer;

class AnimatorFilter extends Sprite
{
	protected static var animationfilters:Dictionary;
	protected var lastTimeStamp:int;
	protected static var _instance:AnimatorFilter;
	protected var count:int;
	
	public function AnimatorFilter() {
		_instance = this;
		animationfilters = new Dictionary(true);
		count = 0;
	}
	
	public static function get instance():AnimatorFilter {
		if (_instance != null) return _instance;
		else return new AnimatorFilter();
	}
	
	public function add(animationfilter:AnimationFilter):void {
		count++;
		if 	(animationfilters[animationfilter.target] == undefined) 
			animationfilters[animationfilter.target] = Vector.<AnimationFilter>([animationfilter]);
		else animationfilters[animationfilter.target].push(animationfilter); 
		if (count == 1) {
			lastTimeStamp = getTimer();
			addEventListener(Event.ENTER_FRAME, enterFrameHandler, false, 0, true);
		}
	}
	
	public function remove(animationfilter:AnimationFilter):void {
		var v:Vector.<AnimationFilter> = animationfilters[animationfilter.target];
		var len:int = v.length;
		if (len == 1) { 
			delete animationfilters[animationfilter.target];
			count -= 1; 
			if (count == 0) removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		else {
			var i:int = 0;
			while (i < v.length) {
				if (v[i] === animationfilter) {
					v.splice(i,1);
					continue;
				}
				i++;
			}
		}
	}
	
	final public function enterFrameHandler(e:Event):void {
		var currentTimeStamp:int = getTimer();
		var elapsedTime:int = currentTimeStamp - lastTimeStamp;
		for each (var vectorOfAnimations:Vector.<AnimationFilter> in animationfilters) {
			var i:int = 0;
			var len:int = vectorOfAnimations.length;
			while( i < len ) {
				var animationfilter:AnimationFilter = vectorOfAnimations[i];
				animationfilter.time += elapsedTime;
				var plen:int = animationfilter.property.length;
				var done:Boolean = (animationfilter.time >= animationfilter.deltaTime) ? true : false;
				
				var targetproperty:Object = new Object();
				for (var j:int = 0; j < plen; j++) {
					if (!done) 
					{
						targetproperty[animationfilter.property[j]] = animationfilter.tween.call(null, animationfilter.time, animationfilter.startValue[j], animationfilter.deltaValue[j], animationfilter.deltaTime);
					}
					else 
					{
						targetproperty[animationfilter.property[j]] = animationfilter.startValue[j] + animationfilter.deltaValue[j]; 
					}
				}
				switch(animationfilter.filter)
				{
					case "twirlFilter":
						trace("amount"+targetproperty["amount"]+":"+new Date());
						var bmd:BitmapData = animationfilter.target as  BitmapData;
					
						var filter:DisplacementMapFilter = Filter.twirlFilter(bmd,bmd.rect,targetproperty["amount"]);
						bmd.applyFilter(bmd, bmd.rect, new Point(0, 0), filter);
						trace("end amount"+targetproperty["amount"]+":"+new Date());
						break;
	
				}
				
				if (done) {
					animationfilter.dispatchEvent( new Event(Event.COMPLETE) );
					remove(animationfilter);
					
			
					len--
					continue;
					
				}
				i++;
			}
		}
		lastTimeStamp = currentTimeStamp;
	}
}
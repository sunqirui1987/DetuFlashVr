/*
 OuWei Flash3DHDView 
*/
package com.panozona.player.manager.data.panoramas {
	
	import com.panosalado.model.Params;
	import com.panozona.player.manager.data.panoramas.linkArrows.LinkData;
	import com.panozona.player.manager.utils.loading.ILoadable;
	import com.panozona.player.module.data.property.LngLat;
	
	public class PanoramaData {
		
		/**
		 * Action called on entering this panorama
		 */
		public var onEnter:String;
		
		/**
		 * Action called on transition effect finished in this panorama
		 */
		public var onTransitionEnd:String;
		
		/**
		 * Action called on leaving this panorama
		 */
		public var onLeave:String;
		
		/**
		 * Object where keys are ids of panoramas and values are ids of actions.
		 * Action is executed when entering from panorama of given id.
		 */
		public var onEnterFrom:Object = new Object();
		
		/**
		 * Object where keys are ids of panoramas and values are ids of actions.
		 * Action is executed when transition effect is finished after entering from panorama of given id.
		 */
		public var onTransitionEndFrom:Object = new Object();
		
		/**
		 * Object where keys are ids of panoramas and values are ids of actions.
		 * Action is executed when leaving to panorama of given id.
		 */
		public var onLeaveTo:Object = new Object();
		
		/**
		 * Object where keys are ids of panoramas and values are ids of actions.
		 * Setting this attribute prevents from loading panorama.
		 * Action is executed when user tries to leave to panorama of given id.
		 */
		public var onLeaveToAttempt:Object = new Object();
		
		protected var _direction:Number = 0;
		
		public var hotspotsData:Vector.<HotspotData> = new Vector.<HotspotData>();
		
		protected var _id:String;
		protected var _params:Params;
		
		public var lngLat:LngLat = new LngLat(0,0);
		
		public var linkTo:Vector.<LinkData> = new Vector.<LinkData>();
		
		public var title:String = "全景";
		
		public var description:String = "全景描述";
		
		public var xmlobj:Object = new Object();
		
		public function PanoramaData(id:String, path:String, preview:String="") {
			_id = id;
			_params = new Params(path,0,0,90,preview);
		}
		
		public function set preview(previewpath:String):void
		{
			_params.previewpath = previewpath;
		}
		
		public final function get id():String {
			return _id
		}
		
		public final function get params():Params {
			return _params;
		}
		
		/**
		 * Describes geographical direction where panorama image is pointing. Takes values 0 to 360
		 * For instance: North is 0, East is 90 South is 180, West is 270
		 */
		public function get direction():Number { return _direction; }
		public function set direction(value:Number):void {
			if (isNaN(value) || _direction == value) return;
			if ( value <= 0 || value >= 360 ) {
				_direction = ((value + 360) % 360);
			}else {
				_direction = value;
			}
		}
		
		public function hotspotDataById(id:String):HotspotData {
			for (var i:int = 0; i < hotspotsData.length; i++) {
				if (hotspotsData[i].id == id) {
					return hotspotsData[i];
				}
			}
			return null;
		}
		
		public function getHotspotsLoadable():Vector.<ILoadable> {
			var result:Vector.<ILoadable> = new Vector.<ILoadable>();
			for (var i:int = 0; i < hotspotsData.length; i++) {
				if (hotspotsData[i] is ILoadable) {
					result.push(hotspotsData[i] as ILoadable);
				}
			}
			return result;
		}
		
		public function getLinkDataById(id:String):LinkData{
			for (var i:int = 0; i < linkTo.length; i++) {
				if (linkTo[i].id == id) {
					return linkTo[i];
				}
			}
			return null;
		}
	}
}
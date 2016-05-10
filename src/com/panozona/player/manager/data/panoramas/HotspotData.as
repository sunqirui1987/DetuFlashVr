/*
 OuWei Flash3DHDView 
*/
package com.panozona.player.manager.data.panoramas {
	
	import com.panozona.player.module.data.property.Location;
	import com.panozona.player.module.data.property.Mouse;
	import com.panozona.player.module.data.property.TextArg;
	import com.panozona.player.module.data.property.Transform;
	
	public class HotspotData{
		public var location:Location = new Location();
		public var target:String = null;
		
		public var mouse:Mouse = new Mouse();
		public var handCursor:Boolean = true;
		
		public var transform:Transform = new Transform();
		
		public var isnew:Boolean = false;
		
		//下一个场景
		public var nextpan:Number = 0;
		public var nexttilt:Number = 0;
		public var nextfov:Number = 90;
		
		//移上去的
		public var text:String = "";
		public var textarg:TextArg = new TextArg();
		
		public var overalpha:Number = 1;
		public var alpha:Number = 1;
		// jsevent = on 或者空
		public var jsevent:String = "";
		
		public var crop:String=""
		
		//变量参数
		public var vars:String="";
		
		protected var _id:String;
		
		public function HotspotData(id:String){
			_id = id;
		}
		
		public final function get id():String{
			return _id;
		}
		
		
	}
}
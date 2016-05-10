package com.panozona.modules.inteltool.view
{
	import com.panozona.common.BitMapAnimation;
	import com.panozona.common.Ranger;
	import com.panozona.modules.inteltool.data.InterToolData;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-5-9 下午8:41:28
	 * 功能描述:
	 */
	public class SpeakView extends Sprite
	{
		private var _interTooldata:InterToolData;
		
		private var amt:BitMapAnimation;
		
		public static const PLAY:String = "play";
		public static const PLAYING:String = "playing";
		public static const PAUSE:String = "pause";
		
		public function SpeakView(_interTooldata:InterToolData)
		{
			super();
			this._interTooldata = _interTooldata;
			
			if(!_interTooldata.speaker.path)
				return;
			var arr:Array = [];
			arr[PLAY] = _interTooldata.speaker.playFrames;
			arr[PLAYING] = _interTooldata.speaker.playingFrames;
			arr[PAUSE] = _interTooldata.speaker.pauseFrames;
			amt = new BitMapAnimation(_interTooldata.speaker.row,_interTooldata.speaker.column,_interTooldata.speaker.path,_interTooldata.speaker.interval,arr,PLAY);
			addChild(amt);
		}
		
		public function get interTooldata():InterToolData{
			return _interTooldata;
		}
		
		public function setState(_state:String):void{
			if(amt)
				amt.state = _state;
		}
		
		public function get bitMapAnimation():BitMapAnimation{
			return amt;
		}
	}
}
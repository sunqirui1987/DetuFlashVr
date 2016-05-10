package com.panozona.player.module.data.property
{
	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-3-13 上午10:00:55
	 * 功能描述:
	 */
	public class LngLat
	{
		/**
		 * 经度 
		 */		
		public var lng:Number;
		
		/**
		 * 纬度 
		 */		
		public var lat:Number;
		public function LngLat(_lng:Number,_lat:Number)
		{
			this.lng = _lng;
			this.lat = _lat;
		}
	}
}
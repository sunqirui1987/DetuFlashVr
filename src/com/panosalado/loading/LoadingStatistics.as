
package com.panosalado.loading{
	
	public class LoadingStatistics {
		
		private static var __instance:LoadingStatistics;
		
		private var __latency:Number;
		private var __latencies:Vector.<int>;
		
		public function LoadingStatistics() {
			if (__instance != null) throw new Error("LoadingStatistics is a Singleton class: use LoadingStatistics.instance for the single instance");
			__latency = 0;
			__latencies = new Vector.<int>();
		}
		
		public static function get instance():LoadingStatistics {
			if (__instance == null) __instance = new LoadingStatistics();
			return __instance;
		}
		
		public function get averageLatency():Number {
			return __latency;
		}
		
		public function reportLatency(value:int):Number {
			// calculate latency as an average of the last ten loads
			if (__latencies.length == 10) __latencies.shift();
			__latencies[__latencies.length] = ( value );
			var latenciesLength:int = __latencies.length;
			var i:int = 0;
			var totalLatency:int;
			while( i < latenciesLength ){
				totalLatency += __latencies[i];
				i++;
			}
			__latency = totalLatency/latenciesLength;
			return __latency;
		}
	}
}
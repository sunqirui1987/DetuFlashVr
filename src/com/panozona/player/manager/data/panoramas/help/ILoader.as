package com.panozona.player.manager.data.panoramas.help
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;

	public interface ILoader
	{
		function onCmp(e:Event,url:String):void
		
		function onErr(e:IOErrorEvent,url:String):void
		
		function onProgress(e:ProgressEvent,url:String):void
			
		function loaded(url:String):void
	}
}
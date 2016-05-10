package com.panosalado.utils
{
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;

	public class ResLoader extends Loader
	{
		public function ResLoader()
		{
			super();
		}
		
		public override function load(request:URLRequest, context:LoaderContext=null):void
		{
			
			super.load(request,context);
		}
	}
}
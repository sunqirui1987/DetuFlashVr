package com.panozona.player.manager.data.panoramas.help
{
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;

	public class SwfLoader
	{
		public function SwfLoader()
		{
		}

		private static var waitList:Array = new Array();
		private static var loaderInfoList:Array = new Array();
		private static var funsList:Array = new Array();
		private static var progressList:Array = new Array();

		public static function init():void
		{
			waitList = new Array();
			funsList = new Array();
		}

		public static function load( url:String, finishFun:Function = null, progressFun:Function = null ):void
		{
			if( waitList.indexOf( url ) >= 0 )
			{ //已经加载过了
				if( finishFun != null )
				{
					if( loaderInfoList[ url ] != null )
					{
						finishFun( loaderInfoList[ url ]);
					}
					else
					{
						if( finishFun != null )
						{
							if( !funsList[ url ])
								funsList[ url ] = new Array();
							( funsList[ url ] as Array ).push( finishFun );
						}
					}
				}

				if( iloader && loaderInfoList[ url ])
					iloader.onCmp( null, loaderInfoList[ url ].loader.name );
				return;
			}
			waitList.push( url );

			if( finishFun != null )
			{
				if( !funsList[ url ])
					funsList[ url ] = new Array();
				( funsList[ url ] as Array ).push( finishFun );
			}

			if( progressFun != null )
				progressList[ url ] = progressFun;

			var urlLoader:SURLLoader = new SURLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			urlLoader.name = url;
			toggleLoaderListeners( urlLoader, true );

			urlLoader.load(new URLRequest(url));
		}

		private static function urlLoadComplete( event:Event ):void
		{
			var urlLoader:SURLLoader = event.target as SURLLoader;
			toggleLoaderListeners( urlLoader, false );

			var bytes:ByteArray = urlLoader.data as ByteArray;
	//		_loaderContext.securityDomain = SecurityDomain.currentDomain;
			var loader:Loader = new Loader();
			loader.name = urlLoader.name;
			loader.contentLoaderInfo.addEventListener( Event.COMPLETE, onCmp );
			loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, onErr );
			loader.loadBytes( bytes );
		}

		private static function urlLoadError( event:Event ):void
		{
		}

		private static function onErr( e:IOErrorEvent ):void
		{
//			trace(e.text);
			if( iloader )
				iloader.onErr( e, LoaderInfo( e.target ).loader.name );
		}

		private static function onCmp( e:Event ):void
		{
			e.target.removeEventListener( Event.COMPLETE, onCmp );
			e.target.removeEventListener( IOErrorEvent.IO_ERROR, onErr );
			var loader:Loader = e.target.loader;
			loaderInfoList[ loader.name ] = e.target;

			if( funsList[ loader.name ])
			{
				var arr:Array = funsList[ loader.name ] as Array;

				for( var i:int = 0; i < arr.length; i++ )
				{
					var fun:Function = arr[ i ] as Function;
					fun( e.target );
					arr.splice( i, 1 );
					i--;
				}
			}

			if( iloader )
				iloader.onCmp( e, loader.name );
		}

		private static function onProgress( e:ProgressEvent ):void
		{
			var urlLoader:SURLLoader = e.target as SURLLoader;
			
			if( iloader )
				iloader.onProgress( e, urlLoader.name );

			if( progressList[ urlLoader.name ])
				progressList[ urlLoader.name ]( e );
		}

		private static var iloader:ILoader;

		public static function setlLoader( _iloader:ILoader ):void
		{
			iloader = _iloader;
		}

		public static function destroy():void
		{
			funsList = null;
			waitList = null;
			loaderInfoList = null;
			progressList = null;
		}

		public static function delCache( url:String ):void
		{
			loaderInfoList[ url ] = null;
			delete loaderInfoList[ url ];

			if( funsList[ url ])
			{
				var arr:Array = funsList[ url ] as Array;

				for( var i:int = 0; i < arr.length; i++ )
				{
					var fun:Function = arr[ i ] as Function;
					arr.splice( i, 1 );
					i--;
				}
			}
			var index:int = waitList.indexOf( url );

			if( index >= 0 )
				waitList.splice( index, 1 );
		}

		/**
		 * 切换添加和移除加载对象的事件
		 * @param loader				- 加载对象（必须是Loader或者URLLoader对象）
		 * @param on					- 是否添加（true - 添加；false - 移除）
		 */
		protected static function toggleLoaderListeners( loader:Object, on:Boolean ):void
		{
			if( loader is Loader )
				loader = loader.contentLoaderInfo;

			if( on )
			{
				loader.addEventListener( Event.COMPLETE, urlLoadComplete );
				loader.addEventListener( ProgressEvent.PROGRESS, onProgress );
				loader.addEventListener( IOErrorEvent.IO_ERROR, urlLoadError );
			}
			else
			{
				loader.removeEventListener( Event.COMPLETE, urlLoadComplete );
				loader.removeEventListener( ProgressEvent.PROGRESS, onProgress );
				loader.removeEventListener( IOErrorEvent.IO_ERROR, urlLoadError );
			}
		}
	}
}

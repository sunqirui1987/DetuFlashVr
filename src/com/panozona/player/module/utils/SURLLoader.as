
package  com.panozona.player.module.utils
{
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class SURLLoader extends URLLoader
	{
		//--------------------------------------------------------------------------
		//
		//   Class constructor
		//
		//--------------------------------------------------------------------------

		public function SURLLoader( request:URLRequest = null )
		{
			super( request );
		}

		//--------------------------------------------------------------------------
		//
		//	 Class properties
		//
		//--------------------------------------------------------------------------

		private var _name:String;

		public function get name():String
		{
			return _name;
		}

		public function set name( value:String ):void
		{
			_name = value;
		}

	}
}

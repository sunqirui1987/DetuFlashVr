package com.panozona.modules.swfobject
{
	public class OuWeiEventDelegate
	{
		public function OuWeiEventDelegate()
		{
			
		}

		public static function create(f:Function,... arg):Function {
			var F:Boolean=false;
			var _f:Function=function(e:*,..._arg):void{
				_arg=arg
				if(!F){
					F=true
					_arg.unshift(e)}
				f.apply(null,_arg)
			};
			return _f;
		}
		public static function toString():String {
			return "Class OuWeiEventDelegate";
		}

	}
}
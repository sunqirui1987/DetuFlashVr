package com.spikything.utils
{
	public class URL
	{
		public function URL()
		{
		}
		
		public static function resolveURI(url:String):String
		{
			
			var hashurl:String =  url.substring(url.lastIndexOf("?"));
			url =  url.substring(0, url.lastIndexOf("?"));
			
			var  baseURI:String  = url.substring(0, url.lastIndexOf("/") + 1)
			var  basefile:String = url.substring(url.lastIndexOf("/")+1);
			basefile = URL.rawurlencode(basefile);
			url = baseURI + basefile + hashurl;
				
			return url;
		}
		
		public static function rawurlencode (str:String):String {
			// http://kevin.vanzonneveld.net
			// +   original by: Brett Zamir (http://brett-zamir.me)
			// +      input by: travc
			// +      input by: Brett Zamir (http://brett-zamir.me)
			// +   bugfixed by: Kevin van Zonneveld (http://kevin.vanzonneveld.net)
			// +      input by: Michael Grier
			// +   bugfixed by: Brett Zamir (http://brett-zamir.me)
			// +      input by: Ratheous
			// +      reimplemented by: Brett Zamir (http://brett-zamir.me)
			// +   bugfixed by: Joris
			// +      reimplemented by: Brett Zamir (http://brett-zamir.me)
			// %          note 1: This reflects PHP 5.3/6.0+ behavior
			// %        note 2: Please be aware that this function expects to encode into UTF-8 encoded strings, as found on
			// %        note 2: pages served as UTF-8
			// *     example 1: rawurlencode('Kevin van Zonneveld!');
			// *     returns 1: 'Kevin%20van%20Zonneveld%21'
			// *     example 2: rawurlencode('http://kevin.vanzonneveld.net/');
			// *     returns 2: 'http%3A%2F%2Fkevin.vanzonneveld.net%2F'
			// *     example 3: rawurlencode('http://www.google.nl/search?q=php.js&ie=utf-8&oe=utf-8&aq=t&rls=com.ubuntu:en-US:unofficial&client=firefox-a');
			// *     returns 3: 'http%3A%2F%2Fwww.google.nl%2Fsearch%3Fq%3Dphp.js%26ie%3Dutf-8%26oe%3Dutf-8%26aq%3Dt%26rls%3Dcom.ubuntu%3Aen-US%3Aunofficial%26client%3Dfirefox-a'
			str = (str + '').toString();
			
			// Tilde should be allowed unescaped in future versions of PHP (as reflected below), but if you want to reflect current
			// PHP behavior, you would need to add ".replace(/~/g, '%7E');" to the following.
			return encodeURIComponent(str).replace(/!/g, '%21').replace(/'/g, '%27').replace(/\(/g, '%28').
				replace(/\)/g, '%29').replace(/\*/g, '%2A');
		}
	}
}
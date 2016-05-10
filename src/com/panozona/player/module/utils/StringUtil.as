package  com.panozona.player.module.utils
{
	import flash.utils.ByteArray;

	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-8-19 下午1:28:32
	 * 功能描述:
	 */
	public class StringUtil
	{
		public function StringUtil()
		{
		}
		
		public static function getStringLen(str:String,charSet:String="gb2312"):int{
			var byte:ByteArray = new ByteArray();
			byte.writeMultiByte(str,charSet);
			byte.position = 0;
			//byte.readMultiByte(byte.bytesAvailable,charSet);
			return byte.bytesAvailable;
		}
		
		public static function cutStr(str:String = "", length:uint = 0,hasDot:Boolean=false):String  
		{  
			var newLength:int = 0;   
			var newStr:String = "";   
			var chineseRegex:RegExp = /[^\x00-\xff]/g;   
			var singleChar:String = "";   
			var strLength:int = str.replace(chineseRegex,"**").length;   
			for(var i:int = 0;i < strLength;i++)   
			{   
				singleChar = str.charAt(i).toString();   
				if(singleChar.match(chineseRegex) != null)   
				{   
					newLength += 2;   
				}       
				else   
				{   
					newLength++;   
				}   
				if(newLength > length)   
				{   
					break;   
				}   
				newStr += singleChar;   
			}   
			
			if(hasDot && strLength > length)   
			{   
				newStr += "...";   
			}   
			return newStr;   
		}
	}
}
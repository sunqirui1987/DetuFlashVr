package com.panozona.modules.guestBook.utils
{
	public class Time
	{
		public function Time()
		{
		}
		
		public static function  getDateString(date:Date=null):String{
			if(!date)
				date =  new Date();
			var hour:* = date.getHours();
			var min:* = date.getMinutes();
			var second:* = date.getSeconds();
			if(hour<10)
				hour="0"+hour;
			if(min<10)
				min="0"+min;
			if(second<10)
				second="0"+second;
			return hour+":"+min+":"+second;
		}
		
		public static function  getFullDateAndTimeString(date:Date=null,replaceStr:String="YYYY-MM-DD hh:mm:ss"):String{
			if(!date)
				date =  new Date();
			var year:* = date.getFullYear();
			var month:* = date.getMonth()+1;
			var day:* = date.getDate();
			var hour:* = date.getHours();
			var min:* = date.getMinutes();
			var second:* = date.getSeconds();
			if(hour<10)
				hour="0"+hour;
			if(min<10)
				min="0"+min;
			if(second<10)
				second="0"+second;
			var s:String = 	replaceStr.replace("YYYY",year).replace("MM",month).replace("DD",day).replace("hh",hour).replace("mm",min).replace("ss",second);
			return s;
		}
		
		public static function  getDelayDateString(delayTime:int):String{
			delayTime = delayTime/1000;
			var hour:* = int(delayTime/3600);
			var min:* = int(delayTime%3600/60);
			var second:* = int(delayTime%3600%60);
			if(hour<10)
				hour="0"+hour;
			if(min<10)
				min="0"+min;
			if(second<10)
				second="0"+second;
			return hour+":"+min+":"+second;
		}
		
		public static function getDateByHourAndMin(hour:int,min:int):Date{
			var date:Date =  new Date();
			var year:* = date.getFullYear();
			var month:* = date.getMonth();
			var day:* = date.getDate();
			return new Date(year,month,day,hour,min);
		}
		
		public static function getMinAndSecondsBySecondss(n:int):String{
			var min:int = n/60;
			var sec:int = n%60;
			return (min<10?('0'+min):min)+':'+(sec<10?('0'+sec):sec);
		}
		
		public static function getHourAndMinAndSecondsBySecondss(n:int):String{
			var hour:int = n/3600;
			var min:int = n%3600/60;
			var sec:int = n%60;
			return (hour<10?('0'+hour):hour)+':'+(min<10?('0'+min):min)+':'+(sec<10?('0'+sec):sec);
		}
		
		public static function getDateByStr(temp:String):Date{
			var can:int = temp.indexOf('-');
			while(can>0){
				temp = temp.replace('-','');
				can = temp.indexOf('-');
			}
			var year:int = int(temp.substr(0,4));
			var month:int = int(temp.substr(4,2));
			var day:int = int(temp.substr(6,2));
			var hour:int = int(temp.substr(9,2));
			var min:int = int(temp.substr(12,2));
			return new Date(year,month-1,day,hour,min);
		}
	}
}
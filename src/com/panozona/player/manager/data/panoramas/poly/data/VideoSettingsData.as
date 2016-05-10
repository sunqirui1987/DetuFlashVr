package com.panozona.player.manager.data.panoramas.poly.data
{

	public class VideoSettingsData
	{
		public var splashPath:String = ""; 
		public var autoPlay:Boolean = true;
		
		public var scaleX:Number = 1;
		public var scaleY:Number = 1;
		public var offsetX:Number = 0;
		public var offsetY:Number = 0;
		public var rotation:Number = 0;
		
		public var volume:Number = 1;
		
		public var pause_clickaction:String="";
		public var pause_actionid:String="";
		public var play_clickaction:String="";
		public var play_actionid:String="";

		
		public function VideoSettingsData(data:String = "")
		{
			if(data == null || data == ""){ return ;}
			
			//预处理http:冒号
			data = data.replace("http://","http[]//");
			var arr:Array=data.split(",");
			for(var i:Number = 0;i<arr.length;i++)
			{
				var tkeyval:Array=arr[i].toString().split(":");
				var recognizedValue:* = recognizeContent(tkeyval[1]);
				if(this.hasOwnProperty(tkeyval[0]) && recognizedValue != null)
				{
					if(typeof(recognizedValue) == "string" )
					{
						recognizedValue = recognizedValue.replace("http[]//","http://");
					}
					this[tkeyval[0]] = recognizedValue;
				}
			}
		}
		
		
		protected function recognizeContent(content:String):*{
			if (content == null){
				return null;
			}else if (content == "true" || content == "false") { // Boolean
				return ((content == "true")? true : false);
			}else if (content.match(/^(-)?[\d]+(.[\d]+)?$/)) { // Number
				return (Number(content));
			}else if (content.match(/^#[0-9a-f]{6}$/i)) { // Number - color
				content = content.substring(1, content.length);
				return (Number("0x" + content));
			}else if (content == "NaN"){ // Number - NaN
				return NaN;
			}else{
				return String(content);
			}
			
		}
		
	}
}
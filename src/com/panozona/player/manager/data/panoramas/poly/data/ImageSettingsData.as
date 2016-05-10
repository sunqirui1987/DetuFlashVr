package com.panozona.player.manager.data.panoramas.poly.data
{
	
	public class  ImageSettingsData
	{

		public var scaleX:Number = 1;
		public var scaleY:Number = 1;
		public var rotation:Number = 0;
		public var offsetX:Number = 0;
		public var offsetY:Number = 0;
		
		
		public var clickaction:String="";
		public var actionid:String="";
		

		
		public function ImageSettingsData(data:String = "")
		{
			if(data == null || data == ""){ return ;}
			
			var arr:Array=data.split(",");
			for(var i:Number = 0;i<arr.length;i++)
			{
				var tkeyval:Array=arr[i].toString().split(":");
				var recognizedValue:* = recognizeContent(tkeyval[1]);
				if(this.hasOwnProperty(tkeyval[0]) && recognizedValue != null)
				{
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

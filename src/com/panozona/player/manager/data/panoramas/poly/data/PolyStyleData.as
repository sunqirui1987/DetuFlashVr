package com.panozona.player.manager.data.panoramas.poly.data
{
	public class PolyStyleData
	{
		public var bgalpha:Number = 1;
		public var obgalpha:Number = 1;
		
		public var mouseenable:Boolean = true;
		
		public var fillalpha:Number = 0.2;
		public var fillcolor:Number = 0xFFFFFF;
		
		public var fillalphaover:Number = 0.3;
		public var fillcolorover:Number = 0xFF0000;
		
		public var linealpha:Number = 0.6;
		public var linecolor:Number = 0x000000;
		public var lineborder:Number = 1;
		
		public var linealphaover:Number = 0.6;
		public var linecolorover:Number = 0x000000;
		public var lineborderover:Number = 1;
		
		
		public function PolyStyleData(data:String = "")
		{
			if(data == null || data == ""){ return ;}
			
			var arr:Array=data.split(",");
			for(var i:Number = 0;i<arr.length;i++)
			{
				var tkeyval:Array=arr[i].toString().split(":");
				var recognizedValue:* = recognizeContent(tkeyval[1]);
				if(this.hasOwnProperty(tkeyval[0]) && recognizedValue != null)
				{
					this[tkeyval[0]] = tkeyval[1];
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
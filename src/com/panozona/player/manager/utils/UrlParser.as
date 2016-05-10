package  com.panozona.player.manager.utils{
	
	public class UrlParser {
		
		public var pano:String;
		public var heading:Number;
		public var pitch:Number;
		public var fov:Number; // 90   
		
		public function UrlParser (url:String) {
			if(url != null && url.length>0){
				url = url.slice(url.indexOf("#"), url.length);
				if (url.length > 0) {
					url = url.substring(1);
					var settings:Array = url.split("&");
					var temp:Array;
					for each(var setting:String in settings){
						temp = setting.split("=");
						if (temp[0] == "pano"){
							pano = (temp[1]);
						}else if (temp[0] == "heading"){
							heading = (temp[1]);
						}else if (temp[0] == "pitch"){
							pitch = (temp[1]);
						}else if (temp[0] == "fov"){
							fov = (temp[1]);
						}
						
					}
				}
			}
		}
	}
}
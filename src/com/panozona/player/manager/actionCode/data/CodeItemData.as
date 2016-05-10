package com.panozona.player.manager.actionCode.data
{
	import com.panozona.player.manager.actionCode.Actioncode;

	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-8-26 上午10:40:39
	 * 功能描述:
	 */
	public class CodeItemData
	{
		
		public var id:String;
		
		public var content:String;
		
		public var protoContent:String;
		
		public function CodeItemData(id:String,content:String)
		{
			this.id = id;
			this.content = content;
			this.protoContent = content;
		}	
		
		public function parse():void{
//			/^[\w]+\.[\w]+\(.*\)$/
//			/(^[\w]+)|([\w]+(?=\())|((?<=\().+(?=\)))/g
			///(\w+)\((.*?)\)\s+;/g
			
			var tempList:Array = content.match(/(\w+)\((.*?)\)\s*?;/g);
			for(var i:int=0,n:int=tempList.length;i<n;i++){
				var content2:String = tempList[i];
				var tempList2:Array = content2.match(/(^[\w]+)|([\w]+(?=\())|((?<=\().+(?=\)))/g);
				if(tempList2.length == 2){
					var funName:String = tempList2[0];
					if(funName == "runActioncode"){
						var id2:String = tempList2[1];
						var item:CodeItemData = Actioncode.getIntance().getCodeItemDataById(id2);
						if(item){
							item.parse();
						}
						continue;
					}
					Actioncode.getIntance().curRunnningCommands.push(new CodeCommand(id,funName,tempList2[1]));
			//		trace(id,funName,tempList2[1]);
				}
			}
		}
		
		public function parseInArr(arr:Array):void{
			//			/^[\w]+\.[\w]+\(.*\)$/
			//			/(^[\w]+)|([\w]+(?=\())|((?<=\().+(?=\)))/g
			///(\w+)\((.*?)\)\s+;/g
			
			var tempList:Array = content.match(/(\w+)\((.*)\)\s*?;/g);
			for(var i:int=0,n:int=tempList.length;i<n;i++){
				var content2:String = tempList[i];
				var tempList2:Array = content2.match(/(^[\w]+)|([\w]+(?=\())|((?<=\().+(?=\)))/g);
				if(tempList2.length == 2){
					var funName:String = tempList2[0];
					if(funName == "runActioncode"){
						var id2:String = tempList2[1];
						var item:CodeItemData = Actioncode.getIntance().getCodeItemDataById(id2);
						if(item){
							item.parseInArr(arr);
						}
						continue;
					}
					arr.push(new CodeCommand(id,funName,tempList2[1]));
					//		trace(id,funName,tempList2[1]);
				}
			}
		}
	}
}
package com.panozona.player.manager.actionCode
{
	import com.panozona.player.manager.Manager;
	import com.panozona.player.manager.actionCode.data.CodeCommand;
	import com.panozona.player.manager.actionCode.data.CodeItemData;
	import com.panozona.player.manager.actionCode.view.ButtonView;
	import com.panozona.player.manager.actionCode.view.MarkView;
	import com.panozona.player.manager.data.panoramas.HotspotDataImage;
	import com.panozona.player.manager.data.panoramas.HotspotSprite;
	import com.panozona.player.manager.events.ConfigurationEvent;
	import com.panozona.player.module.global;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	import caurina.transitions.Tweener;

	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-8-25 下午3:28:14
	 * 功能描述:
	 */
	public class Actioncode
	{
		
		private static var _instance:Actioncode;
		
		private var mask:Sprite = new Sprite();
		
		public function Actioncode()
		{
			dataList = new Vector.<CodeItemData>();
			
			
		}
		
		public var dataList:Vector.<CodeItemData>;
		
		public function getCodeItemDataById(id:String):CodeItemData{
			for(var i:int=0,n:int=dataList.length;i<n;i++){
				var item:CodeItemData = dataList[i];
				if(item && item.id == id)
					return item;
			}
			return null;
		}
		
		
		public static function getIntance():Actioncode{
			if(!_instance)
				_instance = new Actioncode();
			return _instance;
		}
		
		public function runById(id:String):void{
			var item:CodeItemData =  getCodeItemDataById(id);
			runByItem(item);
		}
		
		public function runByContent(s:String):void{
			var item:CodeItemData = new CodeItemData("item"+Math.random(),s);
			runByItem(item);
		}
		
		public function runByItem(item:CodeItemData):void{
			if(!item)
				return;
			if(isPlaying)
				return;
			item.parse();
			isPlaying = true;
			stepIndex = -1;
			playNextCommand();
		}
		
		private var _qjPlayer:Object;
		public function set qjPlayer(_qjPlayer:Object):void{
			this._qjPlayer = _qjPlayer;
			if(!_qjPlayer.manager.stage.contains(layer)){
				layer.addChild(mask);
				_qjPlayer.manager.stage.addChild(layer);
			}
		}
		public function get qjPlayer():Object{
			return this._qjPlayer;
		}
		
		public var layer:Sprite = new Sprite();
		
		//--------------------
		
		/**
		 * 当前正在跑的命令 
		 */		
		public var curRunnningCommands:Array = [];
		
		/**
		 * 命名空间变量集合 
		 */		
		public var spaceVars:Array = [];
		
		private var isPlaying:Boolean;
		
		private var stepIndex:int=0;
		
		
		public function stop():void{
			isPlaying = false;
	//		dump(spaceVars);
			curRunnningCommands = [];
			clear();
		}
		
		public function clear():void{
			return;
			/*
			for(var s:String in spaceVars){
				delete spaceVars[s];
			}
			spaceVars = [];*/
		}
		
		public function playNextCommand():void{
			if(!isPlaying)
				return;
			if(stepIndex >= curRunnningCommands.length-1){
				stop();
				return;
			}
			stepIndex++;
			doCommand();
			
		}
		
		private var curRunningCmd:CodeCommand;
		
		private function doCommand():void{
			curRunningCmd = curRunnningCommands[stepIndex] as CodeCommand;
			if(curRunningCmd){
				var fun:Function = this[curRunningCmd.funName];
				if(fun)
					fun.apply(null,parseArgs(curRunningCmd.args));
				else
					playNextCommand();
			}else{
				playNextCommand();
			}
		}
		
		private function parseArgs(args:String):Array{
			var arr:Array = args.split(',');
			for(var i:int=0,n:int=arr.length;i<n;i++){
				var temp:String = arr[i];
				if(temp == "true"){
					arr[i] = true;
				}else if(temp == "false"){
					arr[i] = false;
				}
			}
			return arr;
		}
		
		//-------------------------------
		
		public function copy(target:String,value:*):void{
			try
			{
				trace("copy target="+target+" value="+value);
				var value2:* = getObject(value);
				setObject(target,value2);
				
			}
			catch(e:Error){
			}
		
			playNextCommand();
		}
		
		private var swtich_target_list:Object = new Object();
		public function swtich(target:String,atr:String,value:*,value2:*):void{
			
			var targetclass:* = getdeepObject(target,this.qjPlayer);
			var tvalue:* = targetclass[atr];
			
			if(tvalue == value)
			{
				xcopy(target,atr,value2);
			}
			else
			{
				xcopy(target,atr,value);
			}
		}
		
		public function xmethod(target:String,method:String,...args):void{
			
			try
			{
				for(var i:Number=0;i<args.length;i++)
				{
					args[i] = this.getObject(args[i]);
				}
				
				var targetclass:* = getdeepObject(target,this.qjPlayer);
				(targetclass[method] as Function).apply(targetclass, args);
			}
			catch(e:Error){
			}
			
			playNextCommand();
		}
		
		public function xcopy(target:String,atr:String,value:*):void{
			try
			{
				trace("xcopy target="+target+" value="+value);
				var value2:* = getObject(value);
				
				var targetclass:* = getdeepObject(target,this.qjPlayer);
				targetclass[atr] = value2;
				
			}
			catch(e:Error){
			}
			playNextCommand();
		}
		
		public function xget(target:String,atr:String):void
		{
			try
			{
				var targetclass:* = getdeepObject(target,this.qjPlayer);
				var value:* = targetclass[atr];
				setObject("vars."+atr,value);
			}
			catch(e:Error){
			}
			playNextCommand();
		}
		
		public function getdeepObject(s:String,obj:*):*{
			var arr:Array = s.split(".");
			//如果是模块
			if(arr[0] == "module")
			{
				obj = _qjPlayer.getModuleByName(arr[1]);
				
				arr.shift();
				arr.shift();
			}
		
			var returnobj:* = obj;
			for(var i:Number=0;i<arr.length;i++)
			{
				if(returnobj is Dictionary)
				{
					
				}
				returnobj = returnobj[arr[i]];
				
			}
			return returnobj;
			
		}
		
		
		
		public function setObject(s:String,value:*):void{
			var arr:Array = s.split(".");
			if(arr && arr.length>0){
				var s1:String = arr[0];
				if(s1 == "stage"){
					arr.shift();
					return setObj(qjPlayer.manager.stage,arr,value);
				}
				else if(s1 == "view"){
					arr.shift();
					setObj(qjPlayer.manager,arr,value);
				}else if(s1 == "module"){
					if(arr.length>=2){
						var moduleName2:String = arr[1] as String;
						var module:DisplayObject = _qjPlayer.getModuleByName(arr[1]);
						if(module){
							arr.shift();
							arr.shift();
							setObj(module,arr,value);
						}else{
							throw new Error(curRunningCmd.funName+" has no "+moduleName2+" module");
							return;
						}
					}
				}else if(s1.toLocaleLowerCase() == "imagebutton"){
					var module2:* = _qjPlayer.getModuleByName("ImageButton");	
					var id:String = arr[1] as String;
					if(module2){
						var button:* = module2.getButtonById(id);
						arr.shift();
						arr.shift();
						setObj(button,arr,value);
					}else{
						throw new Error(curRunningCmd.funName+" has no ImageButton module");
						return;
					}
				}else if(s1 == "hot"){
					id = arr[1] as String;
					var child:DisplayObject = qjPlayer.manager.hotspots[ qjPlayer.manager.currentPanoramaData.hotspotDataById(id)]
					arr.shift();
					arr.shift();
					setObj(child,arr,value);
				}else if(s1 == "acButton"){
					var name:String = arr[1] as String;
					child = layer.getChildByName(name);
					arr.shift();
					arr.shift();
					setObj(child,arr,value);
				}else{
					/*
					if(!spaceVars.hasOwnProperty(curRunningCmd.spaceId)){
						spaceVars[curRunningCmd.spaceId] = [];
					}
					if(!spaceVars[curRunningCmd.spaceId][s]){
						spaceVars[curRunningCmd.spaceId][s] = null;
					}
					spaceVars[curRunningCmd.spaceId][s] = value;
					*/
					spaceVars[s] = value;
				}
			}else{
				return;
			}
		}
		
	   
		
		public function getObject(s:String):*{
			var arr:Array = s.split(".");
			if(arr && arr.length>0){
				var s1:String = arr[0];
				if(s1 == "stage"){
					arr.shift();
				
					return getObj(qjPlayer.manager.stage,arr);
				}
				else if(s1 == "view"){
					arr.shift();
					return getObj(qjPlayer.manager,arr);
				}else if(s1 == "module"){
					if(arr.length>=2){
						var moduleName2:String = arr[1] as String;
						var module:DisplayObject = _qjPlayer.getModuleByName(moduleName2);
						if(module){
							arr.shift();
							arr.shift();
							var result:* = getObj(module,arr);
							return result;
						}else{
							throw new Error(curRunningCmd.funName+" has no "+moduleName2+" module");
							return null;
						}
					}
				}else if(s1 == "imageButton"){
					var module2:* = _qjPlayer.getModuleByName("ImageButton");	
					var id:String = arr[1] as String;
					if(module2){
						var button:* = module2.getButtonById(id);
						arr.shift();
						arr.shift();
						return getObj(button,arr);
					}else{
						return s;
					}
				}else if(s1 == "hot"){
					id = arr[1] as String;
					var child:DisplayObject = qjPlayer.manager.hotspots[ qjPlayer.manager.currentPanoramaData.hotspotDataById(id)]
					arr.shift();
					arr.shift();
					return getObj(child,arr);
				}else if(s1 == "acButton"){
					var name:String = arr[1] as String;
					child = layer.getChildByName(name);
					arr.shift();
					arr.shift();
					return getObj(child,arr);
				}else if(s1 == "vars"){
					return this.spaceVars[s];
				}
				else{
					if(s.indexOf("@getPx") >=0){
						return getPx(s);
					}
					if(s.indexOf("@getPy") >=0){
						return getPy(s);
					}
					if(s == "null"){
						return null;
					}else if (s.match(/^(\[.*\])$/)) { // [String]
						return s.substring(1, s.length - 1);
					}else if (s == "true" || s == "false") { // Boolean
						return ((s == "true")? true : false);
					}else if (s.match(/^(-)?[\d]+(.[\d]+)?$/)) { // Number
						return (Number(s));
					}else if (s.match(/^#[0-9a-f]{6}$/i)) { // Number - color
						s = s.substring(1, s.length);
						return (Number("0x" + s));
					}else if (s == "NaN"){ // Number - NaN
						return NaN;
						//}else if (content.match(/^(?!http).+:.+$/)) { // Object
						//	var object:Object = new Object();
						//		applySubAttributes(object, content); 
						//		return object;
					}else if (s.match(/^(Linear|Expo|Back|Bounce|Cubic|Elastic)\.[a-zA-Z]+$/)) { // Function
						return (recognizeFunction(s) as Function);
					}else if (s.replace(/\s/g, "").length > 0) { // TODO: trim
						return s; // String
					}
					return s;
				}
			}else{
				if(s == "true")
					return true;
				if(s == "false")
					return false;
				if(s == "null")
					return null;
				return s;
			}
		}
		
		protected function recognizeFunction(content:String):Function {
			var result:Function;
			var functionElements:Array = content.split(".");
			var functionClass:Object = getDefinitionByName("com.robertpenner.easing." + functionElements[0]);
			result = functionClass[functionElements[1]] as Function
			return result;
		}
		
		private function getPx(s:String):Number
		{
			var arr:Array = s.split("_");
			if(arr.length == 4){
				var target:DisplayObject = getObject(arr[1]);
				var w:Number = target?target.width:0;
				switch(arr[2]){
					case "left":
						return arr[3];
					case "center":
						return (qjPlayer.manager.boundsWidth-w)*0.5+Number(arr[3]);
					case "right":
						return qjPlayer.manager.boundsWidth-w+Number(arr[3]);
				}
			}
			return 0;
		}
		
		private function getPy(s:String):Number
		{
			var arr:Array = s.split("_");
			if(arr.length == 4){
				var target:DisplayObject = getObject(arr[1]);
				var w:Number = target?target.height:0;
				switch(arr[2]){
					case "top":
						return arr[3];
					case "middle":
						return (qjPlayer.manager.boundsHeight-w)*0.5+Number(arr[3]);;
					case "bottom":
						return qjPlayer.manager.boundsHeight-w+Number(arr[3]);;
				}
			}
			return 0;
		}
		
		public function call(funName:String,...args):void{
			trace("call funName="+funName+" args="+args);
			var obj:Function = getObject(funName);
			for(var s:String in args){
				if(args[s] is String)
					args[s] = getObject(args[s]);
			}
			obj.apply(null,args);
//			if(obj != null){
//				obj = value;
//			}
			playNextCommand();
		}
		
		private function getObj(obj:Object,s:Array):*{
			if(!s || s.length == 0)
				return obj;
			var temp:String = s[0];
	//		if(obj.hasOwnProperty[temp]){
			if(obj.hasOwnProperty(temp) || !isNaN(obj[temp]) || obj[temp]){
				s.shift();
//				if(s.length == 0){
//					return obj[temp];
//				}
				return getObj(obj[temp],s);
			}else{
		//		return obj;
				throw new Error(curRunningCmd.funName+" has wrong property config"+temp);
			}
		}
		
		private function setObj(obj:Object,s:Array,value:*):void{
			if(!s || s.length == 0)
				return ;
			var temp:String = s[0];
			//		if(obj.hasOwnProperty[temp]){
			if(obj.hasOwnProperty(temp) || !isNaN(obj[temp])){
				s.shift();
				if(s.length == 0){
					obj[temp] = value;
					return;
				}
				setObj(obj[temp],s,value);
			}else{
				throw new Error(curRunningCmd.funName+" has wrong property config"+temp);
			}
		}
		
		
		private function dump(arr:Object):void{
			for(var s:String in arr){
				if(arr[s] is Array){
					dump(arr[s]);
				}else{
					trace(s+":"+arr[s]);
				}
			}
		}
		
		//------------------------
		
		
		public function ifelse(sobj1:String,flag:String,sobj2:String,ifFuns:String,elseFuns:String,...vars):void{
			trace("ifelse");
			var obj1:* = getObject(sobj1);
			var obj2:* = getObject(sobj2);
			var isBool:Boolean;
			switch(flag){
				case "==":
					isBool = obj1 == obj2;
					break;
				case "!=":
					isBool = obj1 != obj2;
					break;
				case ">=":
					isBool = obj1 >= obj2;
					break;
				case "<=":
					isBool = obj1 <= obj2;
					break;
				case "<":
					isBool = obj1 < obj2;
					break;
				case ">":
					isBool = obj1 > obj2;
					break;
			}
			var cmds:Array = [];
			var code:CodeItemData;
			if(isBool){
				code = getCodeItemDataById(ifFuns);
			}else{
				code = getCodeItemDataById(elseFuns);
			}
			if(code){
				for(var j:int=0;j<vars.length;j++){
					var reg:RegExp = new RegExp("@var_"+(j+1),"\g");
					code.content = code.protoContent.replace(reg,vars[j]);
				}
				code.parseInArr(cmds);
				if(cmds){
					var nextIndex:int = stepIndex+1;
					for(var i:int=cmds.length-1,n:int=0;i>=n;i--){
						curRunnningCommands.splice(nextIndex,0,cmds[i]);
					}
				}
			}
			playNextCommand();
		}
		
		public function tween(target:String,time:Number=1,isFinishToNext:Boolean=true,...args):void{
			trace("tween "+isFinishToNext);
			var obj1:* = getObject(target);
			if(obj1 && obj1 is DisplayObject){
				var obj:Object = {time:time};
				for(var i:int=0;i<args.length;i++){
					var temp:String = args[i];
					var tempArr:Array = temp.split(":");
					if(tempArr.length != 2)
						continue;
					var key:String  = tempArr[0];
					var vaule:* = getObject(tempArr[1]);
					obj[key] = vaule;
				}
				obj.onComplete = function():void{
					if(isFinishToNext)
						playNextCommand();
				};
				Tweener.addTween(obj1,obj);
				if(!isFinishToNext)
					playNextCommand();
			}else{
				playNextCommand();
			}
		}
		
		public function wait(time:Number):void{
			trace("wait "+time);
			var obj:Object = {a:0};
			Tweener.addTween(obj,{a:1,time:time,onComplete:function():void{playNextCommand();}});
		}
		
		public function createButton(...args):void{
			trace("createButton "+args["name"]);
			var b:ButtonView = new ButtonView(this);
			var isToNext:Boolean;
			for(var i:int=0;i<args.length;i++){
				var temp:String = args[i];
				var tempArr:Array = temp.split(":");
				if(tempArr.length < 2)
					continue;
				var key:String  = tempArr[0];
				var vaule:* = getObject(temp.substring(temp.indexOf(":")+1));
				b[key] = vaule;
				if(key == "loadCmpToNext" && !vaule){
					isToNext = true;
				}
			}
			layer.addChild(b);
			if(isToNext)
				playNextCommand();
		}
		
		public function removeButton(name:String):void{
			trace("createButton "+name);
			var sp:ButtonView = layer.getChildByName(name) as ButtonView;
			if(sp)
				sp.destroy();
			playNextCommand();
		}
		
		public function pop(target:String,isEndToNext:Boolean=true,time:Number=1):void{
			var obj1:* = getObject(target);
			if(obj1 && obj1 is DisplayObject){
				obj1.visible = true;
				var baseX:Number = obj1.x;
				var baseY:Number = obj1.y;
				var w:Number = obj1.width;
				var h:Number = obj1.height;
				obj1.scaleX = obj1.scaleY = 0.1;
				Tweener.addTween(obj1,{scaleX:1,scaleY:1,time:time,onUpdate:function():void{
					obj1.x = baseX+w*(1-obj1.scaleX)/2;
					obj1.y = baseY+h*(1-obj1.scaleY)/2;
				},onComplete:function():void{
					obj1.x = baseX;
					obj1.y = baseY;
					if(isEndToNext)
						playNextCommand();
				},transition:"easeOutQuint"});
				if(!isEndToNext)
					playNextCommand();
			}else{
				playNextCommand();
			}
		}
		
		public function js(funName:String,...args):void{
			try{
				for(var i:Number=0;i<args.length;i++)
				{
					args[i] = this.getObject(args[i]);
				}
				trace("js"+args);
				if(ExternalInterface.available)
				{
					ExternalInterface.call(funName,args);
				}
			}catch(e:Error)
			{
				trace("js error"+e.message);
			}
			playNextCommand();
		}
		
		public function openWeb(url:String,window:String=null):void{
			navigateToURL(new URLRequest(url),window);
			playNextCommand();
		}
		
		public function foreach(list:String,acId:String,...vars):void{
			var obj:Object = getObject(list);
			var code:CodeItemData;
			var cmds:Array;
			if(obj && (obj.hasOwnProperty("length"))){
				for(var key:* in obj){
					code = getCodeItemDataById(acId);
					cmds = [];
					if(code){
						for(var j:int=0;j<vars.length;j++){
							var reg:RegExp = new RegExp("@var_"+(j+1),"\g");
							code.content = code.protoContent.replace(reg,obj[key][vars[j]]);
						}
						code.parseInArr(cmds);
						if(cmds){
							var nextIndex:int = stepIndex+1;
							for(var i:int=cmds.length-1,n:int=0;i>=n;i--){
								curRunnningCommands.splice(nextIndex,0,cmds[i]);
							}
						}
					}
				}
			}else{
				trace(list+" is not a array");
			}
			playNextCommand();
		}
		
		public function setCanControl(canControl:String):void{
			var _canControl:Boolean = getObject(canControl);
			if(_canControl){
				global.MOUSE_ENABLE = true;
				mask.graphics.clear();
			}else{
				global.MOUSE_ENABLE = false;
				mask.graphics.beginFill(1,0);
				mask.graphics.drawRect(0,0,qjPlayer.manager.boundsWidth,qjPlayer.manager.boundsHeight);
				mask.graphics.endFill();
				layer.setChildIndex(mask,layer.numChildren-1);
			}
			playNextCommand();
		}
		
	
		
		public function addEvent(target:String,eventType:String,eventActId:String,callFunName:String,...args):void{
			var obj:DisplayObject = getObject(target);
			if(obj){
				var code:CodeItemData = getCodeItemDataById(eventActId);
				var cmds:Array = [];
				for(var j:int=0;j<args.length;j++){
					var reg:RegExp = new RegExp("@var_"+(j+1),"\g");
					code.content = code.protoContent.replace(reg,args[j]);
				}
				code.parseInArr(cmds);
				if(cmds){
					var nextIndex:int = stepIndex+1;
					for(var i:int=cmds.length-1,n:int=0;i>=n;i--){
						curRunnningCommands.splice(nextIndex,0,cmds[i]);
					}
				}
			
				obj.addEventListener(eventType,eventHandle);
				var obj2:Function = getObject(callFunName);
				if(obj2 != null)
				{	
					obj2.apply(null,args);
				}
				
			}else{
				playNextCommand();
			}
		}
		
		private function eventHandle(e:Event):void{
			(e.target as DisplayObject).removeEventListener(e.type,eventHandle);
			
			playNextCommand();
		}
		
		public function addMark(...args):void{
			var markView:MarkView = new MarkView();
			var pan:Number = -1;
			var tilt:Number = -1;
			for(var i:int=0;i<args.length;i++){
				var temp:String = args[i];
				var tempArr:Array = temp.split(":");
				if(tempArr.length < 2)
					continue;
				var key:String  = tempArr[0];
				var vaule:* = getObject(temp.substring(temp.indexOf(":")+1));
				markView[key] = vaule;
				
				if(key == "pan"){
					pan = vaule;
				}
				if(key == "tilt"){
					tilt = vaule;
				}
			}
			markView.load();
			
			if(pan == -1 && tilt == -1)
			{
				pan =Number(qjPlayer.manager.getCursorPan().toFixed(2));
				tilt = Number(qjPlayer.manager.getCursorTilt().toFixed(2));
				
			}
			var customhotid:String = args["hotId"]?args["hotId"]:Math.random()+'';
			var hotspotData:HotspotDataImage = new HotspotDataImage(customhotid,null);
			hotspotData.location.pan = pan;
			hotspotData.location.tilt = tilt;
			hotspotData.isnew = true;
			qjPlayer.manager.currentPanoramaData.hotspotsData.push(hotspotData);
			
			qjPlayer.manager.insertHotspot(markView,hotspotData);
			playNextCommand();
		}
	}
}
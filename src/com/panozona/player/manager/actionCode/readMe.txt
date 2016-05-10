view打头的表示manager 
module打头的表示对应模块 
hot打头的表示热点 
imagebutton打头的表示imagebutton模块里的（为了方便找到对应的按钮）
acButton打头的表示是在actionCode里的


copy(view.pan,30);
	赋值命令，第一个参数表示key 
			第二个表示value值
call(module.MuseumItemModule.jumpItem,museum_53aa9e448246a,5);
	调用action命令
	第一个参数表示方法名
	后面跟的都是这个方法的参数
wait(1);
	等待命令 参数为等待到下一条命令的时间，单位是秒
tween(acButton.btn5,1,true,x:@getPx_imageButton.buttonPlayScript_center_0,y:@getPy_imageButton.buttonPlayScript_top_50);	
	缓动命令 第一个参数为缓动对象
			第二个参数为缓动时间 单位是秒
			第三个参数表示是否要执行完该缓动后再执行下一条命令
			后面跟的参数都是缓动的目标值，以key:value形式存在 
										@getPx_imageButton.buttonPlayScript_center_0
										@getPy_imageButton.buttonPlayScript_top_50
										这两个表示取到某个对象相对于容器的位置
											getPx 表示获取X值 getPy表示获取Y值
											imageButton.buttonPlayScript 这个表示某个对象
											center 表示相对位置
											0 表示偏移值
 pop(acButton.btn1,true,0.2);
 	冒泡命令
 		第一个参数为冒泡对象	
 		第二个参数表示是否要执行完该冒泡后再执行下一条命令	
 		第三个参数为冒泡时间 单位是秒	
 		
 js(funName,arg1);
 	js命令
 	第一个参数为js方法名
 	后面跟的参数都是这个JS方法需要的参数
 
 open(http://www.baidu.com,_blank)
 	打开网页命令
 	第一个参数为打开的网址
 	第二个参数为打开方式
 
 createButton(name:btn1,horizontal:center,vertical:middle,moveHorizontal:-50,moveVertical:-50,path:stop.png,click:ac122,loadCmpToNext:false,visible:false);
 	添加按钮命令，该按钮会被添加到actionCode的layer上
 	参数为KEY:VALUE形式
 		name:btn1   按钮名
 		horizontal:center,vertical:middle,moveHorizontal:-50,moveVertical:-50 相对位置
 		path:stop.png 按钮资源地址
 		click:ac122 按钮按下的事件 为actionCodeId
 		loadCmpToNext:false  表示是否要资源加载完再执行下一条命令	
 		
 removeButton(btn1);
 	删除按钮命令
 		第一个参数为删除对象的名字 与 createButton命令对应
 		
foreach(module.ImageButton.imageButtonData.buttons,ac123,id);
	循环命令
		第一个参数为一个数组
		第二个参数为循环中执行的actionCodeId
		后面跟的都是传递的参数
ifelse(@var_1,==,buttonPlayScript2,ac1234,null,@var_1);
	条件判断命令
	第一个参数为key
	第二个参数为判断符号
	第三个为value值
	第四个是条件满足的时候执行的actionCodeId
	第五个是条件不满足的时候执行的actionCodeId
	后面跟的都是传递的参数
	
	@var_1 @var_2这些是表示别的actionCode里传过来的参数，顺序从1开始
	
setCanControl(true)
	是否可操作命令
		第一个参数为是否可操作
 addEvent(view,panoramaLoaded,ac12345,view.loadPanoramaById,qjcl_6179);
 	注册事件命令，运行到该命令时，命令队列会停止，直到触发事件
 	第一个参数为注册事件的对象
	第二个参数为事件type
	第三个为事件触发的时候运行的actionCodeId
	第四个是注册完事件后调用的方法名
	后面跟的都是这个方法需要的参数
--------------------------for if举例-------------------
 		<actioncodes>  
 		 <actioncode id="ac1" >
			 foreach(module.ImageButton.imageButtonData.buttons,ac123,id);
		  </actioncode>
		   <actioncode id="ac123" >
			 ifelse(@var_1,==,buttonPlayScript2,ac1234,null,@var_1);
		  </actioncode>
		   <actioncode id="ac1234" >
			 call(module.ImageButton.setOpen,@var_1,false);
		  </actioncode>	
		</actioncodes> 
	
	有这么三个actionCode
	id="ac1" 的actionCode里执行了 foreach(module.ImageButton.imageButtonData.buttons,ac123,id);方法
			表示将module.ImageButton.imageButtonData.buttons里的元素的id值传递到id="ac123" 的actionCode里
			
	id="ac123" 的actionCode里执行了  ifelse(@var_1,==,buttonPlayScript2,ac1234,null,@var_1);方法
		表示判断 @var_1（此时已经被替换成module.ImageButton.imageButtonData.buttons[i].id了）是否==buttonPlayScript2 是的话
		执行id="ac1234" 的actionCode ，并且把 @var_1传递过去
		
	id="ac1234" 的actionCode里执行了	ImageButton.setOpen方法
	
	转化成伪代码就是：
	for(var i:int=0;i<module.ImageButton.imageButtonData.buttons.length;i++){
		var item = module.ImageButton.imageButtonData.buttons[i];
		if(item.id == "buttonPlayScript2"){
			ImageButton.setOpen(item.id,false);
		}
	}
------------------addEvent举例-----------
		<actioncodes>  
 		 <actioncode id="ac1" >
			 addEvent(view,panoramaLoaded,ac12345,view.loadPanoramaById,qjcl_6179);
			 copy(view.pan,90);
		  </actioncode>
		   <actioncode id="ac123" >
			tween(view,1,true,pan:20,fieldOfView:30);
		  </actioncode>
		</actioncodes> 
		
		当运行id="ac1" 的actionCode时
		执行addEvent命令 表示manager监听panoramaLoaded事件，并且跳转到qjcl_6179全景，当qjcl_6179全景加载完成时候，触发
			运行id="ac12345" 的actionCode ，完成缓动后回来执行copy命令

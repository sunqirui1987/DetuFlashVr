<StoryScript path="http://img.detuyun.cn/flash/qj_common/modules/storyscript/StoryScript.swf">
	   			<close path="stop.png" move="vertical:100,horizontal:0" align="horizontal:left,vertical:top" toolTips="点击停止自动导航"/>
	   			<scriptItem id="s1">
	   		 		<command commandName="hideOtherModule" params="hideOtherModule_names:StoryScript-ImageMap-Compass" /> 
	   				<command commandName="loadPanoThen" params="panoId:qjcl_6182"/>
	   				<command commandName="wait" params="wait_time:1" />
	   				<command commandName="advancedMoveToHotspotThen" params="hotId:hot_53aa9e448246a,speed:20"/>
	   				<command commandName="advancedMoveToViewThen" params="speed:100,fieldOfView:10"/>
	   				<command commandName="wait" params="wait_time:0.5" />
	   				<command commandName="jumpMuseumItem" params="museumId:museum_53aa9e448246a,autoCloseTime:10"/>
	   				<command commandName="wait" params="wait_time:0.5" />
	   				<command commandName="advancedMoveToViewThen" params="speed:100,fieldOfView:90"/>
	   				<command commandName="advancedMoveToHotspotThen" params="hotId:ap3240,speed:20"/>
	   				<command commandName="loadPanoThen" params="panoId:qjcl_6177"/>
	   				<command commandName="wait" params="wait_time:1" />
	   				<command commandName="advancedMoveToHotspotThen" params="hotId:hot_53db8df530685,speed:20"/>
	   				<command commandName="advancedMoveToViewThen" params="speed:100,fieldOfView:10"/>
	   				<command commandName="wait" params="wait_time:0.5" />
	   				<command commandName="jumpMuseumItem" params="museumId:museum_53db8df530685,autoCloseTime:30"/>
	   				<command commandName="wait" params="wait_time:1" />
	   				<command commandName="loadPano" params="panoId:qjcl_6182"/>
	   				
	   			</scriptItem>
	   		</StoryScript>
package com.panozona.modules.imagemap.model.structure
{
	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-8-11 下午1:19:41
	 * 功能描述:
	 */
	public class Tab
	{
		
		public var skinUrls:String = "";
		
		public var lineColor:Number = 0;
		
		public var lineShadowColor:Number = 0;
		
		public var uiXML:XML =
			<View width="284" height="270">
			  <Box x="0" y="0">
				<Tab selectedIndex="0" var="tab">
				  <Button label="地图" name="item0" skin="png.comp.button2" width="143" height="28" buttonMode="true" sizeGrid="5,5,5,5" labelColors="0xffffff,0xffffff,0xffffff,0xffffff"/>
				  <Button label="列表" name="item1" x="143" width="143" height="28" buttonMode="true" skin="png.comp.button2" sizeGrid="5,5,5,5" labelColors="0xffffff,0xffffff,0xffffff,0xffffff"/>
				</Tab>
				<ViewStack x="1" y="29" selectedIndex="0" var="viewStack">
				  <Box  name="item0" x="0" y="0" width="284" height="241">
					<Image  skin="png.comp.bg2" left="0" right="0" top="0" bottom="0" sizeGrid="5,5,5,5"/>
					<Box var="box"  x="0" y="30" width="284" height="211" />
				  </Box>
				  <Box name="item1" x="0" y="0" width="284" height="241">
					<Image  skin="png.comp.bg2" left="0" right="0" top="0" bottom="0" sizeGrid="5,5,5,5"/>
					<Panel var="panel" name="item1" x="5" y="30" width="274" height="208" vScrollBarSkin="png.comp.vscroll">
					  <List repeatX="1" var="list_all" spaceY="10">
						<Box name="render">
						  <Label name="label1" text="第一层" width="90" height="18" bold="true" color="0x666666"/>
						  <List name="list1" x="15" y="20" repeatX="3" spaceX="5" spaceY="5">
							<Box name="render" x="0" y="0" width="75" height="19">
							  <LinkButton name="linkButton1" label="label" labelColors="0x000000,0xff0000,0x00ff00,0x3e3e3e"/>
							</Box>
						  </List>
						</Box>
					  </List>
					</Panel>
				  </Box>
				</ViewStack>
				<Image skin="png.comp.bg3" x="3" y="31" width="278" sizeGrid="5,5,5,5" height="30"/>
				<ComboBox labels="label1,label2" skin="png.comp.combobox" x="7" y="34" var="cmb"/>
				<Label text="label" x="103" y="34" width="166" height="22" var="lab_hotName"/>
<Button var="btn_close" buttonMode="true" compId="35" skin="png.comp.btn_close2" x="0" y="0" layer="2" width="18" height="18" stateNum="1"/>
			  </Box>
			</View>;
		
		public function Tab()
		{
		}
	}
}
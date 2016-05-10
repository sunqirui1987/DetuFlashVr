<MuseumItemModule path="http://img.detuyun.cn/flash/qj_common/modules/museumItem/MuseumItem.swf">
	<item id="id1" panoId ="qjcl_6122" hotId="hot_53a91a567c19a" isOnlyShowPic="true" showItemUrl="http://fwhd151.img.detuyun.cn/flash/FlashHDMain.swf?xml=http://fwhd50.img.detuyun.cn/138785260752b8f33fa48c8/oper/52b8f33e25b18.xml&zzzxml=&chazi=10" citiaoUrl="http://www.baidu.com" jiangJieUrl="http://img.detu.com:6789/flash/qj_common/res/bg.mp3" title="北朝青釉仰覆莲花尊" info="北朝青釉仰覆莲花尊，1948年出土于河北省景县封氏墓。该尊器形硕大，庄严雄伟，做工精细，釉色青绿温润，是北齐瓷器中屈指可数的重器之一，是研究北朝瓷器及其装饰工艺不可多得的重要实物资料。现收藏于中国国家博物馆。" />
	<item id="id2" showItemUrl="http://fwhd151.img.detuyun.cn/flash/FlashHDMain.swf?xml=http://fwhd151.img.detuyun.cn/14024689795397fa7396a27/oper/S4_1_0124.xml" title="东汉陶船" info="东汉陶船" />
	<item id="id3" showItemUrl="http://fwhd151.img.detuyun.cn/flash/FlashHDMain.swf" title="西周晚期至春秋早期透雕龙形饰周晚期至春秋早期透雕龙形饰" info="daaasasas" />
	<source name="btn_close" baseUrl="qj_common/modules_img/museumItem/close_0ee521d.png" mouseOverUrl="qj_common/modules_img/museumItem/close-hover_e53af1e.png" />
	<source name="btn_citiao" baseUrl="qj_common/modules_img/museumItem/kancitiao.jpg" mouseOverUrl="qj_common/modules_img/museumItem/kancitiaoMouseOver.jpg" />
	<source name="btn_jiangjie" baseUrl="qj_common/modules_img/museumItem/jiangjieBase.jpg" mouseOverUrl="qj_common/modules_img/museumItem/jiangjieMouseOver.jpg" />
	<source name="btn_moveLeft" baseUrl="qj_common/modules_img/museumItem/leftBase.jpg" mouseOverUrl="qj_common/modules_img/museumItem/leftMouseOver.jpg" />
	<source name="btn_moveRight" baseUrl="qj_common/modules_img/museumItem/rightBase.jpg" mouseOverUrl="qj_common/modules_img/museumItem/rightMouseOver.jpg" />
	<source name="btn_scrollLeft" baseUrl="qj_common/modules_img/museumItem/L-1.png" mouseOverUrl="qj_common/modules_img/museumItem/L-2.png" />
	<source name="btn_scrollRight" baseUrl="qj_common/modules_img/museumItem/R-1.png" mouseOverUrl="qj_common/modules_img/museumItem/R-2.png" />
	
	<source name="btn_dressItemBuy" baseUrl="qj_common/modules_img/museumItem/bug.png" mouseOverUrl="qj_common/modules_img/museumItem/bug.png" />
	<source name="btn_dressItemInfo" baseUrl="qj_common/modules_img/museumItem/detail.png" mouseOverUrl="qj_common/modules_img/museumItem/detail.png" />
	
	<dressItem 
		id="did1" 
		infoWebUrl="http://www.baidu.com" 
		buyWebUrl="http://www.baidu.com" 
		showItemUrl="http://fwhd151.img.detuyun.cn/flash/FlashHDMain.swf?xml=http://fwhd50.img.detuyun.cn/138785260752b8f33fa48c8/oper/52b8f33e25b18.xml&zzzxml=&chazi=10">
		<title>
			<![CDATA[<font color='#393939' size='23'>  海宁皮革城 裘皮大衣意见 斗气受穷地区的地区</font>]]>
		</title>
		<info>
			<![CDATA[<br><font color='#cab373' size='19'>优雅小圆领<br>      </font><font color='#393939' size='13'>优雅小圆领优雅小圆领优雅小圆领优雅小圆领优雅小圆领优雅小圆领优雅小圆领优雅小圆领优雅小圆领</font><br><br><font color='#cab373' size='19'>优雅小圆领<br>      </font><font color='#393939' size='13'>优雅小圆领优雅小圆领优雅小圆领优雅小圆领优雅小圆领优雅小圆领优雅小圆领优雅小圆领优雅小圆领</font><br><br><font color='#cab373' size='19'>优雅小圆领<br>      </font><font color='#393939' size='13'>优雅小圆领优雅小圆领优雅小圆领优雅小圆领优雅小圆领优雅小圆领优雅小圆领优雅小圆领优雅小圆领</font><br><br><font color='#000000' size='14'> 促销价</font> <font color='#c40000' size='21'>￥1498.00</font><br><font color='#000000' size='14' face='微软雅黑'> 原价</font> <font color='#000000' size='14'>    ￥2608.00</font>]]>
		</info>
	</dressItem>
	
	<scroll backColor="#373737" borderColor="#000000" backAlpha="1" itemSize="width:200,height:100" height="110" gap="3" leftpadding="25"/>
</MuseumItemModule>
/**
	source 为所用到的图标资源
	item 表示一个展品信息 
		id 标识符，唯一
		showItemUrl 为高清地址或者3d地址 
		title 展品名称
		info 展品文字
		citiaoUrl 词条对应的地址 没有则不显示词条按钮
		jiangJieUrl 对应录音的地址
		isOnlyShowPic 为true时只显示图片
		
		panoId 该展品所在的全景ID
		hotId 该展品对应的热点ID
		picUrl 在列表中的图片
	
	scroll 表示滚动列表 没有则没有列表
		backColor 背景色
		borderColor 背景边框颜色
		backAlpha 背景透明度
		itemSize 列表里单个图片的大小
			width
			height
		height 列表高度
		gap 列表里图片之间的空间
		leftpadding 列表内容到屏幕边的距离（这个距离用来放左右两个按钮的图标）
		itemBackColor="#ffffff" 单元格背景色
		itemBackAlpha="1" 单元格透明度
				
			
*/
		
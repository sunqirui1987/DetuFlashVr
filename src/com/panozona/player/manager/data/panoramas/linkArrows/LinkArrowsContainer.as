package com.panozona.player.manager.data.panoramas.linkArrows
{
	import com.panosalado.view.ManagedChild;
	import com.panozona.player.manager.Manager;
	import com.panozona.player.manager.data.panoramas.PanoramaData;
	import com.panozona.player.manager.data.panoramas.tranceEffect.WalkAwardEffect;
	import com.panozona.player.manager.data.panoramas.tranceEffect.WalkAwardEffect2;
	import com.panozona.player.module.data.property.LngLat;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	
	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-3-18 上午9:55:34
	 * 功能描述:
	 */
	public class LinkArrowsContainer extends ManagedChild
	{
		
		private var manager:Manager;
		
		private var _updirect:Number=0;
		private var _oldpan:Number = -1;
		
		
		private var subchildsprite:Vector.<LinkArrow> = new Vector.<LinkArrow>();
		
		
		public function LinkArrowsContainer(manager:Manager)
		{
			this.manager = manager;
			
			//开始侦听
			this.addEventListener(Event.ENTER_FRAME,enterframeHandler);
			
			this.update();
			
			//设置
			if(ExternalInterface.available)
			{
				try{
					//加载完成的事件
					ExternalInterface.addCallback("FlashHD3DSetLinkArrowsPan",FlashHD3DSetLinkArrowsPan);
				}
				catch(e:Error){
					
				}
			}
		}
		public function FlashHD3DSetLinkArrowsPan(id:String,pan:Number):void
		{
			if(this.manager.currentPanoramaData != null)
			{
				
					for(var i:Number=0;i<subchildsprite.length;i++)	
					{
						var txtsprite:LinkArrow = subchildsprite[i] as LinkArrow;
						if(manager.currentPanoramaData.linkTo[i].id == id)
						{
							txtsprite.filters=  [new GlowFilter(0xFF0000,1,2,2,5)];
							var rotation:Number = txtsprite.rotationY + pan;
							txtsprite.rotationY = rotation; 
							txtsprite.x = Math.sin(rotation  * Math.PI / 180) * 100;
							txtsprite.z = Math.cos(rotation * Math.PI / 180) * 100;
						}
						else
						{
							txtsprite.filters=  [];
						}
				
					}
			}
		
		}
		
		private function enterframeHandler(e:Event):void
		{
			this.graphics.clear();
			this.graphics.beginFill(1,0);
			this.graphics.drawRect(0,0,1,1);
			this.graphics.endFill();
			return;
			
		}
		
		
		public function update():void	
		{
			//清空状态
			while(this.numChildren > 0)
			{
				var arrow:LinkArrow = getChildAt(0) as LinkArrow;
				if(arrow){
					if(arrow.hasEventListener(MouseEvent.CLICK)){
						arrow.removeEventListener(MouseEvent.CLICK,newobjClickHandler);
						arrow.removeEventListener(MouseEvent.MOUSE_OVER,newobjMouseOverHandler);
						arrow.removeEventListener(MouseEvent.MOUSE_OUT,newobjMouseOUTHandler);
					}
					arrow.destroy();
				}
				this.removeChildAt(0);
			}
			subchildsprite = new Vector.<LinkArrow>();
			if(!manager.currentPanoramaData &&　manager.currentPanoramaData.linkTo.length>0)
				return;
			
			for(var i:Number = 0; i < manager.currentPanoramaData.linkTo.length; i++)
			{
				var curData:PanoramaData = manager.managerData.getPanoramaDataById(manager.currentPanoramaData.linkTo[i].id);
				if(!curData)
					continue;
				arrow = new LinkArrow(curData.id,curData.title,manager.managerData.allPanoramasData.linkArrowDrawType,manager.currentPanoramaData.linkTo[i].isedit);
//				arrow.rotation =  curData.direction-manager.currentPanoramaData.direction;
//				arrow.x = Math.sin(arrow.rotation  * Math.PI / 180) * 100;//(this.width - obj.width) / 2;
//				arrow.y = -Math.cos(arrow.rotation * Math.PI / 180) * 100;
//				arrow.z = 0;
				
					
				var old:LngLat = manager.currentPanoramaData.lngLat;
				
				var my:LngLat = curData.lngLat;
				
				var rotation:Number = (getRotateAngle(old,my) - manager.currentPanoramaData.direction  + 360 + manager.currentPanoramaData.linkTo[i].pan )%360;
				if(manager.currentPanoramaData.linkTo[i].ignoredirect == 1)
				{
					rotation =  manager.currentPanoramaData.linkTo[i].pan;
				}
				
				arrow.rotationY = rotation; 
				arrow.x = Math.sin(rotation  * Math.PI / 180) * 100;
				arrow.z = Math.cos(rotation * Math.PI / 180) * 100;
				arrow.rotationX = -90;
				
				
				
				subchildsprite.push(arrow);
				
				this.addChild(arrow);
				arrow.buttonMode = true;
				arrow.useHandCursor = true;
				arrow.addEventListener(MouseEvent.CLICK,newobjClickHandler);
				arrow.addEventListener(MouseEvent.MOUSE_OVER,newobjMouseOverHandler);
				arrow.addEventListener(MouseEvent.MOUSE_OUT,newobjMouseOUTHandler);
				
			}
			
//						graphics.beginFill(0xFF0000,0.9);
//						graphics.drawCircle(0,0,10);
//						graphics.endFill();
						
//						graphics.beginFill(0xFF00ff,0.9);
//						graphics.drawRect(0,0,width,height);
//						graphics.endFill();
			
			if(lastViewData["pan"]){
				manager.renderAt(lastViewData["pan"],lastViewData["tilt"],lastViewData["fov"]);
			}
			
			this.filters = [new DropShadowFilter(4,45,0x000000,0.5,4,4,3)];
		}
		private function newobjMouseOverHandler(e:MouseEvent):void
		{
			
			var arrow:LinkArrow = e.currentTarget as LinkArrow;
			arrow.parent.setChildIndex(arrow,arrow.parent.numChildren -1);
		}
		private function newobjMouseOUTHandler(e:MouseEvent):void
		{
			
			
		}
		
		private var lastViewData:Object = new Object();
		
		private function newobjClickHandler(e:MouseEvent,... arg):void
		{
			e.preventDefault();
			var arrow:LinkArrow = e.currentTarget as LinkArrow;
			lastViewData["pan"]=manager.pan;
			lastViewData["tilt"]=manager.tilt;
			lastViewData["fov"]= manager.fieldOfView;
//			manager.addChild(new WalkAwardEffect2(manager,arrow.rotationY,function():void{
//				manager._prePanoramaDataObject=new Object();
//				manager._prePanoramaDataObject["pan"]=manager.pan;
//				manager._prePanoramaDataObject["tilt"]=manager.tilt;
//				manager._prePanoramaDataObject["fov"]= manager.fieldOfView;
//  				manager.loadPanoramaById(arrow.pid);
//			}));
			manager.loadPanoramaById(arrow.pid);
			
		}
		
		private function getRotateAngle(old:LngLat,my:LngLat):Number{
			var rotateAngle:Number = (Math.atan2(my.lng-old.lng,my.lat-old.lat)); 
//			if(my.lng >= old.lng){
//				if(my.lat >= old.lat){
//					
//				}else{
//					rotateAngle = Math.PI-rotateAngle;
//				}
//			}else{
//				if(my.lat >= old.lat){
//					rotateAngle = Math.PI*2-rotateAngle;
//				}else{
//					rotateAngle = Math.PI+rotateAngle;
//				}
//			}
	//		trace("d="+rotateAngle*180/Math.PI);
			return rotateAngle*180/Math.PI;
			
//			var d:Number = 0 ;
//			var lat_a:Number = old.lat*Math.PI/180;
//			var lng_a:Number = old.lng*Math.PI/180;
//			var lat_b:Number = my.lat*Math.PI/180;
//			var lng_b:Number = my.lng*Math.PI/180;
//			
//			
//			d=Math.sin(lat_a)*Math.sin(lat_b)+Math.cos(lat_a)*Math.cos(lat_b)*Math.cos(lng_b-lng_a);
//			d=Math.sqrt(1-d*d);
//			d=Math.cos(lat_b)*Math.sin(lng_b-lng_a)/d;
//			d=Math.asin(d)*180/Math.PI;
//			
//			//     d = Math.round(d*10000);
//			trace("d="+d);
//			return d;
		}
		
	}
}
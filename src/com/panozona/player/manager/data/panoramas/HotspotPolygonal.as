package com.panozona.player.manager.data.panoramas
{
	import com.panosalado.view.ManagedChild;
	import com.panozona.player.manager.Manager;
	import com.panozona.player.manager.data.panoramas.poly.PolyAssert;
	import com.panozona.player.manager.data.panoramas.poly.data.PolyStyleData;
	import com.panozona.player.manager.utils.loading.ILoadable;
	
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	
	
	public class HotspotPolygonal extends HotspotData implements ILoadable 
	{
		
		private var _data:String;
		private var _dataarr:Array;
		
		private var polystyle:PolyStyleData;
		private var polyassert:PolyAssert;
		private var polyassertbitmapdata:BitmapData = null;
		
		private var bgsprite:Sprite;
		private var container:ManagedChild;
		private var manager:Manager;
		private var lefttopx:Number=0;
		private var lefttopy:Number=0;
		
		
		private var assertpath:String;
		private var asserttype:String;
		private var assertextra:String;
		
		private var  polystyle_fillcolor:Number;
		private var  polystyle_fillalpha:Number;
		private var  polystyle_linealpha:Number;
		private var  polystyle_linecolor:Number;
		private var  polystyle_lineborder:Number;
		
		private var _maskData:String;
		
		private var maskSp:Sprite;
		private var maskDataArr:Array;
		
		
		public function HotspotPolygonal(id:String, data:String,style:String,assert:String,type:String,extra:String,_maskData:String=null){
			super(id);
			this._data = data;
			assertpath = assert;
			asserttype = type;
			assertextra = extra;
			
			this._maskData = _maskData;
			
			polystyle = new PolyStyleData(style);
			polystyle_fillcolor =polystyle.fillcolor;
			polystyle_fillalpha =polystyle.fillalpha;
			polystyle_linealpha =polystyle.linealpha;
			polystyle_linecolor =polystyle.linecolor;
			polystyle_lineborder =polystyle.lineborder;
			
			
			
		}
		
		
		
		public function render(_extraobj:Object):ManagedChild
		{
			
			
			manager = _extraobj as Manager;
			container = new ManagedChild();
			container.name = "hotspotpolygonal";
			
			if(this.bgsprite != null)
			{
				while(this.bgsprite.numChildren > 0)
				{
					this.bgsprite.removeChildAt(0);
				}
			}
			this.bgsprite = new Sprite();
			bgsprite.alpha = polystyle.bgalpha;
			container.addChild(this.bgsprite);
			
			if(_maskData){
				maskSp = new Sprite();
				container.addChild(maskSp);
				bgsprite.mask = maskSp;
				
				maskDataArr = [];
				var arr:Array=this._maskData.split("|");
				for(var j:Number = 0;j<arr.length;j++)
				{
					var tmp_xy:Array=arr[j].toString().split(",");
					maskDataArr.push(tmp_xy);
				}
				
				
			}
			
			if(polystyle.mouseenable == false)
			{
				bgsprite.mouseEnabled = false;
				this.handCursor = false;
			}
			
			
			//点积数组
			arr=this._data.split("|");
			_dataarr = new Array();
			for(j = 0;j<arr.length;j++)
			{
				tmp_xy=arr[j].toString().split(",");
				_dataarr.push(tmp_xy);
			}
			container._childobj.pan = this.location.pan;
			container._childobj.tilt = this.location.tilt ;
			container._childobj.distance = this.location.distance;
			
			manager.addHotspotEvent(container,this);
			container.x = 0;
			container.y = 0;
			container.z = 500;
			manager.hotspots[this] = container;
			manager.addChild(container);
			
		
			
			polyassert = new PolyAssert(manager,assertpath,asserttype,assertextra);
			if(polyassert.assertSprite != null) //存在嵌入对象
			{
				manager.addEventListener(Event.ENTER_FRAME, fillassertspritemovie, false, 0, true);
				manager.addEventListener(Event.RENDER, fillassertsprite, false, 0, true);
//				bgsprite.addEventListener(MouseEvent.CLICK,fillassertspritemovieMouseClickHandler);
				bgsprite.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
				bgsprite.addEventListener(MouseEvent.MOUSE_UP, handleMouseUP);
				if(maskSp)
					manager.addEventListener(Event.RENDER, fillvectormasksprite, false, 0, true);
			}
			else
			{
				//增加事件
				bgsprite.addEventListener(MouseEvent.MOUSE_OVER,bgspriteMouseOverHandler);
				bgsprite.addEventListener(MouseEvent.MOUSE_OUT,bgspriteMouseOutHandler);
				manager.addEventListener(Event.RENDER, fillvectorsprite, false, 0, true);
				if(maskSp)
					manager.addEventListener(Event.RENDER, fillvectormasksprite, false, 0, true);
			}

			return null;
		
		}
		
		
		
		private var _mousepoint:Point = new Point();
		private function handleMouseDown(e:MouseEvent):void {
			_mousepoint = new Point(e.stageX,e.stageY);
		}
		
		private function handleMouseUP(e:MouseEvent):void {
			var upmousepoint:Point = new Point(e.stageX,e.stageY);
			
			if(Math.abs(upmousepoint.x - _mousepoint.x) < 2 && Math.abs(upmousepoint.y - _mousepoint.y) < 2)
			{
				if(polyassert.assertSprite != null) //存在嵌入对象
				{
					polyassert.assertSprite.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
				}
			}
		}
		
		private function fillassertspritemovieMouseClickHandler(e:MouseEvent):void
		{
			if(polyassert.assertSprite != null) //存在嵌入对象
			{
				polyassert.assertSprite.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			}
		}
		
		/**
		 *  
		 *   线条框选类对象
		 * 
		 * **/
		
		private function bgspriteMouseOverHandler(e:MouseEvent):void
		{
			  polystyle_fillcolor =polystyle.fillcolorover;
			  polystyle_fillalpha =polystyle.fillalphaover;
			  polystyle_linealpha =polystyle.linealphaover;
			  polystyle_linecolor =polystyle.linecolorover;
			  polystyle_lineborder =polystyle.lineborderover;
			  
			  fillvectorsprite();
		}
		
		private function bgspriteMouseOutHandler(e:MouseEvent):void
		{
			polystyle_fillcolor =polystyle.fillcolor;
			polystyle_fillalpha =polystyle.fillalpha;
			polystyle_linealpha =polystyle.linealpha;
			polystyle_linecolor =polystyle.linecolor;
			polystyle_lineborder =polystyle.lineborder;
			
			fillvectorsprite();
		}
	
		//填充遮罩
		private function fillvectormasksprite(e:Event = null):void
		{
			
			maskSp.graphics.clear();
			
			var vector2darr:Array = getxyz_list(maskDataArr);
			if(vector2darr == null)
			{
				maskSp.graphics.clear();
				return;
			}
			
			//设置线条起点 
			var zobj:Point = vector2darr[0] as Point;
			if(zobj == null)
			{
				maskSp.graphics.clear();
				return;
			}
			var zx:Number = zobj.x;
			var zy:Number = zobj.y;
			
			lefttopx = zx;
			lefttopy = zy;
			//定义线条类型 
			
			maskSp.graphics.beginFill(polystyle_fillcolor,polystyle_fillalpha);
			maskSp.graphics.moveTo(zx,zy);
			
			var ismodel:Number=0;
			for(var i:Number = 0;i<vector2darr.length;i++)
			{
				var mobj:Point =vector2darr[i] as Point;
				if(mobj == null)
				{
					//continue;
					maskSp.graphics.clear();
					return;
				}
				
				
				var xx:Number = mobj.x;
				var yy:Number = mobj.y;
				
				
				maskSp.graphics.lineStyle(polystyle_lineborder,polystyle_linecolor,polystyle_linealpha);
				maskSp.graphics.lineTo(xx,yy);
				if(lefttopx > xx )
				{
					lefttopx = xx;
				}
				if(lefttopy > yy )
				{
					lefttopy = yy;
				}
			}
			maskSp.graphics.endFill();
			
		}
	
		//填充框选
		private function fillvectorsprite(e:Event = null):void
		{
			
			bgsprite.graphics.clear();
			
			var vector2darr:Array = getxyz_list(_dataarr);
			if(vector2darr == null)
			{
				bgsprite.graphics.clear();
				return;
			}

			//设置线条起点 
			var zobj:Point = vector2darr[0] as Point;
			if(zobj == null)
			{
				bgsprite.graphics.clear();
				return;
			}
			var zx:Number = zobj.x;
			var zy:Number = zobj.y;
		
			lefttopx = zx;
			lefttopy = zy;
			//定义线条类型 
			
			bgsprite.graphics.beginFill(polystyle_fillcolor,polystyle_fillalpha);
			bgsprite.graphics.moveTo(zx,zy);

			var ismodel:Number=0;
			for(var i:Number = 0;i<vector2darr.length;i++)
			{
				var mobj:Point =vector2darr[i] as Point;
				if(mobj == null)
				{
					//continue;
					bgsprite.graphics.clear();
					return;
				}

				
				var xx:Number = mobj.x;
				var yy:Number = mobj.y;
				

				bgsprite.graphics.lineStyle(polystyle_lineborder,polystyle_linecolor,polystyle_linealpha);
				bgsprite.graphics.lineTo(xx,yy);
				if(lefttopx > xx )
				{
					lefttopx = xx;
				}
				if(lefttopy > yy )
				{
					lefttopy = yy;
				}
			}
			bgsprite.graphics.endFill();
			
		}
		
		
		/**
		 *  
		 *  嵌入框选类对象
		 * 
		 */
		private function fillassertspritemovie(e:Event = null):void
		{
			if(polyassert.assertSprite != null )
			{
				var sw:Number = (polyassert.assertSprite as Object).sw;
				var sh:Number = (polyassert.assertSprite as Object).sh;
				if(polyassertbitmapdata == null && sw != 0 && sh != 0 )
				{
					polyassertbitmapdata = new BitmapData(sw,sh,true,0);
				}
				if(polyassertbitmapdata != null)
				{
					polyassertbitmapdata.fillRect(polyassertbitmapdata.rect, 0);
					polyassertbitmapdata.draw(polyassert.assertSprite);
				}
			}
		}
		
		private function fillassertsprite(e:Event = null):void
		{
		
			bgsprite.graphics.clear();
			var dataarr:Array = _dataarr.slice(0);
			if(dataarr.length != 4)
			{
				return;
			}
			/*
		  trace("0 dataarr"+dataarr);
		  
			//	先按Y排序最后两个
			dataarr = dataarr.sort (function (_a:Array, _b:Array):Number {return Number(_a[1]) <  Number(_b[1]) ? 1 : -1;});
			//再对比第一第二个的X轴
			if(dataarr[0][0]> dataarr[1][0] )
			{
				var tmp:Number = dataarr[0][0];
				dataarr[0][0] = dataarr[1][0];
				dataarr[1][0] = tmp;
			
			}
			trace("1 dataarr"+dataarr);
			//再对比第三第四个的X轴
			if(dataarr[2][0] > dataarr[3][0] )
			{
				var tmp:Number = dataarr[2][0];
				dataarr[2][0] = dataarr[3][0];
				dataarr[3][0] = tmp;
			}
			
			trace("2 dataarr"+dataarr);
		*/
			
			var vector2darr:Array = new Array();
			for (var j:Number = 0; j <dataarr .length; j++) 
			{
				var pan:Number =dataarr[j][0];
				var tilt:Number =  dataarr[j][1];
				var p:Point = this.getPoint(pan,tilt);
				if( p == null)
				{
					return ;
				}
				vector2darr.push(p);
			}
			
		

			
			

			if(vector2darr.length == 4 && vector2darr[0] != null &&   vector2darr[1] != null &&    vector2darr[2] != null &&    vector2darr[3] != null )
			{
	
				if(polyassertbitmapdata != null)
				{
					var positionvector2darr:Array =vector2darr;
					//drawPlane(this.graphics, myBitmapData, topLeft, topRight, bottomLeft, bottomRight); 
					/*
					 1      2
					 4      3
					 */
					var bool :Boolean =	drawPlane(bgsprite.graphics, polyassertbitmapdata, positionvector2darr[0],  positionvector2darr[1],  positionvector2darr[3], positionvector2darr[2]);
				
					if(bool == false)
					{
						/*
						1      4
						2      3
						*/
						//调整重绘
						bool = drawPlane(bgsprite.graphics, polyassertbitmapdata, positionvector2darr[0],  positionvector2darr[1],  positionvector2darr[2], positionvector2darr[3]);
					}
				}
			}
			/*
			for(var i:Number = 0 ;i < vector2darr.length ; i++)
			{
				var color:Number = 0x000000;
				if( i == 1)
				{
				   color = 0x0000FF;
				}
				if( i == 2)
				{
					color = 0x00FFFF;
				}
				if( i == 3)
				{
					color = 0xFFFFFF;
				}
				bgsprite.graphics.lineStyle(1, color, 1);
				bgsprite.graphics.drawCircle(vector2darr[i].x, vector2darr[i].y,5);
			}
			*/
			bgsprite.graphics.endFill();
		}
		
		
		
		
		protected function getPoint(pan:Number,tilt:Number):Point
		{
			
			var x:Number = 0, y:Number= 0;
			var a:Hotpotda = new Hotpotda(0,0,-100);
			var tiltpi:Number = -tilt * Math.PI / 180;
			var panpi:Number  = -pan * Math.PI / 180
			
			
			a.i(tiltpi);
			a.j(panpi);
			
			a.j(manager.pan* Math.PI / 180);
			a.i(manager.tilt * Math.PI / 180);
			
			var flocallength:Number =   manager.perspectiveProjection.focalLength;
			if(0.1 > a.l.a)
			{
				var scalenum:Number =   -flocallength / a.l.a; 
				x =   a.l.x * scalenum;
				y =   a.l.y * scalenum;
			}
			else
			{
				//trace("SSS");
				return null;
			}
			
			if(x <= -8000  || x > 8000 || y <= -8000  || y > 8000  )
			{
				//trace("AAA");
				return null;
			}
			
			
			
			
			var obj:Point=new Point();
			obj.x =x;
			obj.y = y;
			
			return obj;
		}
		
		
		
		private function drawPlane(graphics:Graphics, bitmap:BitmapData, p1:Point, p2:Point, p3:Point, p4:Point) :Boolean {
			var pc:Point = getIntersection(p1, p4, p2, p3); // Central point
			

			if (!Boolean(pc)) return false;
			
			
			var ll1:Number = Point.distance(p1, pc);
			var ll2:Number = Point.distance(pc, p4);
			
			
			var lr1:Number = Point.distance(p2, pc);
			var lr2:Number = Point.distance(pc, p3);
			
	
			var f:Number = (ll1 + ll2) / (lr1 + lr2);
			
			
			graphics.beginBitmapFill(bitmap, null, false, true);
			
			graphics.drawTriangles(
				Vector.<Number>([p1.x, p1.y, p2.x, p2.y, p3.x, p3.y, p4.x, p4.y]),
				Vector.<int>([0,1,2, 1,3,2]),
				Vector.<Number>([0,0,(1/ll2)*f, 1,0,(1/lr2), 0,1,(1/lr1), 1,1,(1/ll1)*f]) // Magic
			);
			
			return true;
		}
		
		private function getIntersection(p1:Point, p2:Point, p3:Point, p4:Point): Point {

			
			var a1:Number = p2.y - p1.y;
			var b1:Number = p1.x - p2.x;
			var a2:Number = p4.y - p3.y;
			var b2:Number = p3.x - p4.x;
			
			var denom:Number = a1 * b2 - a2 * b1;
			if (denom == 0) return null;
			
			var c1:Number = p2.x * p1.y - p1.x * p2.y;
			var c2:Number = p4.x * p3.y - p3.x * p4.y;
			
			var p:Point = new Point((b1 * c2 - b2 * c1)/denom, (a2 * c1 - a1 * c2)/denom);
			
			if (Point.distance(p, p2) > Point.distance(p1, p2)) return null;
			if (Point.distance(p, p1) > Point.distance(p1, p2)) return null;
			if (Point.distance(p, p4) > Point.distance(p3, p4)) return null;
			if (Point.distance(p, p3) > Point.distance(p3, p4)) return null;
			
			return p;
		}

		
		
		protected function getxyz_list(dataarr:Array):Array
		{
			var flocallength:Number =   manager.perspectiveProjection.focalLength;
			var x:Number = 0, y:Number= 0;

			var vectorarr:Array = new Array();
			
			var listdaarr:Array = new Array();
			
			for (var j:Number = 0; j < dataarr.length; j++) 
			{
				var pan:Number =dataarr[j][0];
				var tilt:Number =  dataarr[j][1];
				
				var a:Hotpotda = new Hotpotda(0,0,-100);
				var tiltpi:Number = -tilt * Math.PI / 180;
				var panpi:Number  = -pan * Math.PI / 180;
					
				a.i(tiltpi);
				a.j(panpi);
				
				a.j(manager.pan* Math.PI / 180);
				a.i(manager.tilt * Math.PI / 180);
				listdaarr.push(a.ha());
			}

			var tb:Number = Math.atan2(manager.boundsWidth / 2 , flocallength);
			var th:Number = Math.atan2(manager.boundsHeight / 2 , flocallength);
			var tg:Number = Math.sin(tb);
			var tf:Number = Math.sin(th);
			tb = Math.cos(tb);
			th = Math.cos(th);
			
			var Ic:Hotpotda = new Hotpotda(0,0,-1);
			var Jc:Hotpotda = new Hotpotda(tb, 0, -tg);
			var Kc:Hotpotda = new Hotpotda( - tb, 0, -tg);
			var Lc:Hotpotda = new Hotpotda(0, th, -tf);
			var Mc:Hotpotda = new Hotpotda(0, -th, -tf);

			var tmp_listdaarr:Array = listdaarr;
			tmp_listdaarr = mb(tmp_listdaarr, Ic);
			tmp_listdaarr = mb(tmp_listdaarr, Jc);
			tmp_listdaarr = mb(tmp_listdaarr, Kc);
			tmp_listdaarr = mb(tmp_listdaarr, Lc);
			listdaarr = tmp_listdaarr = mb(tmp_listdaarr, Mc);
		
			for (var i:Number = 0; i <listdaarr.length; i++)
			{
				 a = listdaarr[i] as  Hotpotda;
				 if(0.1 > a.l.a)
				 {
					 var scalenum:Number =   -flocallength / a.l.a; 
					 x =   a.l.x * scalenum;
					 y =   a.l.y * scalenum;
				 }
				 else
				 {
					  x = 0;
					  y = 0;
					 return null;
				 }
				 
				 var obj:Point=new Point();
				 obj.x =x;
				 obj.y = y;
		 
				 if(x <= -80000  || x > 80000 || y <= -80000  || y > 80000  )
				 {
					 obj  = null;
				 }

				 vectorarr.push(obj);
			}
			
			return vectorarr;
		}
		
	
		private function mb(listdata:Array, hotpotda:Hotpotda):Array 
		{
			if (0 == listdata.length)
			{
				return listdata;
			}
			var o:Array = new Array();
			var firstval:Number = hotpotda.M(listdata[0]) - 0;
			for (var i:Number = 0; i < listdata.length; i++) 
			{
				var currindex:Number = i;
				var nextindex:Number = i + 1;
				if(nextindex == listdata.length)
				{
					nextindex = 0
				}
				var nextval:Number = hotpotda.M(listdata[nextindex]) - 0;
				if (0 <= firstval && 0 <= nextval) 
				{
					o.push(listdata[currindex]);
				}
				else if (0 <= firstval || 0 <= nextval)
				{
					var tmpe:Number = nextval / (nextval - firstval);
					if(tmpe < 0)
					{
						tmpe = 0;
					}
					if(tmpe > 1)
					{
						tmpe = 1;
					}
					var tmpda:Hotpotda = new Hotpotda(0,0,0);
					tmpda.na(listdata[currindex], listdata[nextindex], tmpe);
					o.push(listdata[currindex]);
					o.push(tmpda);
				}
				firstval = nextval
			}
			return o
		}

	
		//返回内部对象
		public function get path():String {

			return "hotspotPolygonal__innerDisplayObj";	
			
		}
		
		
	}
	

}
package  com.panosalado.utils
{
	

	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.utils.getDefinitionByName;	
	
	public class  SkewTransform {
		
		//切割成多个三角形
		private var _container : DisplayObjectContainer;
		private var _sp : Sprite;
		private var _w : Number;
		private var _h : Number;
		private var _sMat : Matrix;
		private var _tMat : Matrix;
		private var _xMin, _xMax, _yMin, _yMax : Number;
		private var _hP : Number;
		private var _vP : Number;
		private var _hsLen : Number;
		private var _vsLen : Number;
		private var _dotList : Array;
		private var _pieceList : Array;
		private var _imageBitmap : BitmapData;
		
		/* Constructor
		*
		* @param mc MovieClip :   图片容器
		* @param imageLink String : 图片库连接名
		* @param vP Number : 横向切割刀数
		* @param hP Number : 纵向切割刀数
		*/
		public function SkewTransform(container : DisplayObjectContainer, imageLink : String, vP : Number, hP : Number) {
			_container = container;
			var classRef : Class = getDefinitionByName(imageLink) as Class;
			_imageBitmap = BitmapData(new classRef(0, 0));
			_vP = vP > 20 || vP < 0 ? 2 : vP;
			_hP = hP > 20 || hP < 0 ? 2 : hP;
			_w = _imageBitmap.width;
			_h = _imageBitmap.height;
			init();
		}
		
		private function init() : void {
			_sp = new Sprite;
			_container.addChild(_sp);
			_dotList = [];
			_pieceList = [];
			var ix : Number;
			var iy : Number;
			var w2 : Number = _w / 2;
			var h2 : Number = _h / 2;
			_xMin = _yMin = 0;
			_xMax = _w;
			_yMax = _h;
			_hsLen = _w / (_hP + 1);
			//纵向每块的高
			_vsLen = _h / (_vP + 1);
			//横向每块的宽（根据精度来分割三角形）
			var x : Number, y : Number;
			for (ix = 0;ix < _vP + 2; ix++) {
				//分割的顶点集合
				for (iy = 0;iy < _hP + 2; iy++) {
					x = ix * _hsLen;
					y = iy * _vsLen;
					_dotList.push({x:x, y:y, sx:x, sy:y});
				}
			}
			for (ix = 0;ix < _vP + 1; ix++) {
				//分割成的三角形的顶点集合
				for (iy = 0;iy < _hP + 1; iy++) {
					_pieceList.push([_dotList[iy + ix * (_hP + 2)], _dotList[iy + ix * (_hP + 2) + 1], _dotList[iy + (ix + 1) * (_hP + 2)]]);
					_pieceList.push([_dotList[iy + (ix + 1) * (_hP + 2) + 1], _dotList[iy + (ix + 1) * (_hP + 2)], _dotList[iy + ix * (_hP + 2) + 1]]);
				}
			}
			render();
			//渲染
		}
		
		/* setTransform
		*
		* @param x0,y0 矩形左上控制点
		* @param x1,y1 矩形右上控制点
		* @param x2,y2 矩形右下控制点
		* @param x3,y4 矩形左下控制点
		*
		*/
		public function setTransform(x0 : Number, y0 : Number, x1 : Number, y1 : Number, x2 : Number, y2 : Number, x3 : Number, y3 : Number) : void {
			var w : Number = _w;
			var h : Number = _h;
			var dx30 : Number = x3 - x0;
			var dy30 : Number = y3 - y0;
			var dx21 : Number = x2 - x1;
			var dy21 : Number = y2 - y1;
			var l : Number = _dotList.length;
			while (--l > -1) {
				var point : Object = _dotList[l];
				var gx = (point.x - _xMin) / w;
				var gy = (point.y - _yMin) / h;
				var bx = x0 + gy * (dx30);
				var by = y0 + gy * (dy30);
				point.sx = bx + gx * ((x1 + gy * (dx21)) - bx);
				point.sy = by + gx * ((y1 + gy * (dy21)) - by);
			}
			render();
		}
		
		private function render() : void {
			var t : Number;
			var p0, p1, p2 : Object;
			var c : Sprite = _sp;
			var a : Array;
			c.graphics.clear();
			_sMat = new Matrix();
			_tMat = new Matrix();
			var l : Number = _pieceList.length;
			while (--l > -1) {
				a = _pieceList[l];
				p0 = a[0];
				p1 = a[1];
				p2 = a[2];
				var x0 : Number = p0.sx;
				var y0 : Number = p0.sy;
				var x1 : Number = p1.sx;
				var y1 : Number = p1.sy;
				var x2 : Number = p2.sx;
				var y2 : Number = p2.sy;
				var u0 : Number = p0.x;
				var v0 : Number = p0.y;
				var u1 : Number = p1.x;
				var v1 : Number = p1.y;
				var u2 : Number = p2.x;
				var v2 : Number = p2.y;
				_tMat.tx = u0;
				_tMat.ty = v0;
				_tMat.a = (u1 - u0) / _w;
				_tMat.b = (v1 - v0) / _w;
				_tMat.c = (u2 - u0) / _h;
				_tMat.d = (v2 - v0) / _h;
				_sMat.a = (x1 - x0) / _w;
				_sMat.b = (y1 - y0) / _w;
				_sMat.c = (x2 - x0) / _h;
				_sMat.d = (y2 - y0) / _h;
				_sMat.tx = x0;
				_sMat.ty = y0;
				_tMat.invert();
				_tMat.concat(_sMat);
				c.graphics.beginBitmapFill(_imageBitmap, _tMat, false, false);
				c.graphics.moveTo(x0, y0);
				c.graphics.lineTo(x1, y1);
				c.graphics.lineTo(x2, y2);
				c.graphics.endFill();
			}
		}
	}
}


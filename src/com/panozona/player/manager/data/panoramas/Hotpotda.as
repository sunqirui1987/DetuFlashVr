package com.panozona.player.manager.data.panoramas
{
	public class Hotpotda
	{
		
		public var l:Object = new Object();
		
		
		public function Hotpotda(g:Number, o:Number, s:Number):void {
			l.x = g;
			l.y = o;
			l.a = s
		};
		public function toString():String {
			return "(" + l.x + "," + l.y + "," + l.a + ")"
		};
		
		public function i(g:Number):void {
			var o:Number = Math.sin(g),
				g:Number = Math.cos(g),
				s:Number = l.y,
				x:Number = l.a;
			l.y = g * s - o * x;
			l.a = o * s + g * x;
			
	
		};

		public function j(g:Number):void {
			var o:Number = Math.sin(g),
				g:Number = Math.cos(g),
				s:Number = l.x,
				x:Number = l.a;
			l.x = g * s + o * x;
			l.a = -o * s + g * x
		};
		public function F(g:Number):void {
			var o:Number = Math.sin(g),
				g:Number = Math.cos(g),
				s:Number = l.x,
				x:Number = l.y;
			l.x = g * s - o * x;
			l.y = o * s + g * x
		};
		public function ha():Hotpotda {
			return new Hotpotda(l.x, l.y, l.a)
		};
		public function length():Number{
			return Math.sqrt(l.x * l.x + l.y * l.y + l.a * l.a)
		};
		public function M(g:Hotpotda):Number {
			return l.x * g.l.x + l.y * g.l.y + l.a * g.l.a
		};
		public function X(g:Number, o:Number):void {
			var s:Number = 0;
			s = Math.cos(o * Math.PI / 180);
			l.x = s * Math.sin(g * Math.PI / 180);
			l.y = Math.sin(o * Math.PI / 180);
			l.a = s * Math.cos(g * Math.PI / 180)
		};
		public function na(g:Hotpotda, o:Hotpotda, s:Number):void {
			l.x = g.l.x * s + o.l.x * (1 - s);
			l.y = g.l.y * s + o.l.y * (1 - s);
			l.a = g.l.a * s + o.l.a * (1 - s)
		}
	}
}
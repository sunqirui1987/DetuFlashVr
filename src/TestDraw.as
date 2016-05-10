package
{
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;

	/**
	 * author：啊星
	 * E-mail: 52305556@163.com
	 * 创建时间：2014-9-3 下午2:58:53
	 * 功能描述:
	 */
	[SWF( width = "1200", height = "650", backgroundColor = "#3e3e3e", frameRate = '60' )]
	public class TestDraw extends Sprite
	{
		public function TestDraw()
		{
			
			var obj:Sprite = new Sprite();
			obj.graphics.clear();
			var graphics:Graphics = obj.graphics;
			
			graphics.lineStyle(3,0x666666,1);
			graphics.beginFill(0xf6f6f6,0.7);
			graphics.moveTo(-35,-20);
			graphics.lineTo(0,-20);
			graphics.lineTo(0,-43);
			graphics.curveTo(2,-45,50,0);
			graphics.lineTo(0,45);
			graphics.lineTo(0,20);
			graphics.lineTo(-35,20);
			graphics.lineTo(-35,-20);
			graphics.endFill();
			obj.rotation = -90;
			
			obj.filters = [dropShadowFilter];
			obj.x = 500;
			obj.y = 400;
			
			
			
			obj.addEventListener(MouseEvent.MOUSE_OVER,objmouseoverhandler);
			obj.addEventListener(MouseEvent.MOUSE_OUT,objmouseouthandler);
			
			addChild(obj);
			
			var rounderObject:Shape = new Shape();
			rounderObject.x = 200;
			rounderObject.y = 400;
			rounderObject.graphics.lineStyle(3,0x666666,1);
			rounderObject.graphics.beginFill(0xf6f6f6,0.7);
			rounderObject.graphics.moveTo(-35,-20);
			rounderObject.graphics.lineTo(0,-20);
			rounderObject.graphics.lineTo(0,-42);
			rounderObject.graphics.curveTo(2,-45,4,-45);
			rounderObject.graphics.lineTo(48,-2);
			rounderObject.graphics.curveTo(50,0,48,2);
			rounderObject.graphics.lineTo(4,45);
			rounderObject.graphics.curveTo(2,45,0,42);
			rounderObject.graphics.lineTo(0,20);
			rounderObject.graphics.lineTo(-35,20);
			rounderObject.graphics.lineTo(-35,-20);
			rounderObject.graphics.endFill();
			rounderObject.rotation = -90;
			this.addChild(rounderObject);
		}
		
		private var dropShadowFilter:DropShadowFilter = new DropShadowFilter(4,45,0x000000,0.5);
		
		private function objmouseoverhandler(e:MouseEvent):void
		{
			e.preventDefault();
			
			var obj:Sprite = e.target as Sprite;
			
			
			var gr:GlowFilter = new GlowFilter(0x0033ff,0.8,10,10);
			//		obj.filters = [bevel,bevel2,gr];
			//		obj.filters = [gr];
			obj.filters = [dropShadowFilter,gr];
		}
		private function objmouseouthandler(e:MouseEvent):void
		{
			e.preventDefault();
			
			var obj:Sprite = e.target as Sprite;
			
			obj.filters = [dropShadowFilter];
			//		obj.filters = [bevel,bevel2];
			//		obj.filters = [];
		}
	}
}
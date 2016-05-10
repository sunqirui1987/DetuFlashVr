/*
 OuWei Flash3DHDView 
*/
package  com.panozona.modules.panoramaTitleAndDes.model.structure{
	
	import caurina.transitions.Equations;
	
	import com.panozona.player.module.data.property.Align;
	import com.panozona.player.module.data.property.Move;
	import com.panozona.player.module.data.property.Size;
	import com.panozona.player.module.data.property.Transition;
	import com.panozona.player.module.data.property.Tween;
	
	public class Window{
		
		public const align:Align = new Align(Align.RIGHT, Align.TOP);
		public const move:Move = new Move(-20, 20);
		public const size:Size = new Size(400, 300);
		
		public var alpha:Number = 1.0;
		
		public var open:Boolean = true;
		public var onOpen:String = null; // actions executed on window visibility change
		public var onClose:String = null;
		
		public const openTween:Tween = new Tween(Equations.easeNone, 0.5);
		public const closeTween:Tween = new Tween(Equations.easeNone, 0.5);
		public const transition:Transition = new Transition(Transition.SLIDE_RIGHT);
		
		public var istext:Boolean=false;
	}
}
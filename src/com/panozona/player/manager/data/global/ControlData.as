/*
 OuWei Flash3DHDView 
*/
package com.panozona.player.manager.data.global{
	
	import com.panosalado.model.*;
	
	public class ControlData {
		
		public var mouseWheelTrap:Boolean=true;
		
		public var keyboardCameraData:KeyboardCameraData = new KeyboardCameraData();
		public var inertialMouseCameraData:InertialMouseCameraData = new InertialMouseCameraData();
		public var arcBallCameraData:ArcBallCameraData = new ArcBallCameraData();
		public var scrollCameraData:ScrollCameraData = new ScrollCameraData();
		public var autorotationCameraData:AutorotationCameraData = new AutorotationCameraData();
		public var simpleTransitionData:SimpleTransitionData = new SimpleTransitionData();
	}
}
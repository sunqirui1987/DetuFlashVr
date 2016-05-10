
package com.panosalado.view {
	
	import flash.geom.Vector3D;
	import flash.geom.Matrix3D;
	
	public interface IManagedChild {
		
		function get invalid():Boolean
		function set invalid(value:Boolean):void
		
		function get decomposition():Vector.<Vector3D>
		function set decomposition(value:Vector.<Vector3D>):void
		
		function get matrix3D():Matrix3D
		function set matrix3D(value:Matrix3D):void
	}
}
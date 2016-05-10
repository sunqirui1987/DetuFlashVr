/*
 OuWei Flash3DHDView 
*/
package com.panosalado.utils {
	
	public class Inertion {
				
		private var _max:Number;
		private var _increment:Number; 
		private var _friction:Number;
		
		private var _value:Number;
	
		public function Inertion( maxValue:Number, incrementValue:Number, friction:Number) {
			_value = 0;
			_max = maxValue;
			_increment = incrementValue;
			_friction  = friction;
		}		
		
		public function increment():Number{			
			if (_value + _increment <=  _max) _value += _increment;
			return _value;
		}
		
		public function decrement():Number {
			if (_value - _increment >= -_max) _value -= _increment;
			return _value;
		}		
	
		public function aimMax():Number {
			if (_value + _increment <=  _max) _value += _increment;
			if (_value - _increment >= -_max) _value -= _increment;			
			return _value;
		}		
	
		public function aimZero():Number {
			if (_value < 0) {
				_value = (_value + _friction > 0) ? 0: _value + _friction ;
			}else if (_value > 0) {
				_value = (_value - _friction < 0) ? 0: _value - _friction;
			}
			return _value;
		}
		
		public function appendMax(value:Number):void {
			_max += value;
		}		
		
		public function setMax(value:Number):void {
			_max = value;
		}		
	}
}
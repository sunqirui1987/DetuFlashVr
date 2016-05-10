/*
Copyright 2012 Igor Zevako.

This file is part of QjPlayer.

QjPlayer is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published
by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.

QjPlayer is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty
of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with QjPlayer. If not, see <http://www.gnu.org/licenses/>.
*/
package com.panozona.modules.lensflare.model{
	
	public class SettingsBrightness {
		
		public function SettingsBrightness(defaultLevel:Number, defaultDistance:Number) {
			level = defaultLevel;
			distance = defaultDistance;
		}
			
		public var distance:Number;
		public var level:Number;
		
	}
}
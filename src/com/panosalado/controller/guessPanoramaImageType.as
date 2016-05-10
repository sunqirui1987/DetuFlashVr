
package com.panosalado.controller{
	
	import com.panosalado.model.PanoramaImageType;
	
	public function guessPanoramaImageType(path:String):String {
		//note: file name conventions don't distinguish between equi and cylinder.
		//once image or image descriptor is loaded, the aspect ratio USUALLY differentiates 
		//(the exception is the pathological partial pano case, where the aspect ratio is arbitrary)
		//<_f>.xml						DZ cube
		//<front>.xml						DZ cube
		//<_f>/ImageProperties.xml		Zfy cube
		//<front>/ImageProperties.xml		Zfy cube
		//name.xml						DZ equi / cylinder
		//ImageProperties.xml				Zfy equi / cylinder
		//<_f>.jpg						cube
		//<_front>.jpg					cube
		//name.jpg						equi OR cylinder
		//name.mov						QTVR
		
		var deepZoomCube:RegExp = /(_f|front)\.(xml|XML)$/;
		var zoomifyCube:RegExp = /(_f|front)\/ImageProperties\.(xml|XML)$/;
		var deepZoomEqui:RegExp = /(ImageProperties|_f|front){0}\.(xml|XML)$/;
		var zoomifyEqui:RegExp = /(_f|front){0}\/ImageProperties\.(xml|XML)$/;
		var cube:RegExp = /(_f|front)\.(jpg|jpeg|JPG|JPEG|gif|GIF|png|PNG)$/;
		var equi:RegExp = /(_f|front){0}\.(jpg|jpeg|JPG|JPEG|gif|GIF|png|PNG)$/;
		var qtvr:RegExp = /\.(mov|MOV)$/;
		
		if ( path.match(deepZoomCube) ) {
			return PanoramaImageType.DEEP_ZOOM_CUBE;
		}
		/*
		else if ( path.match(zoomifyCube) ) {
			return PanoramaImageType.ZOOMIFY_CUBE;
		}
		else if ( path.match(deepZoomEqui) ) {
			return PanoramaImageType.DEEP_ZOOM_EQUIRECTANGULAR;
		}
		else if ( path.match(zoomifyEqui) ) {
			return PanoramaImageType.ZOOMIFY_EQUIRECTANGULAR;
		}
		else if ( path.match(cube) ) {
			return PanoramaImageType.CUBE;
		}
		else if ( path.match(equi) ) {
			return PanoramaImageType.EQUIRECTANGULAR;
		}
		else if ( path.match(qtvr) ) {
			return PanoramaImageType.QTVR;
		}
		*/
		else {
			return null;
		}
	}
}
/*////////////////////////////////////////////

glassesfactory

Autor	YAMAGUCHI EIKICHI
Date	2010/07/12

Copyright 2010 glasses factory
http://glasses-factory.net

/*////////////////////////////////////////////

package net.glassesfactory.effects
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	
	public class RefrectionImage extends Bitmap implements IEffect
	{
		/*/////////////////////////////////////////
		* public consts
		/*/////////////////////////////////////////
		
		
		/*/////////////////////////////////////////
		* public vars
		/*/////////////////////////////////////////
		
		
		/*/////////////////////////////////////////
		* getter
		/*/////////////////////////////////////////
		
		
		/*/////////////////////////////////////////
		* setter
		/*/////////////////////////////////////////
		
		
		/*/////////////////////////////////////////
		* public methods
		/*/////////////////////////////////////////
		
		//Constractor
		public function RefrectionImage( source:DisplayObject, refH:int = 4 )
		{
			_init( source, refH );
		}
		
		public function reset():void
		{
		}
		
		
		/*/////////////////////////////////////////
		* private methods
		/*/////////////////////////////////////////
		
		private function _init( source:DisplayObject, refH:int ):void
		{
			var refHeight:uint = Math.ceil( source.height / refH );
			var source_bmpdata:BitmapData = new BitmapData( source.width, source.height );
			source_bmpdata.draw( source );
			var ref_bmpdata:BitmapData =new BitmapData( source.width, refHeight );
			var per:Number;
			var pAlpha:uint;
			
			for( var py:int = 0; py <= refHeight; py++ )
			{
				per = py / ( refHeight );
				pAlpha = uint( 128 * ( 1 - per ))<<24;
				for( var px:int = 0; px <= source.width; px++ )
				{
					var getRGB:uint = source_bmpdata.getPixel( px, source.height - py - 1 );
					var setARGB:uint = pAlpha+getRGB;
					ref_bmpdata.setPixel32( px, py, setARGB );
				}
			}
			this.bitmapData = ref_bmpdata;
		}
		
		/*/////////////////////////////////////////
		* private vars
		/*/////////////////////////////////////////
		
		private var _source:DisplayObject;
	}
}
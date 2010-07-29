/*////////////////////////////////////////////

glassesfactory

Autor	YAMAGUCHI EIKICHI
Date	2010/07/12

Copyright 2010 glasses factory
http://glasses-factory.net

/*////////////////////////////////////////////

package net.glassesfactory.effects.bitmap
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import net.glassesfactory.effects.IEffect;
	
	
	public class MosaicImage extends Bitmap implements IEffect, IBitmapEffect
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
		
		public function get pixelSize():int
		{
			return _pixelSize;
		}
		
		
		/*/////////////////////////////////////////
		* setter
		/*/////////////////////////////////////////
		
		public function set pixelSize( value:int ):void
		{
			_pixelSize = value;
		}
		
		
		/*/////////////////////////////////////////
		* public methods
		/*/////////////////////////////////////////
		
		//Constractor
		public function MosaicImage( source:BitmapData, pixelSize:int = 10 )
		{
			_rect = new Rectangle( 0, 0, source.width, source.height );
			this.pixelSize = pixelSize;
			apply( source );
		}
		
		public function apply( source:BitmapData ):void
		{
			var tmpBmd:BitmapData = new BitmapData( source.width, source.height );
			
			tmpBmd.lock();
			tmpBmd.copyPixels( source, _rect, new Point() );
			
			for( var x:int = 0; x < source.width; x += _pixelSize )
			{
				for( var y:int = 0; y < source.height; y += _pixelSize )
				{
					for( var xx:int = x; xx < x + _pixelSize; xx++ )
					{
						var r1:int, r2:int;
						var g1:int, g2:int;
						var b1:int, b2:int;
						var num:int;
						for( var yy:int = y; yy < y + _pixelSize; yy++ )
						{
							if( source.width <= xx || source.height <= yy ) continue;
							
							r2 = source.getPixel(xx, yy ) >> 16 & 0xFF;
							g2 = source.getPixel( xx, yy ) >> 8 & 0xFF;
							b2 = source.getPixel( xx, yy );
							
							r1 += r2;
							g1 += g2;
							b1 += b2;
							
							num++;
						}
					}
					
					r1 /= num;
					g1 /= num;
					b1 /= num;
					
					for( xx = x; xx < x + _pixelSize; xx++ )
					{
						for( yy = y; yy < y + _pixelSize; yy++ )
						{
							if( source.width <= xx || source.height <= yy ) continue;
							var pixel:int = r1 << 16;
							pixel += g1 << 8;
							pixel += b1;
							tmpBmd.setPixel( xx, yy, pixel );
						}
					}
				}
			}
			
			this.bitmapData = tmpBmd;
			
		}
		
		public function reset():void
		{
		}
		
		public function getBmd():BitmapData
		{
			return this.bitmapData;
		}
		
		
		/*/////////////////////////////////////////
		* private methods
		/*/////////////////////////////////////////
		
		
		/*/////////////////////////////////////////
		* private vars
		/*/////////////////////////////////////////
		
		private var _rect:Rectangle;
		
		private var _pixelSize:int;
	}
}
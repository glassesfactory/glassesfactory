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
	
	
	public class BinarizeImage extends Bitmap implements IEffect, IBitmapEffect
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
		
		public function get threshold():uint
		{
			return _threshold;
		}
		
		/*/////////////////////////////////////////
		* setter
		/*/////////////////////////////////////////
		
		public function set threshold( value:uint ):void
		{
			_threshold = value;
		}
		
		/*/////////////////////////////////////////
		* public methods
		/*/////////////////////////////////////////
		
		//Constractor
		public function BinarizeImage( source:BitmapData, threshold:uint = 125 )
		{
			_rect = new Rectangle( 0, 0, source.width, source.height );
			threshold = threshold;
		}
		
		public function apply( source:BitmapData ):void
		{
			var tmpBmd:BitmapData = new BitmapData( source.width, source.height );
			tmpBmd.fillRect( _rect, 0xffffffff );
			tmpBmd.threshold( source, _rect, new Point(), "<=", threshold, 0, 0x000000 );
			this.bitmapData = tmpBmd;
		}
		
		public function getBmd():BitmapData
		{
			return this.bitmapData;
		}
		
		public function reset():void
		{
		}
		
		
		/*/////////////////////////////////////////
		* private methods
		/*/////////////////////////////////////////
		
		
		/*/////////////////////////////////////////
		* private vars
		/*/////////////////////////////////////////
		
		private var _rect:Rectangle;
		
		private var _threshold:uint;
	}
}
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
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import net.glassesfactory.effects.IEffect;
	
	
	public class AlphaGradientImage extends Bitmap implements IEffect, IBitmapEffect
	{
		/*/////////////////////////////////////////
		* public consts
		/*/////////////////////////////////////////
		
		public static const TO_LEFT:String = "to_left";
		public static const TO_RIGHT:String = "to_right";
		public static const TO_TOP:String = "to_top";
		public static const TO_BOTTOM:String = "to_bottom";
		
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
		public function AlphaGradientImage( source:BitmapData, direction:String = AlphaGradientImage.TO_LEFT, ratio:Number = 125 )
		{
			_rect = new Rectangle( 0, 0, source.width, source.height );
			createAlphaBmd( source, direction, ratio );
			apply( source );	
		}
		
		public function apply( source:BitmapData ):void
		{
			var tmpBmd:BitmapData = new BitmapData( source.width, source.height, true, 0 );
			
			tmpBmd.lock();
			tmpBmd.copyPixels( source, _rect, new Point(), _alphaBmd, new Point(), true );
			tmpBmd.unlock();
			this.bitmapData = tmpBmd;
			//this.bitmapData = _alphaBmd;
		}
		
		public function reset():void
		{
		}
		
		public function getBmd():BitmapData
		{
			return this.bitmapData;
		}
		
		public function createAlphaBmd( source:BitmapData, direction:String,  ratio:Number ):void
		{
			_alphaBmd = new BitmapData( source.width, source.height, true, 0 );
			var alphaSp:Shape = new Shape();
			var mt:Matrix = new Matrix();
			mt.createGradientBox( source.width, source.height);
			
			switch( direction )
			{
				case AlphaGradientImage.TO_LEFT:
					mt.rotate( -Math.PI );
					mt.translate( source.width, 0 );
					break;
				
				case AlphaGradientImage.TO_RIGHT:
					break;
				
				case AlphaGradientImage.TO_BOTTOM:
					mt.rotate( 90 * Math.PI / 180 );
					break;
				
				case AlphaGradientImage.TO_TOP:
					mt.rotate( -90 * Math.PI / 180 );
					mt.translate( 0, source.height );
					
				default:
					break;
			}
			alphaSp.graphics.beginGradientFill( GradientType.LINEAR, [ 0, 0, 0 ], [ 1, 1, 0], [ 0, ratio, 255 ], mt );
			alphaSp.graphics.drawRect(0, 0, source.width, source.height );
			_alphaBmd.draw( alphaSp );
		}
		
		
		/*/////////////////////////////////////////
		* private methods
		/*/////////////////////////////////////////
		
		
		/*/////////////////////////////////////////
		 * private vars
		/*/////////////////////////////////////////
		
		private var _source:BitmapData;
		
		private var _rect:Rectangle;
		
		private var _alphaBmd:BitmapData;
	}
}
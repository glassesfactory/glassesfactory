/*////////////////////////////////////////////

glassesfactory

Autor	YAMAGUCHI EIKICHI
Date	2010/07/12

Copyright 2010 glasses factory
http://glasses-factory.net

/*////////////////////////////////////////////

package net.glassesfactory.effects.color
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import net.glassesfactory.effects.IEffect;
	
	
	public class ColorChannelImage extends Bitmap implements IEffect
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
		public function ColorChannelImage( source:BitmapData )
		{
			_source = source;
		}
		
		public function reset():void{}
		
		public function getRed():BitmapData
		{
			var bmd:BitmapData = new BitmapData( _source.width, _source.height );
			bmd.copyChannel( _source, _source.rect, new Point(), BitmapDataChannel.RED, BitmapDataChannel.RED);
			return bmd;
		}
		
		public function getGreen():BitmapData
		{
			var bmd:BitmapData = new BitmapData( _source.width, _source.height );
			bmd.copyChannel( _source, _source.rect, new Point(), BitmapDataChannel.GREEN, BitmapDataChannel.GREEN );
			return bmd;
		}
		
		public function getBlue():BitmapData
		{
			var bmd:BitmapData = new BitmapData( _source.width, _source.height );
			bmd.copyChannel( _source, _source.rect, new Point(), BitmapDataChannel.BLUE, BitmapDataChannel.BLUE );
			return bmd;
		}
		
		
		/*/////////////////////////////////////////
		* private methods
		/*/////////////////////////////////////////
		
		
		/*/////////////////////////////////////////
		* private vars
		/*/////////////////////////////////////////
		
		private var _source:BitmapData;
	}
}
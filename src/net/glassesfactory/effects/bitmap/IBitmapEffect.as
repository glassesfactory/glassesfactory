package net.glassesfactory.effects.bitmap
{
	import flash.display.BitmapData;

	public interface IBitmapEffect
	{
		function apply( source:BitmapData ):void;
		function getBmd():BitmapData;
	}
}
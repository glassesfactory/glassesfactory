package net.glassesfactory.utils
{
	import flash.display.Shape;
	import flash.display.Sprite;
	
	public class TigerMask
	{
		public function TigerMask(){}
		
		public static function rect( width:Number, height:Number, color:uint = 0x000000 ):Shape
		{
			var sp:Shape = new Shape();
			sp.graphics.beginFill( color, 1 );
			sp.graphics.drawRect( 0, 0, width, height );
			sp.graphics.endFill();
			return sp;
		}
		
		public static function rectSp( width:Number, height:Number, color:uint = 0x000000 ):Sprite
		{
			var sp:Sprite = new Sprite();
			sp.graphics.beginFill( color, 1 );
			sp.graphics.drawRect( 0, 0, width, height );
			sp.graphics.endFill();
			return sp;
		}
	}
}
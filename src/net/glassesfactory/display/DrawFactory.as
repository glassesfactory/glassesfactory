/*////////////////////////////////////////////

glassesfactory

Autor	YAMAGUCHI EIKICHI
Date	2010/05/10

Copyright 2010 glasses factory
http://glasses-factory.net

/*////////////////////////////////////////////

/**
 * ドロー系一纏め
 */

package net.glassesfactory.display
{
	import flash.display.Shape;
	import flash.display.Sprite;
	
	public class DrawFactory
	{
		/*/////////////////////////////////
		* public variables
		/*/////////////////////////////////
		
		
		/*/////////////////////////////////
		* getter
		/*/////////////////////////////////
		
		
		/*/////////////////////////////////
		* setter
		/*/////////////////////////////////
		
		
		/*/////////////////////////////////
		* public methods
		/*/////////////////////////////////
		
		/**
		 * 単純な四角を描く
		 * ------------------------------------------------------
		 * @param	w:Number	幅
		 * @param	h:Number	高さ
		 * @param	col:uint	色
		 * @param	tick:uint	線の幅(初期値0の場合は線なし)
		 * @param	tickCol:uint	線の色(線が0の場合はなし)
		 * ------------------------------------------------------
		 * @return	Shape
		 */
		public static function planeRect( w:Number, h:Number, col:uint, tick:Number = 0, tickCol:uint = 0 ):Shape
		{
			var sp:Shape = new Shape();
			sp.graphics.beginFill( col );
			if( tick != 0 ){ sp.graphics.lineStyle( tick, tickCol ); }
			sp.graphics.drawRect( 0, 0, w, h );
			sp.graphics.endFill();
			return sp;
		}
		
		/**
		 * グラデーション塗の四角を描く
		 * ------------------------------------------------------
		 * @param	w:Number	幅
		 * @param	h:Number	高さ
		 * @param	prop:Object	塗の情報
		 * @param	tick:uint	線の幅(初期値0の場合は線なし)
		 * @param	tickCol:uint	線の色(線が0の場合はなし)
		 * ------------------------------------------------------
		 * @return	Shape
		 */
		public static function gradientRect( w:Number, h:Number, prop:Object, tick:uint = 0, tickCol:uint = 0 ):Shape
		{
			var sp:Shape = new Shape();
			sp.graphics.beginGradientFill(
											prop.type,
											prop.cols,
											prop.alphas,
											prop.ratios,
											prop.matrix,
											prop.spread,
											prop.inter,
											prop.focal );
			if( tick != 0 ){ sp.graphics.lineStyle( tick, tickCol ); }
			sp.graphics.drawRect( 0, 0, w, h );
			sp.graphics.endFill();
			return sp;
		}
		
		/**
		 * ヌキの四角を描く
		 * ------------------------------------------------------
		 * @param	w:Number		幅
		 * @param	h:Number		高さ
		 * @param	tick:uint		線の幅
		 * @param	tickCol:uint	線の色
		 * @param	fillAlpha		塗りつぶしの透明度(　初期値0 )
		 * @param	col				塗
		 * ------------------------------------------------------
		 * @return	Shape
		 */
		
		public static function frame( w:Number, h:Number, tick:Number, tickCol:uint, fillAlpha:Number = 0, col:uint = 0xffffff ):Shape
		{
			var sp:Shape = new Shape();
			sp.graphics.lineStyle( tick, tickCol );
			if( fillAlpha > 0 ){ sp.graphics.beginFill( col, fillAlpha ); }
			sp.graphics.drawRect( 0, 0, w, h );
			sp.graphics.endFill();
			return sp;
		}
		
		/*/////////////////////////////////
		* private methods
		/*/////////////////////////////////
		
		
		/*/////////////////////////////////
		* private variables
		/*/////////////////////////////////
	}
}
/*////////////////////////////////////////////

PremiumMilk

Autor	YAMAGUCHI EIKICHI
Date	2010/04/27

Copyright 2010 glasses factory
http://glasses-factory.net

/*////////////////////////////////////////////

package net.glassesfactory.effects
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.ConvolutionFilter;
	import flash.filters.DisplacementMapFilter;
	import flash.filters.DisplacementMapFilterMode;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	import sketchBook.SketchBook;
	
	public class RippleMilk extends Sprite implements IEffect
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
		
		//Constractor
		public function RippleMilk()
		{
		}
		
		
		/*/////////////////////////////////
		* private methods
		/*/////////////////////////////////
		
		public function init( target:BitmapData ):void
		{
			_whiteScreen.bitmapData = target;
			
			addChild( _whiteScreen );
			
			_buffer1 = new BitmapData( 1050 * _scale, 565 * _scale, false, 0 );
			_buffer2 = new BitmapData( _buffer1.width, _buffer1.height, false, 0 );
			//_diffBmd = new BitmapData( 1050, 565, false, 0x7f7f7f );
			_diffBmd = new BitmapData( 1050, 565, false, 0x0 );
			
			_fullRect = new Rectangle( 0, 0, _buffer1.width, _buffer1.height );
			_drawRect = new Rectangle();
			
			_dispFilter = new DisplacementMapFilter( _buffer1, new Point(), BitmapDataChannel.BLUE, BitmapDataChannel.BLUE, 50, 50, DisplacementMapFilterMode.WRAP );
			_convoFilter = new ConvolutionFilter( 3, 3, [ 0.5, 1, 0.5, 1, 0, 1, 0.5, 1, 0.5 ], 3 );
			_colorTransform = new ColorTransform( 1, 1, 1, 1, 0, 128, 128 );
			_matrix = new Matrix( _diffBmd.width / _buffer1.width, 0, 0, _diffBmd.height / _buffer1.height );
			
			_whiteScreen.filters = [ _dispFilter ];
			
			//_timer = new Timer( 1 );
			_timer = new Timer( 20 );
			_timer.addEventListener( TimerEvent.TIMER, _timerUpdateHandler );
			_timer.start();
		}
		
		//波を発生
		public function apply():void
		{
			var rad:int = _size * 0.25 * -1;
			_drawRect.x = ( rad + SketchBook.centerX ) * _scale;
			_drawRect.y = ( rad + SketchBook.centerY ) * _scale;
			//ん？
			_drawRect.width = _drawRect.height = _size * _scale;
			_buffer1.fillRect( _drawRect, 0xff );
		}
		
		public function reset():void
		{
			//消去祭り
			_whiteScreen.filters = [];
			_buffer1 = _buffer2 = _diffBmd = null;
			_fullRect = _drawRect = null; 
			_dispFilter = null; 
			_convoFilter = null; 
			_colorTransform = null; 
			_matrix = null;
			_timer.removeEventListener( TimerEvent.TIMER, _timerUpdateHandler );
			_timer = null;
			
		}
		
		/*/////////////////////////////////
		* private variables
		/*/////////////////////////////////
		
		private function _timerUpdateHandler( e:TimerEvent ):void
		{
			var tmp:BitmapData = _buffer2.clone();
			_buffer2.applyFilter( _buffer1, _fullRect, new Point(), _convoFilter );
			_buffer2.draw( tmp, null, null, BlendMode.SUBTRACT, null, false );
			_diffBmd.draw( _buffer2, _matrix, _colorTransform, null, null, true );
			_dispFilter.mapBitmap = _diffBmd;
			_whiteScreen.filters = [ _dispFilter ];
			tmp.dispose();
			switchBuffers();
		}
		
		private function switchBuffers():void
		{
			var tmp:BitmapData;
			tmp = _buffer1;
			_buffer1 = _buffer2;
			_buffer2 = tmp;
			tmp = null;
		}
		
		//波紋のサイズ
		private var _size:Number = 70;
		
		//バッファ用ビットマップのサイズ
		private var _scale:Number = 0.045;
		
		//ビットマップ
		private var _whiteScreen:Bitmap = new Bitmap();
		
		//バッファ用1
		private var _buffer1:BitmapData;
		
		//バッファ用2
		private var _buffer2:BitmapData;
		
		//偏差
		private var _diffBmd:BitmapData;
		
		private var _matrix:Matrix;
		
		private var _fullRect:Rectangle;
		
		private var _drawRect:Rectangle;
		
		private var _dispFilter:DisplacementMapFilter;
		
		private var _convoFilter:ConvolutionFilter;		
		
		private var _colorTransform:ColorTransform;
		
		//仮
		private var _timer:Timer;
	}
}
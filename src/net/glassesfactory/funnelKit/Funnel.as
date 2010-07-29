package net.glassesfactory.funnelKit
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import sketchBook.*;

	public class Funnel extends Sprite
	{
		public var mass:int = 200;
		
		public static const CAPCHA:String = "capcha";
		
		public static const BOUNCE:String = "bounce";
		
		//Constractor
		public function Funnel( p:SimpleFunnelBase )
		{
			_p = p;	
		}
				
		//random move
		public function randMove():void
		{
			_p.x = Math.random() * mass - mass * 0.5 | 0;
			_p.y = Math.random() * mass - mass * 0.5 | 0;
		}
		
		//timer loop rand
		public function randMoveByTimer( screenType:String = null ):void
		{
			var timer:Timer = new Timer(0);
			timer.addEventListener( TimerEvent.TIMER, function( e:TimerEvent ):void
			{			
				_p.vx += Math.random() * mass - mass * 0.5 | 0; 
				_p.x += _p.vx;
				_p.vy += Math.random() * mass - mass * 0.5 | 0;
				_p.y += _p.vy;

				bounce();
				timer.delay = Math.random() * 200 + 200;
			});
			timer.start();
		}
		
		public function randMoveByTimerClickMeet( screenType:String = null ):void
		{
			var timer:Timer = new Timer(0);
			
			SketchBook.stage.addEventListener( MouseEvent.MOUSE_DOWN, function( e:MouseEvent ):void
			{
				_isPress = true;
				_lastMass = mass;
				mass = 100;
			});
			
			SketchBook.stage.addEventListener( MouseEvent.MOUSE_UP, function( e:MouseEvent ):void
			{
				_isPress = false;
				mass = Math.random() * 10 + 10;
			});
			
			timer.addEventListener( TimerEvent.TIMER, function( e:TimerEvent ):void
			{			
				if( _isPress )
				{
					_p.x = Math.random() * mass - mass * 0.5 + SketchBook.mouseX | 0;
					_p.y = Math.random() * mass - mass * 0.5 + SketchBook.mouseY | 0;
				}
				else
				{
					_p.vx += Math.random() * mass - mass * 0.5 | 0; 
					_p.x += _p.vx;
					_p.vy += Math.random() * mass - mass * 0.5 | 0;
					_p.y += _p.vy;	
				}
				
				switch( screenType )
				{
					case CAPCHA:
						capcha();
						break;
					case BOUNCE:
						bounce();
						break;
					default:
						break;
				}
				
				timer.delay = Math.random() * 200 + 200;
			});
			timer.start();
		}
		
		public function traceMouserandByTimer( screenType:String = null ):void
		{
			var timer:Timer = new Timer(0);
			timer.addEventListener( TimerEvent.TIMER, function( e:TimerEvent ):void
			{			
				_p.x = Math.random() * mass - mass * 0.5 + SketchBook.mouseX | 0; 
				_p.y = Math.random() * mass - mass * 0.5  + SketchBook.mouseY | 0;
				
				timer.delay = Math.random() * 200 + 200;
			});
			timer.start();
		}
		
		private function capcha():void
		{
			if( _p.x > SketchBook.stageWidth )
				_p.x = 0;
			if( _p.x < 0 )
				_p.x = SketchBook.stageWidth;
			if( _p.y > SketchBook.stageHeight )
				_p.y = 0;
			if( _p.y < 0 )
				_p.y = SketchBook.stageHeight;
		}
		
		private function bounce():void
		{
			if( _p.x > SketchBook.stageWidth || _p.x < 0 )
				_p.vx *= -0.9;
			if( _p.y > SketchBook.stageHeight || _p.y < 0 )
				_p.vy *= -0.9;
		}
		
		private var _p:SimpleFunnelBase;
		
		private var _date:Date;
		
		private var _isPress:Boolean;
		
		private var _lastMass:Number;
	}
}
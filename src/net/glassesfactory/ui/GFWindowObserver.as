/*////////////////////////////////////////////

glassesfactory

Autor	YAMAGUCHI EIKICHI
(@glasses_factory)
Date	2010/11/14

Copyright 2010 glasses factory
http://glasses-factory.net

/*////////////////////////////////////////////

package net.glassesfactory.ui
{
	import flash.display.Shape;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.utils.Timer;
	
	import net.glassesfactory.events.GFWindowEvent;
	
	/**
	 * swfを表示しているブラウザウィンドウが本当に非アクティブになったかどうか調べるクラス
	 * サイズの決まったswfを貼りつけていて他のHTML要素などをクリックした際
	 * Event.DEACTIVEが放出されるのがそれだけでは困る人向け。
	 * @author glasses factory(@glasses_factory)
	 * 
	 */	
	
	public class GFWindowObserver
	{
		
		[Event(name = "onWindowActive", type = "net.glassesfactory.events.GFWindowEvent")]
		
		[Event(name = "onWindowDeactive", type = "net.glassesfactory.events.GFWindowEvent")]
		
		//-------VERSION INFO--------
		/**
		 * 2010.11.13	とりえず仕事で必要な分だけ機能を実装
		 * 				細かい判定基準とかをフラグで設定できるようにすると汎用性上がる気はしている 
		 */		
		public static const VERSION:String = "0.4 alpha";
		
		/*/////////////////////////////////
		* const
		/*/////////////////////////////////
		
		/**
		 * wiondowを監視するjs 
		 */		
		public static const ACTIVER_LIB:String = "function(){if(window.GFWindowObserver)return;var win=window;var GFWindowObserver=window.GFWindowObserver=function(a){this.swfID=a;this.isActive=true;this.bodyFocus=true;};GFWindowObserver.prototype={_onBlur:function(){GFWindowObserver.isActive=false;swfName(GFWindowObserver.swfID).getStatus(GFWindowObserver.isActive );},_onFocus:function(){GFWindowObserver.isActive=true;if(isIE){GFWindowObserver.bodyFocus=true;			swfName(GFWindowObserver.swfID).changeStatus(GFWindowObserver.bodyFocus);}},status:function(){swfName(GFWindowObserver.swfID).getStatus(GFWindowObserver.isActive,GFWindowObserver.bodyFocus);},_swfFocus:function(){if(isIE){GFWindowObserver.isActive=true;GFWindowObserver.bodyFocus=false;swfName(GFWindowObserver.swfID).changeStatus(GFWindowObserver.bodyFocus);}},_swfBlur:function(){if(isIE){GFWindowObserver.isActive=true;GFWindowObserver.bodyFocus=true;	swfName(GFWindowObserver.swfID).changeStatus(GFWindowObserver.bodyFocus);}}};swfName=function(a){return navigator.appName.indexOf('Microsoft')!=-1?window[a]:document[a]};var isIE;GFWindowObserver.init=function(a){GFWindowObserver=win.GFWindowObserver=new GFWindowObserver(a);win.onblur=GFWindowObserver._onBlur;win.onfocus=GFWindowObserver._onFocus;isIE=/*@cc_on!@*/false;swfName(GFWindowObserver.swfID).onfocus=GFWindowObserver._swfFocus;swfName(GFWindowObserver.swfID).onblur=GFWindowObserver._swfBlur;};}";
		public static const INIT_LIB:String = "GFWindowObserver.init";
		public static const STATUS_LIB:String = "GFWindowObserver.status";
		
		
		/*/////////////////////////////////
		* getter / setter
		/*/////////////////////////////////
		
		/**
		 * 現在swfがアクティブかどうか 
		 * @return 
		 */		
		public static function get isActive():Boolean{ return _isActive; }
		private static var _isActive:Boolean;
		
		
		/**
		 * <p>IE対策。ページのswf以外の要素にフォーカスがあるかどうか</p> 
		 * @return 
		 */		
		public static function get bodyActive():Boolean { return _bodyActive; } 
		private static var _bodyActive:Boolean = true;
		
		
		/**
		 * ExternalInterfaceが本当に使えるかどうかチェック 
		 * @return 
		 */		
		public static function get isAvarable():Boolean
		{
			var result:Boolean = false;
			if( !ExternalInterface.available ){ return result; }
			
			try
			{
				result = Boolean(ExternalInterface.call("function(){return true;}" ));
			}
			catch(e:Error)
			{
				throw new Error("external interfaceがつかえませんよ");
			}
			return result;
		}
		
		/**
		 * IE対策用。
		 * バッファーを取るかどうか
		 * @default	true 
		 * @return 
		 * 
		 */		
		public static function get useBuffer():Boolean{ return _useBuffer; }
		public static function set useBuffer( value:Boolean ):void{ _useBuffer = value; }
		private static var _useBuffer:Boolean = true;
		
		
		/*/////////////////////////////////
		* private variables
		/*/////////////////////////////////
		
		private static var _stage:Stage;
		private static var _isReady:Boolean = false;
		
		
		
		/*/////////////////////////////////
		* public methods
		/*/////////////////////////////////
		
		/**
		 * 初期化 
		 * @param stage
		 */		
		public static function init(stage:Stage):void
		{
			if( _isReady || !isAvarable )return;
			
			_stage = stage;
			_stage.addEventListener( Event.ACTIVATE, _stageActivateHandler );
			_stage.addEventListener( Event.DEACTIVATE, _stageDeactivateHandler );
			
			ExternalInterface.call( ACTIVER_LIB );
			ExternalInterface.addCallback("getStatus", _getStatus);
			ExternalInterface.addCallback( 'changeStatus', _changeStatus )
			ExternalInterface.call( INIT_LIB, ExternalInterface.objectID );
			_isReady = true;
		}
		
		
		
		/*/////////////////////////////////
		* private methods
		/*/////////////////////////////////
		
		private static function _stageActivateHandler( e:Event ):void
		{
			_isActive = true;
			ExternalInterface.call( STATUS_LIB );
		}
		
		
		private static function _stageDeactivateHandler( e:Event ):void
		{
			_isActive = false;
			
			if( _useBuffer )
			{
				var timer:Timer = new Timer( 10, 1 );
				timer.addEventListener( TimerEvent.TIMER_COMPLETE, _bufferCompleteHandler );
				timer.start();
			}
			else{ ExternalInterface.call( STATUS_LIB ); }
		}
		
		
		/**
		 * IE対策。 
		 * @param e
		 */		
		private static function _bufferCompleteHandler( e:TimerEvent ):void
		{
			e.target.removeEventListener( TimerEvent.TIMER_COMPLETE, _bufferCompleteHandler );
			ExternalInterface.call( STATUS_LIB );
		}
		
		
		private static function _changeStatus( body:* = true ):void
		{
			_bodyActive = Boolean(body);
		}
		
		
		private static function _getStatus( e:*, body:* = true ):void
		{
			_bodyActive = Boolean( body );
			if( Boolean(e) )
			{
				//Event.ACTIVATEが排出されつつ、ブラウザウィンドウが本当にアクティブであった場合イベントディスパッチ
				if( _isActive ){ _stage.dispatchEvent( new GFWindowEvent( GFWindowEvent.WINDOW_ACTIVE )); }
				//IE対策
				else if(!_bodyActive){ _stage.dispatchEvent( new GFWindowEvent( GFWindowEvent.WINDOW_DEACTIVE )); }
			}
			else
			{
				//Event.DEACTIVATEが排出されつつ、ブラウザウィンドウ自体も本当に非アクティブであった場合イベントディスパッチ
				if(!_isActive ){ _stage.dispatchEvent( new GFWindowEvent( GFWindowEvent.WINDOW_DEACTIVE )); }
			}
		}
	}
}
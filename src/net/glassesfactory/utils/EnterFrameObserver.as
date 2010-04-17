/**
 * EnterFrameEventをまとめて処理
 * 早くなるらしい。理屈ではわかる。
 */
package net.glassesfactory.utils
{
	public class EnterFrameObserver
	{
		/*/////////////////////////////////
			public static variables
		/*/////////////////////////////////
		
		private static var _OBSERVER:Observer;
		
		
		/*/////////////////////////////////
			getter
		/*/////////////////////////////////
		
		public static function get listenerNum():uint
		{
			return _OBSERVER.listenerNum;
		}
		
		public static function get isRunninng():Boolean
		{
			return _OBSERVER.isRunning;
		}
		
		/*/////////////////////////////////
			public methods
		/*/////////////////////////////////
		
		/** イベントリスナーを登録 */
		public static function addEventListener( listener:Function ):void
		{
			_OBSERVER.add( listener );	
		}
		
		/**　イベントリスナーを削除 */
		public static function removeEventListener( listener:Function ):void
		{
			_OBSERVER.remove( listener );
		}
		
		/** enterFrameを停止する */
		public static function pause():void
		{
			_OBSERVER.pause();
		}
		
		/** enterFrameを再開する */
		public static function resume():void
		{
			_OBSERVER.resume();
		}
		
		/** 初期化 */
		public static function init():void
		{
			_OBSERVER = new Observer();
		}
		
		//Constractor
		public function EnterFrameObserver()
		{
			//_OBSERVER = new Observer();
		}
	}
}

import flash.display.Shape;
import flash.events.Event;
import flash.utils.Dictionary;

class Observer extends Shape
{
	/*/////////////////////////////////
		getter
	/*/////////////////////////////////
	/** 登録されているリスナの数 */
	public function get listenerNum():uint
	{
		return _listenerNum;
	}
	
	/** enterFrameが実行されているかどうか */
	public function get isRunning():Boolean
	{
		return _isRunning;
	}
	
	
	/*/////////////////////////////////
		public methods
	/*/////////////////////////////////
	
	public function add( listener:Function ):void
	{
		if( _listenerDict[ listener ] ) return;
		_listenerDict[ listener ] = listener;
		_listenerNum++;
	}
	
	public function remove( listener:Function ):void
	{
		if( !_listenerDict[ listener ] ) return;
		delete _listenerDict[ listener ];
		if( --_listenerNum <= 0 ) pause();
	}
	
	public function pause():void
	{
		if( !_isRunning ) return;
		removeEventListener( Event.ENTER_FRAME, _enterFrameHandler );
		_isRunning = false;
	}
	
	public function resume():void
	{
		if( _isRunning || _listenerNum <= 0 ) return;
		addEventListener( Event.ENTER_FRAME, _enterFrameHandler );
		_isRunning = true;
	}
	
	public function Observer()
	{
		_listenerDict = new Dictionary();
		_isRunning = false;
		_listenerNum = 0;
		
		addEventListener( Event.ENTER_FRAME, _enterFrameHandler );
	}
	
	/*/////////////////////////////////
		private methods
	/*/////////////////////////////////
	
	/**
	 * enterFrame実行処理
	 * @param	e
	 */
	private function _enterFrameHandler( e:Event ):void
	{
		for each( var func:Function in _listenerDict ) func( e );
	}
	
	private var _listenerNum:uint;
	
	private var _isRunning:Boolean;
	
	private var _listenerDict:Dictionary;
}
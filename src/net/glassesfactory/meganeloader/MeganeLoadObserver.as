/*////////////////////////////////////////////

glassesfactory

Autor	YAMAGUCHI EIKICHI
Date	2010/04/18

Copyright 2010 glasses factory
http://glasses-factory.net

/*////////////////////////////////////////////

package net.glassesfactory.meganeloader
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.ProgressEvent;
	
	import net.glassesfactory.namespaces.glassesfactory;
	
	use namespace glassesfactory;

	/**
	 * 複数のローダーをまとめて監視
	 */
	public class MeganeLoadObserver extends EventDispatcher implements IEventDispatcher
	{
		/*/////////////////////////////////
		* public variables
		/*/////////////////////////////////
		
		
		/*/////////////////////////////////
		* getter
		/*/////////////////////////////////
		
		/**
		 * 登録された全てのローダーの読み込むトータルバイト数を返す
		 */
		public function get allTotalByte():uint
		{
			return _allTotalBytes;
		}
		
		/**
		 * 登録された全てのローダーの読み込んだトータルバイト数を返す
		 */
		public function get allLoadedByte():uint
		{
			return _allLoadedBytes;
		}
		
		/**
		 * ロード状況をパーセントで返す
		 */
		public function get percent():Number
		{
			return _allLoadedBytes / _allTotalBytes; 
		}
		
		public function get stack():Array
		{
			return _stack;
		}
		
		public function get numLoaders():uint
		{
			return _stack.length;
		}
		
		/*/////////////////////////////////
		* setter
		/*/////////////////////////////////
		
		
		/*/////////////////////////////////
		* public methods
		/*/////////////////////////////////
		
		/**
		 * ローダーを追加します。
		 */
		public function addLoader( mLoader:MeganeLoader ):void
		{
			//ロード中は新規ローダーの追加を拒否
			if( _nowloading ){ return; }
			
			mLoader.id = _stack.length;
			_stack.push( mLoader );
		}
		
		/**
		 * ロードをスタート
		 */
		public function loadStart():void
		{
			_nowloading = true;
			preSerialLoad();
		}
		
		//Constractor
		public function MeganeLoadObserver()
		{
		}
		
		/*/////////////////////////////////
		* private methods
		/*/////////////////////////////////
		
		glassesfactory function preSerialLoad():void
		{
			//一通りなめて読み込む総バイト数を取得
			if( hasNext() )
			{
				var mLoader:MeganeLoader = nextLoader();
				mLoader.contentLoaderInfo.addEventListener( ProgressEvent.PROGRESS, function( e:ProgressEvent ):void
				{
					if( mLoader.totalByte > 0 )
					{
						_allTotalBytes += mLoader.totalByte;
						mLoader.contentLoaderInfo.removeEventListener( e.type, arguments.callee );
						mLoader.close();
						preSerialLoad();
					}
				});
				mLoader.load();
			}
			else
			{
				reset();
				_serialLoad();
			}
		}
		
		glassesfactory function _serialLoad():void
		{
			if( hasNext() )
			{
				var mLoader:MeganeLoader = nextLoader();
				mLoader.contentLoaderInfo.addEventListener( ProgressEvent.PROGRESS, _updateLoadStatus );
				mLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, _loaderComplete );
				mLoader.load();
				return;
			}
			
			_observeComplete();
			
		}
		
		private function _updateLoadStatus( e:ProgressEvent ):void
		{
			//一旦読み込んだバイトをリセット
			_allLoadedBytes = 0;
			
			var l:int = _stack.length;
			for( var i:int = 0; i < l; i++ )
			{
				_allLoadedBytes += _stack[ i ].loadedByte;
			}
			
			dispatchEvent( new ProgressEvent ( ProgressEvent.PROGRESS, false, false, allLoadedByte, allTotalByte ));
		}
		
		private function _loaderComplete( e:Event ):void
		{
			e.target.removeEventListener( ProgressEvent.PROGRESS, _updateLoadStatus );
			e.target.removeEventListener( Event.COMPLETE, _loaderComplete );
			
			_serialLoad();
		}
		
		private function _observeComplete():void
		{
			_nowloading = false;
			dispatchEvent( new Event( Event.COMPLETE ));
		}
		
		glassesfactory function hasNext():Boolean
		{
			return _position < _stack.length;
		}
		
		glassesfactory function nextLoader():MeganeLoader
		{
			return _stack[_position++];
		}
		
		glassesfactory function reset():void
		{
			_position = 0;
		}
		
		/*/////////////////////////////////
		* private variables
		/*/////////////////////////////////
		
		//現在ロードを実行中かどうか中かどうか
		private var _nowloading:Boolean;
		
		//ロードが始まったかどうか
		private var _isLoadStart:Boolean = false;
		
		//ローダーを格納
		private var _stack:Array = [];
		
		//現在読み込んでいるローダーの位置
		private var _position:uint = 0;
		
		private var _allLoadedBytes:uint;
		
		private var _allTotalBytes:uint;
		
		private var _dispatcher:EventDispatcher;
	}
}
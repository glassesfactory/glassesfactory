/*////////////////////////////////////////////

glassesfactory

Autor	YAMAGUCHI EIKICHI
Date	2010/04/17

Copyright 2010 glasses factory
http://glasses-factory.net

/*////////////////////////////////////////////

/**
 * ローダーのバグを解決したいｗ
 * 色々便利に
 */
package net.glassesfactory.meganeloader
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	import flash.utils.ByteArray;
	
	import net.glassesfactory.display.ILoader;
	import net.glassesfactory.namespaces.glassesfactory;
	
	import org.osmf.media.LoadableMediaElement;
	
	use namespace glassesfactory;
	
	public class MeganeLoader extends EventDispatcher implements ILoader, IEventDispatcher
	{
		/*/////////////////////////////////
		* public variables
		/*/////////////////////////////////
		
		
		/*/////////////////////////////////
		* getter
		/*/////////////////////////////////
		
		/**
		 * シリアルロード時のid
		 */
		public function get id():int
		{
			return _id;
		}
		
		/**
		 * URL
		 */
		public function get url():String
		{
			return _url;
		}
		
		/**
		 * ローダーコンテキスト
		 */
		public function get context():LoaderContext
		{
			return _context;
		}
		
		/**
		 * 読み込まれたディスプレイオブジェクトを返す
		 */
		public function get content():DisplayObject
		{
			return _loader.content;
		}
		
		public function get totalByte():uint
		{
			return contentLoaderInfo.bytesTotal;
		}
		
		public function get loadedByte():uint
		{
			return contentLoaderInfo.bytesLoaded;
		}
		
		/**
		 * 読み込まれたオブジェクトに対するLoaderInfoオブジェクトを返す
		 */
		public function get contentLoaderInfo():LoaderInfo
		{
			return _loader.contentLoaderInfo;
		}
		
		/**
		 * ロード中かどうか
		 */
		public function get isLoading():Boolean
		{
			try
			{
				return( content.loaderInfo.bytesTotal >  0 && content.loaderInfo.bytesLoaded < content.loaderInfo.bytesTotal );
			}
			catch( e:Error ){}
			
			return false;
		}
		
		/*/////////////////////////////////
		* setter
		/*/////////////////////////////////
		
		public function set id( value:int ):void
		{
			_id = value;
		}
		
		public function set context( value:LoaderContext ):void
		{
			_context = value;
		}
		
		/*/////////////////////////////////
		* public methods
		/*/////////////////////////////////
		
		/**
		 * 読み込みを中断
		 */
		public function close():void
		{
			_loader.close();
		}
		
		/**
		 * 読み込みを開始
		 * @param	req:URLRequest 読み込むURL
		 * @param	context:ロード時のコンテキストを指定
		 */ 
		public function load( __url:String = null, __context:LoaderContext = null ):void
		{
			if( __url != null ){ _url = __url; }
			if( __context != null ){ _context = __context; }
			var req:URLRequest = new URLRequest( _url );
			_loader.contentLoaderInfo.addEventListener( Event.COMPLETE, _loadCompleteHandler );
			_loader.load( req, _context );
		}
		
		/**
		 * ByteArrayに保管されているバイナリから読み込み
		 * @param	bytes:バイナリが保管れているByteArray
		 * @param	context:ロード時のコンテキストを指定
		 */
		public function loadBytes( bytes:ByteArray, context:LoaderContext = null):void
		{
			_loader.loadBytes( bytes, context );
		}
		
		/**
		 * load()メソッドを使用して読み込まれたcontentの削除
		 */
		public function unload():void
		{
			_loader.unload();
		}
		
		/**
		 * 子swfのアンロードを試みつつロードされたswfのコマンド実行を中止
		 */
		public function unloadAndStop( gc:Boolean = true ):void
		{
			_loader.unloadAndStop( gc );
		}
		
		/**
		 * 読み込んだ対象をビットマップデータとして返す
		 */
		public function getBitmapData():BitmapData
		{
			//読み込みが未完了だった場合はエラーを返す
			if( !_isComplete ){ throw new Error( "読み込みが未完了のためメソッドにアクセスできません" ); }
			
			var bmd:BitmapData = new BitmapData( content.width, content.height, true, 0 );
			bmd.draw( content );
			return bmd;
		}
		
		public function kill():void
		{
			_loader = null;
		}
		
		public override function addEventListener( type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false ):void
		{
			_loader.contentLoaderInfo.addEventListener( type, listener, useCapture, priority, useWeakReference );
		}
		
		public override function removeEventListener( type:String, listener:Function, useCapture:Boolean = false ):void
		{
			_loader.contentLoaderInfo.removeEventListener( type, listener, useCapture );
		}
		
		public override function dispatchEvent( event:Event ):Boolean
		{
			return _loader.contentLoaderInfo.dispatchEvent( event );
		}
		
		public override function hasEventListener( type:String ):Boolean
		{
			return _loader.contentLoaderInfo.hasEventListener( type );
		}
		
		public override function willTrigger( type:String ):Boolean
		{
			return _loader.willTrigger( type );
		}
		
		//Constractor
		public function MeganeLoader( url:String, context:LoaderContext = null )
		{
			_loader = new Loader();
			_url = url;
			_context = context;
		}
		
		
		/*/////////////////////////////////
		* private methods
		/*/////////////////////////////////
		
		private function _loadCompleteHandler( e:Event ):void
		{
			_loader.contentLoaderInfo.removeEventListener( Event.COMPLETE, _loadCompleteHandler );
			_isComplete = true;
			return;
		}
		
		/*/////////////////////////////////
		* private variables
		/*/////////////////////////////////
		
		private var _loader:Loader;
		
		private var _isComplete:Boolean = false;
		
		//ローダーコンテキスト
		private var _context:LoaderContext = null;
		
		private var _id:int;
		
		private var _url:String;
	}
}
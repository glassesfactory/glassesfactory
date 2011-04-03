/*////////////////////////////////////////////

glassesfactory

Autor	YAMAGUCHI EIKICHI
(@glasses_factory)
Date	2011/04/03

Copyright 2010 glasses factory
http://glasses-factory.net

/*////////////////////////////////////////////

/**
 * どうしたら AMF が楽に出来るか模索。
 * とりあえず registerService で "実際に呼ぶメソッド", "AS 側で叩くメソッド名" を登録することで
 * 動的にメソッドが追加できる。
 * 例えば AMFClient.registerService('imgUtil.load', 'load' )
 * AMFClient.load(hogehoge);
 * …とか…コード補完きかないから微妙っちゃ微妙。
 * 
 * call(サーバー側のメソッド, コールバック, 引数 )
 * って ASer には馴染みが薄い気がするので
 * イベントリスナーで、イベントのプロパティでデータがとれるように。
 * URLLoader とかの e.target.data 的な使い勝手というか…
 * 
 * とにかく模索中なので勘弁。
 * 
 * シングルトンにしといたほうがいいのかなぁ。
 */


package net.glassesfactory.net
{
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.ObjectEncoding;
	import flash.net.Responder;
	import flash.utils.Dictionary;
	
	import net.glassesfactory.events.GFAMFClientEvent;
	
	public dynamic class GFAMFClient extends EventDispatcher
	{
		/*/////////////////////////////////
		* VERSIONS
		/*/////////////////////////////////
		
		public static const VERSION:String = '0.01';
		
		
		/*/////////////////////////////////
		* public variables
		/*/////////////////////////////////
		
		/**
		 * debug true の場合、 trace に NetStatus など、各種イベントが trace に表示されます。 
		 */		
		public var debug:Boolean = false;
		
		
		/**
		 * AMF 通信を行う gateway の URL
		 * @return 
		 * 
		 */		
		public function get gateway():String{ return _gateway; }
		public function set gateway( value:String ):void
		{ 
			_gateway = value;
			_registerGateway();
		}
		private var _gateway:String;
		
		
		/**
		 * ReadOnly
		 * AMF 通信を行った戻り値
		 * @return object 
		 * 
		 */		
		public function get data():Object{ return _data; }
		private var _data:Object;
		
		
		/**
		 * 現在通信中かどうか 
		 * @return Boolean
		 * 
		 */		
		public function get isCalling():Boolean{ return _isCalling; }
		private var _isCalling:Boolean = false;
		
		
		//----- Netほにゃららら ---------
		private var _nc:NetConnection;
		private var _ns:NetStream;
		private var _res:Responder;
		
		private var _callback:Function;
		//---使い物になるかなぁ…
		private var _serviceDict:Dictionary;
//		private var _callbackDict:Dictionary;
		
		/*/////////////////////////////////
		* public methods
		/*/////////////////////////////////
		
		//Constractor
		public function GFAMFClient( gateway:String )
		{
			_gateway = gateway;
			_init();
		}
		
		
		public function registerService( propName:String, serviceName:String ):void
		{
			_serviceDict[propName] = serviceName;
			this[propName] = function():void
			{
				_internalCall( propName, arguments );
			}
		}
		
		
		public function call( method:String, callback:Function, ... args:Array ):void
		{
			if( !_gateway ){ throw ArgumentError('FROM GFAMFClient::please set gateway'); }
			_callback = callback;
			_nc.call.apply( _nc, [method].concat( _res, args));
		}
		
		
		public function close():void
		{
			_nc.close();
			_ns.close();
			this.removeEventListener(Event.ENTER_FRAME, _streamProgressHandler );
		}
		
		
		/*/////////////////////////////////
		* private methods
		/*/////////////////////////////////
		
		private function _init():void
		{
			_serviceDict = new Dictionary();
			_res = new Responder( _resultHandler, _faultHandler );
			_registerGateway();
		}
		
		
		private function _registerGateway():void
		{
			_nc = new NetConnection();
			_nc.objectEncoding = ObjectEncoding.AMF3;
			_nc.addEventListener(NetStatusEvent.NET_STATUS, _netStatusHandler );
			_nc.addEventListener(AsyncErrorEvent.ASYNC_ERROR, _asyncErrorHandler );
			_nc.addEventListener(SecurityErrorEvent.SECURITY_ERROR, _securityErrorHandler );
			_nc.addEventListener(IOErrorEvent.IO_ERROR, _ioErrorHandler );
			_nc.connect( _gateway );
		}
		
		
		private function _internalCall( propName:String, args:Array ):void
		{
			if( !_gateway ){ throw ArgumentError('FROM GFAMFClient::please set gateway'); }
			var param:Array = [ _serviceDict[propName], new Responder( _resultHandler, _faultHandler )];
			_nc.call.apply( _nc, param.concat(args));
		}
		
		
		private function _resultHandler( result:Object ):void
		{
			if( _callback != null )
			{
				_data = _callback.apply( null, [result] );
			}
			else
			{
				_data = result;
			}
			dispatchEvent( new GFAMFClientEvent( GFAMFClientEvent.COMPLETE, false, false, result ));
		}
		
		private function _faultHandler( fault:Object ):void
		{
			var faultEvt:GFAMFClientEvent = new GFAMFClientEvent( GFAMFClientEvent.COMPLETE, false, false );
			faultEvt.text = "FROM GFAMFClient::[GFAMFClientEvent::FAULT] fault:" + fault.description + ' code: ' + fault.code + ' details: ' + fault.details + ' level: ' + fault.level + ' line: ' + fault.line;
			dispatchEvent( faultEvt );
		}
		
		private function _connectStream():void
		{
			//うまくいくかまだ試してない
			_ns = new NetStream( _nc );
			_ns.addEventListener(NetStatusEvent.NET_STATUS, _nsNetStatusHandler );
			this.addEventListener(Event.ENTER_FRAME, _streamProgressHandler );
		}
		
		
		/*========================================
		Monitaring
		========================================*/
		
		
		private function _netStatusHandler( e:NetStatusEvent ):void
		{
			if( debug )
			{
				trace("---------------------------------------------------");
				trace( "FROM GFAMFClient::[NetStatusEvent] level:" + e.info.level + "code:" + e.info.code );
				trace("---------------------------------------------------");
			}
			
			switch( e.info.code )
			{
				case "NetConnection.Connect.Success": _connectStream(); break;
				default:break;
			}
			dispatchEvent(e.clone());
		}
		
		//いる？
		private function _nsNetStatusHandler( e:NetStatusEvent ):void
		{
			
		}
		
		
		private function _streamProgressHandler( e:Event ):void
		{
			var loaded:uint = _ns.bytesLoaded;
			var total:uint = _ns.bytesTotal;
			//ふむ
			dispatchEvent(new ProgressEvent( ProgressEvent.PROGRESS, false, false, loaded, total ));
			if( loaded == total )
			{
				dispatchEvent(new Event( Event.COMPLETE, false, false ));
				removeEventListener(Event.ENTER_FRAME, _streamProgressHandler );
			}
		}
		
		
		/*========================================
		 Error Handling
		========================================*/
		
		private function _asyncErrorHandler( e:AsyncErrorEvent ):void
		{
			if( debug )
			{
				trace("---------------------------------------------------");
				trace( "FROM GFAMFClient::[AsyncErrorEvent] " + e.text );
				trace("---------------------------------------------------");
			}
			dispatchEvent( e.clone());
		}
		
		private function _securityErrorHandler( e:SecurityErrorEvent ):void
		{
			if( debug )
			{
				trace("---------------------------------------------------");
				trace( "FROM GFAMFClient::[SecurityErrorEvent] :" + e.text )
				trace("---------------------------------------------------");
			}
			dispatchEvent( e.clone());
		}
		
		private function _ioErrorHandler( e:IOErrorEvent ):void
		{
			if( debug )
			{
				trace("---------------------------------------------------");
				trace( "FROM GFAMFClient::[IOErrorEvent] :" + e.text );
				trace("---------------------------------------------------");
			}
			dispatchEvent( e.clone());
		}
	}
}
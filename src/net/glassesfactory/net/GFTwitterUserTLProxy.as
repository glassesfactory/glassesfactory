/*////////////////////////////////////////////

glassesfactory GFTwitterUserTLProxy

Autor	YAMAGUCHI EIKICHI
(@glasses_factory)
Date	2010/11/24

Copyright 2010 glasses factory
http://glasses-factory.net

MIT License

/*////////////////////////////////////////////


/**
 * 2010/11現在
 * OAuthを必要としないuser_timelineのみ、Flash単体でクロスドメインを回避しつつ
 * 読み込むことが出来るクラスです。
 * サーバー環境によってPHP、Pythonなどのサーバーサイドスクリプトが設置できない場合
 * たかがタイムライン読み込むのにいくつもファイル作りたくない、スクリプト用意するのがめんどくさい人向けです。
 * 
 * ただし、これは2010/11現在のTwitterサーバー環境でのみ動作を保証します。
 * 予告なくTwitter側でAPIやクロスドメイン周りの仕様が変わり
 * 使用できなくなることがあることをご理解ください。
 * 
 * 内部で使用しているJSは、以下URLを参考にさせていただきました。
 * http://d.hatena.ne.jp/NeoCat/20080831/1220164153
 * 
 * JSのクロージャ名が毎回自動で生成されるため、ある程度の連続呼び出しに対応できます。
 * まとめてtweetを取得して解析など、そういったことも出来ると思います。
 */

package net.glassesfactory.net
{
	import flash.events.EventDispatcher;
	import flash.external.ExternalInterface;
	
	import net.glassesfactory.events.GFTwitterProxyEvent;
	
	public class GFTwitterUserTLProxy extends EventDispatcher
	{
		[Event(name = "load_complete", type = "net.glassesfactory.events.GFTwitterProxyEvent")]
		
		/*/////////////////////////////////
		* public variables
		/*/////////////////////////////////
		
		private static const PROXY_LIB:String = "function(){var GFTwitterUserTLProxy=window.GFTwitterUserTLProxy=function(a){this.cbCnt=(new Date).getTime();this.swfID=a};GFTwitterUserTLProxy.prototype={load:function(a,b){var c=GFTwitterUserTLProxy.cbCnt++,d=document.createElement('script');d.src=a+(a.indexOf('?')<0?'?':'&')+'callback=GFTwitterUserTLProxy.cb'+c;d.type='text/javascript';GFTwitterUserTLProxy['cbe'+c]=d;GFTwitterUserTLProxy['cb'+c]=function(){GFTwitterUserTLProxy.abort(c);b.apply(GFTwitterUserTLProxy,arguments)};document.body.appendChild(d);return c},abort:function(a){var b=GFTwitterUserTLProxy['cbe'+a];b.parentNode.removeChild(b);delete GFTwitterUserTLProxy['cb'+a];delete GFTwitterUserTLProxy['cbe'+a]},getJson:function(a){GFTwitterUserTLProxy.load(a,function(b){swfName(GFTwitterUserTLProxy.swfID).getResult(b)})}};swfName=function(a){return navigator.appName.indexOf('Microsoft')!=-1?window[a]:document[a]};GFTwitterUserTLProxy.init=function(a){GFTwitterUserTLProxy=window.GFTwitterUserTLProxy=new GFTwitterUserTLProxy(a);};}";
		private static const INIT_LIB:String = "GFTwitterUserTLProxy.init";
		private static const GET_JSON:String = "GFTwitterUserTLProxy.getJson";
		
		
		/*/////////////////////////////////
		* public methods
		/*/////////////////////////////////
		
		//Constractor
		public function GFTwitterUserTLProxy( caller:Function = null )
		{
			if( caller != GFTwitterUserTLProxy.init )
			{
				throw new Error( "GFTwitterUserTLProxyを初期化してください" );
			}
			else if( _instance != null )
			{
				throw new Error( 'GFTwitterUserTLProxyはシングルトンである必要があります。' );
			}
		}
		
		
		/**
		 * GFTwitterUserProxyを初期化します。 
		 * @return 
		 */		
		public static function init():GFTwitterUserTLProxy
		{
			if( !_instance )
			{
				ExternalInterface.call( PROXY_LIB );
				ExternalInterface.addCallback( "getResult", _getResult );
				ExternalInterface.call( INIT_LIB, ExternalInterface.objectID );
				_instance = new GFTwitterUserTLProxy( arguments.callee );
			}
			return _instance;
		}
		
		
		/**
		 * インスタンスを返します。
		 * loadなどを実行する際はこれを呼び出してその他の関数を実行してください。 
		 * @return 
		 */		
		public static function getInstance():GFTwitterUserTLProxy
		{
			return _instance;
		}
			
		
		/**
		 * URLを指定して読み込みます。
		 * @param url
		 */		
		public static function load( url:String ):void
		{
			ExternalInterface.call( GET_JSON, url );
		}
		
		
		/**
		 * おまけ。URLパラメータを引数で指定してリクエスト出来る。
		 * APIの仕様が変わったらサラバ。
		 * @param userName ユーザーのID
		 * @param count 一度に取得するポスト数
		 * @param page ページ数
		 * @param since_id	特定post ID 以降のポストを取得する
		 */		
		public function getTweet( userName:String, count:uint = 10, page:uint = 1, since_id:int = 0  ):void
		{
			var url:String = 'http://api.twitter.com/1/statuses/user_timeline.json?screen_name=' + userName;
			if( count != 10 ){ url += '&count=' + String(count); }
			if( page != 1 ){ url += '&page=' + String(page); }
			if( since_id != 0 ){ url += '&since_id=' + String( since_id ); }
			
			ExternalInterface.call( GET_JSON, url );
		}
		
		
		/*/////////////////////////////////
		* private methods
		/*/////////////////////////////////
		
		private static function _getResult( result:* ):void
		{
			try
			{
				var _result:Object = result;
				_instance.dispatchEvent( new GFTwitterProxyEvent( GFTwitterProxyEvent.LOAD_COMPLETE, _result ));
			}
			catch( e:Error )
			{
				throw new Error( e.message, e.errorID );
			}
		}
		
		/*/////////////////////////////////
		* private variables
		/*/////////////////////////////////
		
		private static var _instance:GFTwitterUserTLProxy;
		
	}
}
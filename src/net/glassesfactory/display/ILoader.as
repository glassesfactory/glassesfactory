/*////////////////////////////////////////////

glassesfactory

Autor	YAMAGUCHI EIKICHI
date	2010/04/19

Copyright 2010 glasses factory
http://glasses-factory.net

/*////////////////////////////////////////////

/**
 * Loader拡張用インターフェース
 */

package net.glassesfactory.display
{
	import flash.display.DisplayObject;
	import flash.display.LoaderInfo;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	public interface ILoader
	{
		/**
		 * load() または loadBytes() メソッドを使用して読み込まれた SWF ファイルまたはイメージ（JPG、PNG、または GIF）ファイルのルート表示オブジェクトが含まれます。
		 */
		function get content():DisplayObject;
		
		/**
		 * 読み込まれているオブジェクトに対応する LoaderInfo オブジェクトを返します。
		 */
		function get contentLoaderInfo():LoaderInfo;
		
		/**
		 * Loader インスタンスに対して現在進行中の load() メソッドの処理をキャンセルします。
		 */
		function close():void;
		
		/**
		 * SWF、JPEG、プログレッシブ JPEG、非アニメーション GIF、または PNG ファイルを、この Loader オブジェクトの子であるオブジェクトにロードします。
		 * @param	req:読み込むファイルのURL
		 * @param	context:コンテキスト指定
		 */
		function load( url:String = null, context:LoaderContext = null ):void;
		
		/**
		 *ByteArray オブジェクトに保管されているバイナリデータから読み込みます。 
		 */
		function loadBytes(bytes:ByteArray, context:LoaderContext = null):void;
		
		/**
		 * load() メソッドを使用して読み込まれた、この Loader オブジェクトの子を削除します。
		 */
		function unload():void;
		
		/**
		 * 子 SWF ファイルの内容のアンロードを試み、ロードされた SWF ファイルのコマンドの実行を中止します。
		 */
		function unloadAndStop( gc:Boolean = true ):void

	}
}
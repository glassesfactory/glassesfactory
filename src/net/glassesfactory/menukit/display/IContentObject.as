/*/////////////////////////////////////////////
* GlassesFrame
*
* 俺俺画面遷移用フレームワーク
* Autor YAMAGUCHI EIKICHI
* Licensed under the MIT License
* 
* Copyright (c) 2009 glasses factory(http://glasses-factory.net)
/*/////////////////////////////////////////////

/**
 * コンテンツオブジェクトインターフェース
 */

package net.glassesfactory.menukit.display
{
	import flash.events.IEventDispatcher;
	
	public interface IContentObject extends IEventDispatcher
	{
		function get isSelected():Boolean;
		function buildOwn():void;
		function hide():void;
	}
}
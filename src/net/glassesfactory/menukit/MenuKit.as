/*/////////////////////////////////////////////
* GlassesFrame
*
* 俺俺画面遷移用フレームワーク
* Autor YAMAGUCHI EIKICHI
* Licensed under the MIT License
* 
/*/////////////////////////////////////////////

package net.glassesfactory.menukit
{
	import flash.display.DisplayObjectContainer;
	
	import net.glassesfactory.menukit.core.menus.*;
	import net.glassesfactory.menukit.core.observer.*;
	import net.glassesfactory.menukit.display.*;
	import net.glassesfactory.menukit.menus.*;
	import net.glassesfactory.display.*;

	public class MenuKit
	{
		/*///////////////////////////////////////////
			getter
		/*///////////////////////////////////////////
		
		public static function get observer():IObserver
		{
			return _observer
		}
		
		/*///////////////////////////////////////////
			setter
		/*///////////////////////////////////////////
		
		public static function set observer( value:IObserver ):void
		{
			_observer = value;
		}
		
		
		/*///////////////////////////////////////////
			public methods
		/*///////////////////////////////////////////
		
		//Constractor
		public function MenuKit( caller:Function = null )
		{
			if( caller != MenuKit.init )
			{
				throw new Error("GlassesFrameはまだ初期化されていません。GlassesFrame.init()を実行してください。");
			}
			if( _instance != null )
			{
				throw new Error("既に初期化されています。GlassesFrameを複数生成することは出来ません。");
			}
		}
		
		/**
		 * 初期化
		 * @param	observer	オブザーバー(監視タイプ)を指定。
		 * nullだった場合はMediatorを指定。
		 */
		public static function init( observer:IObserver = null ):MenuKit
		{
			if( !( _instance != null ))
			{
				_instance = new MenuKit( arguments.callee );
				
				if( !( observer != null )){ _observer = new Mediator; }
				else { _observer = observer; }
			}
			return _instance;
		}
		
		/**
		 * メニューにアイテム追加
		 * グループがnullだった場合、privateGroupに登録。
		 * @param	clicker:Object	クリックされるオブジェクト
		 * @param	target:IDocObject	クリックされた結果遷移するコンテンツ
		 * @param	group:IMenuGroup	追加するグループ
		 * @param	index:uint	追加するグループへのインデックス指定
		 * @return	データオブジェクト？なんて言ったらいいかわからん。
		 */
		public static function registItem( clicker:DisplayObjectContainer, target:IContentObject = null, group:IMenuGroup = null, index:uint = uint.MAX_VALUE ):AbstractMenuItem
		{
			var menuObj:AbstractMenuItem = new AbstractMenuItem( clicker, target );
			if( !( group != null ))
			{
				_privateGroup.addGroup( menuObj,index );
			}
			else
			{
				group.addGroup( menuObj, index );
			}
			return menuObj;
		}
		
		/**
		 * グループリストにグループを追加
		 * @param	group	グループ
		 */
		public static function registGroup( group:IMenuGroup ):void
		{
			_groups.push( group );
		}
		
		/**
		 * コンテンツ切り替え
		 * @param	menuObject:IMenuObject	切り替え依頼を出したアイテム
		 */
		public static function contentChange( menuObject:IMenuItem ):void
		{
			_observer.contentChange( menuObject );
		}
		
		public static function contentRemotoChange( menuObjA:IMenuItem,menuObjB:IMenuItem, type:String ):void
		{
			if( _observer is RemoteMediator ){ _observer.contentRemoteChange( menuObjA, menuObjB, type ); }
			else{ return }
		}
				
		/*///////////////////////////////////////////
			private variables
		/*///////////////////////////////////////////
		
		private static var _instance:MenuKit;
		
		private static var _privateGroup:MenuGroup;
		
		private static var _groups:Array;
		
		private static var _observer:IObserver;
		
		{
			_groups = [];
			_privateGroup = new MenuGroup();
			registGroup( _privateGroup );
		}
	}
}
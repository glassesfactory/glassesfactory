/*/////////////////////////////////////////////
* GlassesFrame
*
* 俺俺画面遷移用フレームワーク
* Autor YAMAGUCHI EIKICHI
* Licensed under the MIT License
* 
* Copyright (c) 2009 glasses factory(http://glasses-factory.net)
* 
/*/////////////////////////////////////////////

package net.glassesfactory.menukit.core.menus
{
	public class MenuGroup implements IIMenuGroup
	{
		public function get name():String
		{
			return _name;	
		}
		
		public function get id():uint
		{
			return _id;
		}
		
		public function get length():uint
		{
			return _targets.length;
		}

		
		public function set name( value:String ):void
		{
			_name = value || _name;
		}
		
		public function set id( value:uint ):void
		{
			_id = value || _id;
		}
		

		/**
		 * グループに追加
		 */
		public function addGroup( target:IIMenuItem, index:uint = uint.MAX_VALUE ):void
		{
			if( !( _targets != null ))
			{
				_targets = [];	
			}
			if( index == uint.MAX_VALUE )
			{
				_targets.push( target );
				target.index = (_targets.length ) ? _targets.length - 1 : 0;
			}
			else
			{
				_targets[ index ] = target;
				target.index = index;
			}
		}
		
		public function MenuGroup()
		{
			super();
		}
		
		private var _name:String;
		
		private var _id:uint;
		
		private var _targets:Array;
	}
}
/*////////////////////////////////////////////

glassesfactory

Autor	YAMAGUCHI EIKICHI
Date	2010/05/10

Copyright 2010 glasses factory
http://glasses-factory.net

/*////////////////////////////////////////////

package net.glassesfactory.display
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	
	import net.glassesfactory.utils.ClassUtil;
	
	import sketchBook.AirBook;
	
	public class AppBG extends MeganeClip
	{
		/*/////////////////////////////////
		* public variables
		/*/////////////////////////////////
		
		
		/*/////////////////////////////////
		* getter
		/*/////////////////////////////////
		
		
		/*/////////////////////////////////
		* setter
		/*/////////////////////////////////
		
		/**
		 * 背景をウィンドウドラッグの対象にするかどうか
		 */
		public function set useDrag( value:Boolean ):void
		{
			_useDrag = value;
			
			if( _useDrag )
			{
				_view.addEventListener( MouseEvent.MOUSE_DOWN, _moveWindowHandler );
			}
			else
			{
				_view.removeEventListener( MouseEvent.MOUSE_DOWN, _moveWindowHandler );
			}
		}
		
		
		/*/////////////////////////////////
		* public methods
		/*/////////////////////////////////
		
		//Constractor
		public function AppBG( view:MovieClip, useShadow:Boolean = false, useDrag:Boolean = true )
		{
			_view = view; 
			addChild( _view );
			
			if( useShadow )
			{
				_shadow = ClassUtil.duplicate( view ) as MovieClip;
				_shadowFilter = new DropShadowFilter( 4, 90, 0, 0.5, 7, 7, 1, 1, false, true, true );
				_shadow.filters = [ _shadowFilter ];
				addChildAt( _shadow, 0 );
			}
			
			_useDrag = useDrag;
			
			if( _useDrag )
			{
				_view.addEventListener( MouseEvent.MOUSE_DOWN, _moveWindowHandler );
			}
		}
		
		
		/*/////////////////////////////////
		* private methods
		/*/////////////////////////////////
		
		private function _moveWindowHandler( e:MouseEvent ):void
		{
			AirBook.satrtMove();
		}
		
		/*/////////////////////////////////
		* private variables
		/*/////////////////////////////////
		
		//背景ビュー
		private var _view:MovieClip;
		
		//影MC
		private var _shadow:MovieClip;
		
		//影フィルター
		private var _shadowFilter:DropShadowFilter;
		
		//ドラッグの対象にするかどうか
		private var _useDrag:Boolean = true;
	}
}
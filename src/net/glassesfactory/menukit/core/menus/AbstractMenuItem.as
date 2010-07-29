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

//とりあえず。アブストラクトなめぬーあいてむ。

package net.glassesfactory.menukit.core.menus
{
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	import net.glassesfactory.menukit.MenuKit;
	import net.glassesfactory.menukit.display.IContentObject;
	import net.glassesfactory.display.MeganeClip;
	
	public class AbstractMenuItem extends MeganeClip implements IIMenuItem
	{
		public function get target():Object
		{
			if( _target != null ){ return _target; }
			return null;
		}
		
		public function get index():uint
		{
			return _index;
		}
		
		public function set index( value:uint ):void
		{
			_index = _index || value;
		}
		
		public function mouseOver():void
		{
			
		}
		
		public function mouseOut():void
		{
			
		}
		
		public function enableClick():void
		{
			_clicker.mouseChildren = true;
			_clicker.mouseEnabled = true;
		}
		
		public function disableClick():void
		{
			_clicker.mouseChildren = false;
			_clicker.mouseEnabled = true;
		}
		
		protected function mouseClickHandler( e:MouseEvent ):void
		{
			MenuKit.contentChange( this );
		}
		
		public function AbstractMenuItem( clicker:DisplayObjectContainer, target:IContentObject = null )
		{
			_clicker = clicker;
			if( target != null ){ _target = target; }
			addChild( _clicker );
		}
				
		protected var _clicker:DisplayObjectContainer;
		
		protected var _target:IContentObject;
		
		protected var _index:uint;
	}
}
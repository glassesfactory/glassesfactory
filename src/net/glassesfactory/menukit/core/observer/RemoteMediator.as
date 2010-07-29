/*/////////////////////////////////////////////
* GlassesFrame
*
* 俺俺画面遷移用フレームワーク
* Autor YAMAGUCHI EIKICHI
* Licensed under the MIT License
* 
* Copyright (c) 2009 glasses factory(http://glasses-factory.net)
* 
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
* 
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
* 
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
/*/////////////////////////////////////////////

/**
 * RemoteMediatar
 * 一個の操作で複数のオブジェクトに影響を与える
 */

package net.glassesfactory.menukit.core.observer
{
	import net.glassesfactory.menukit.menus.IMenuItem;
	
	public class RemoteMediator implements IObserver
	{
		public function get index():uint
		{
			return _index;
		}
		
		public function get lastIndex():uint
		{
			return _lastTargetA.index;
		}
		
		public function RemoteMediator(){}
		
		//使わね。
		public function contentChange( menuObj:IMenuItem ):void{ return }
		
		public function contentRemoteChange( menuObjA:IMenuItem, menuObjB:IMenuItem, type:String ):void
		{
			_index = menuObjA.index;
			switch( type )
			{
				case type == "click":
					menuObjA.disableClick();
					menuObjB.disableClick();
					if( _lastTargetA != null )
					{
						_lastTargetA.enableClick();
						_lastTargetB.enableClick();
					}
				break;
				
				case type == "over":
					menuObjA.mouseOver();
					menuObjB.mouseOver();
				break;
				
				case type == "out":
					menuObjA.mouseOver();
					menuObjB.mouseOut();
				break;
				
				default:
				break;
			}
			
			
			_lastTargetA = menuObjA;
			_lastTargetB = menuObjB;
		}
		
		private var _index:uint;
		
		private var _lastTargetA:IMenuItem, _lastTargetB:IMenuItem;
		
	}
}
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
 * Mediatarパターン
 * EnterFrameしつつ動きが変わるときとか？
 */

package net.glassesfactory.menukit.core.observer
{
	import net.glassesfactory.menukit.menus.IMenuItem;

	public class Mediator implements IObserver
	{
		public function get index():uint
		{
			return _index;
		}
		
		public function get lastIndex():uint
		{
			return _lastTarget.index;
		}
		
		public function Mediator(){}
		
		public function contentChange( menuObj:IMenuItem ):void
		{
			_index = menuObj.index;
			
			menuObj.disableClick();
			if( _lastTarget != null ) _lastTarget.enableClick();
			_lastTarget = menuObj;
		}
		
		//空実装
		public function contentRemoteChange( menuObjA:IMenuItem, menuObjB:IMenuItem, type:String ):void{ return }
		
		//選択されたコンテンツの番号
		private var _index:uint;
		
		private var _lastTarget:IMenuItem = null;
	}
}
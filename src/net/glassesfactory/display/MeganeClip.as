/**
 * 便利な感じな奴をまとめたMovieClip拡張
 * なんか思いついたら追加していこう。
 * write 2009.11.05
 */
package net.glassesfactory.display
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	
	public class MeganeClip extends MovieClip
	{
		/*/////////////////////////////////
			getter
		/*/////////////////////////////////
		
		/**
		 * <p>右端位置を返す</p>
		 */
		public function get right():Number
		{
			return this.x + this.width;
		}
		
		/**
		 * <p>下位置を返す</p>
		 */
		public function get bottom():Number
		{
			return this.y + this.height;
		}
		
		/**
		 * <p>縦横比が固定されていた際、まとめて返す。(あんまり意味ない気もする。)</p>
		 */
		public function get scaleXY():Number
		{
			if( isFixedScale ) return scaleX;
			else throw new Error(　"比率が固定されていません。" );
		}
		
		/*/////////////////////////////////
			setter
		/*/////////////////////////////////
		
		/**
		 * <p>scaleX と scaleY を同時に設定<br/>
		 * @param	value	変更したいスケール</p>
		 */
		public function set scaleXY( value:Number ):void
		{
			if( !isFixedScale ) return;
			this.scaleX = this.scaleY = value;
			return;
		}
		
		/**
		 * <p>縦横比が固定されている場合<br/>
		 * 幅が変更されたら高さも同倍率で変更する。<br/>
		 * @param	value	幅</p>
		 */
		override public function set width( value:Number ):void
		{
			_prevW = this.width;
			this.width = value;
			if( isFixedScale )
			{
				var tmpH:Number = this.width / _prevW;
				this.height = this.height * tmpH;
			}
			return;
		}
		
		/**
		 * <p>縦横比が固定されている場合<br/>
		 * 高さが変更されたら幅も同倍率で変更する。<br/>
		 * @param	value	高さ</p>
		 */
		override public function set height( value:Number ):void
		{
			_prevH = this.height;
			this.height = value;
			if( isFixedScale )
			{
				var tmpW:Number = this.height / _prevH;
				this.width = this.width * tmpW;
			}
			return;
		}
		
		/*/////////////////////////////////
			public variables
		/*/////////////////////////////////
		
		/**
		 * 縦横比固定するかどうか。
		 */
		public var isFixedScale:Boolean;

		
		/*/////////////////////////////////
			public methods
		/*/////////////////////////////////
		
		/**
		 * まとめてaddChild
		 * @param	args	addChildするDisplayObject
		 */
		public function addChildren( ... args ):Array
		{
			var objAry:Array = [];
			args.map( function( child:* ):*
			{
				objAry.push( addChild( child ))
			});
			return objAry;
		}
		
		/**
		 * objAより上にobjBをaddChildする。
		 */
		public function addChildFront( objA:DisplayObject, objB:DisplayObject ):DisplayObject
		{
			return addChildAt( objB, getChildIndex( objA ) + 1 );	
		}
		
		/**
		 * objAより下にobjBをaddChildする。
		 */
		public function addChildNext( objA:DisplayObject, objB:DisplayObject ):DisplayObject
		{
			return addChildAt( objB, getChildIndex( objA ) - 1 );
		}
		
		/**
		 * まとめてremoveChild
		 * @param	args	removeChildするDisplayObject
		 */
		public function removeChildren( ... args ):Array
		{
			var objAry:Array = [];
			args.map( function( child:* ):*
			{
				objAry.push( removeChild( child ))
			});
			return objAry;
		}
		
		/** 自身を消去する */
		public function removeSelf():void
		{
			if( this.parent != null)
			{
				this.parent.removeChild( this );
			}
		}
		
		//Constractor
		public function MeganeClip()
		{
			super();
		}
		
		
		/*/////////////////////////////////
			private methods
		/*/////////////////////////////////
				
		/** 縦横比固定用　変更前の幅保持 */
		private var _prevW:Number;
		
		/** 縦横比固定用　変更前の高さ保持 */
		private var _prevH:Number;
	}
}
/**
 * 便利な感じな奴をまとめたMovieClip拡張
 * なんか思いついたら追加していこう。
 * write 2009.11.05
 */
package net.glassesfactory.display
{
	import flash.display.Graphics;
	import flash.display.GradientType;
	import flash.display.BitmapData;
	import flash.display.Shader;
	import flash.display.InterpolationMethod;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SpreadMethod;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	public class GFMeganeClip extends MovieClip
	{
		/*/////////////////////////////////
			getter
		/*/////////////////////////////////
		
		
		public function get rect():Rectangle
		{
			return new Rectangle( 0, 0, this.width, this.height );
		}
		
		
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
		
		//Constractor
		public function GFMeganeClip()
		{
			super();
			_children = [];
			_listeners = new GFUniqueCollection();
			_g = this.graphics;
		}
		
		/*-----------------------------------------
		* EventListener 関連
		*----------------------------------------*/
		
		/**
		 * この GFMeganeClip に EventListener を登録します。 
		 * @param type:String
		 * @param listener:Function
		 * @param useCapture:Boolean
		 * @param priority:int
		 * @param useWeakReference:Boolean
		 * 
		 */		
		override public function addEventListener( type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean=false):void
		{
			//むむ
			//			if( type == Event.ENTER_FRAME ){ this.addEnterFrame( listener ); return; }
			super.addEventListener( type, listener, useCapture, priority, useWeakReference );
			_listeners.addItem({type:type, listener:listener });
		}
		
		
		
		/**
		 * 登録されているリスナーを削除します。 
		 * @param type
		 * @param listener
		 * @param useCapture
		 */		
		override public function removeEventListener( type:String, listener:Function, useCapture:Boolean=false):void
		{
			//			if( type == Event.ENTER_FRAME ){ this.removeEnterFrame( listener ); return; }
			super.removeEventListener( type, listener, useCapture );
			_listeners.removeItem({ type:type, listener:listener});
		}
		
		
		
		/**
		 * この GFMeganeClip インスタンスに登録されている EventListener を全て削除 
		 */		
		public function removeAllListener():void
		{
			var len:uint = _listeners.numItems;
			var listeners:Array = _listeners.toArray();
			for( var i:int = 0; i < len; i++ )
			{
				super.removeEventListener( listeners[i].type, listeners[i].listener );
				_listeners.removeItemAt(i);
			}
		}
		
		/*-----------------------------------------
		* DisplayObjectTree 関連
		*----------------------------------------*/
		
		/**
		 * 現在このインスタンスの DisplayObjectTree に追加されている DisplayObject インスタンスを配列で返します。 
		 * @return 
		 * 
		 */		
		public function get children():Array
		{
			return _children;
		}
		
		
		/**
		 * この GFMeganeClip インスタンスに子 DisplayObject インスタンスを追加します。  
		 * @param child
		 * @return 
		 * 
		 */		
		override public function addChild( child:DisplayObject ):DisplayObject
		{
			return _addChildAt( child, this.numChildren - 1);
		}
		
		
		
		/**
		 * この GFMeganeClip インスタンスの指定された index 位置に子 DisplayObject インスタンスを追加します。  
		 * @param child:DisplayObject この DisplayObjectContainer インスタンスの子として追加する DisplayObject インスタンスです。
		 * @param index:int 
		 * @return 	DisplayObject — child パラメータで渡す DisplayObject インスタンスです。
		 * 
		 */		
		override public function addChildAt( child:DisplayObject, index:int ):DisplayObject
		{
			return _addChildAt( child, index );
		}
		
		
		
		/**
		 * この GFMeganeClip インスタンスに複数の DisplayObject インスタンスをまとめて追加します。
		 * @param args
		 * @return Array まとめて追加した DisplayObject を配列にして返します。 
		 */		
		public function addChildren( ...args ):Array
		{
			var objs:Array = [];
			args.map( function( child:* ):*{ objs.push( addChild( child )); });
			return objs;
		}
		
		
		
		/**
		 * childA より上に childB を追加します。
		 * childA が DisplayObjectTree に含まれていなかった場合、 childA, childB の順で表示リストの一番上に追加されます。 
		 * @param childA:DisplayObject
		 * @param childB:DisplayObject
		 * @return DisplayObject
		 * 
		 */		
		public function addSwapFront(childA:DisplayObject, childB:DisplayObject):DisplayObject
		{
			if( !getChildIndex( childA )){ this.addChildren( childA, childB ); }
			else{ _addChildAt( childB, getChildIndex( childA ) + 1 ); } 
			return childB;
		}
		
		
		
		/**
		 * childA より下に childB を追加します。
		 * childA が DisplayObjectTree に含まれていなかった場合、childB、childA の順で表示リストの一番上に追加されます。 
		 * @param childA:DisplayObject
		 * @param childB:DisplayObject
		 * @return DisplayObject
		 * 
		 */		
		public function addSwapBottom(childA:DisplayObject, childB:DisplayObject):DisplayObject
		{
			if( !getChildIndex( childA )){ this.addChildren( childB, childA ); }
			else{ _addChildAt( childB, ( getChildIndex( childA ) < 1 ) ? 0 : getChildIndex( childA ) - 1 ); }
			return childB;
		}
		
		
		
		/**
		 * この GFMeganeClip インスタンスの最前面に DisplayObject を追加します。
		 * @param child:DisplayObject
		 * @return DisplayObject
		 * 
		 */		
		public function addFront( child:DisplayObject ):DisplayObject
		{
			return _addChildAt( child, this.numChildren );
		}
		
		
		
		/**
		 * この GFMeganeClip インスタンスの最背面に DisplayObject を追加します。 
		 * @param child:DisplayObject
		 * @return DisplayObject
		 * 
		 */		
		public function addBottom( child:DisplayObject ):DisplayObject
		{
			return _addChildAt( child, 0 );
		}
		
		
		
		/**
		 * DisplayObjectContainer インスタンスの子リストから指定の child DisplayObject インスタンスを削除します。 
		 * @param child
		 * @return 
		 */		
		override public function removeChild( child:DisplayObject ):DisplayObject
		{
			var index:int = this.getChildIndex( child );
			return _removeChildAt( index );
		}
		
		
		
		/**
		 * GFMeganeClip の子リストの指定された index 位置から子 DisplayObject を削除します。 
		 * @param index
		 * @return 
		 * 
		 */		
		override public function removeChildAt( index:int ):DisplayObject
		{
			return _removeChildAt( index );
		}
		
		
		
		/**
		 * GFMeganeClip の DisplayObjectTree からまとめて子 DisplayObject を削除します。 
		 * @param args
		 * @return 
		 * 
		 */		
		public function removeChildren(...args):Array
		{
			var objs:Array = [];
			args.map( function( child:DisplayObject ):*{ objs.push( this.removeChild( child ));});
			return objs;
		}
		
		
		
		/**
		 * この GFMeganeClip の DisplayObjectTree に登録されている子 DisplayObject すべてを削除します。 
		 * 
		 */		
		public function removeAll():void
		{
			while( this.numChildren ){　super.removeChildAt( this.numChildren - 1 );　}
			_children = null;
		}
		
		
		
		/**
		 * 自身を削除します。もし、自身より上の階層に何もなければ何も起こしません。 
		 */
		//自分より上がなければthrow new Error しといたほうがいいんかな
		public function removeSelf():void
		{
			if( this.parent == null ){ return; }
			else{ this.parent.removeChild( this ); }
			return;
		}
		
		
		/**
		 * この GFMeganeClip インスタンスの最前面にある子 DisplayObject を削除します。 
		 * @return DisplayObject - 削除された DisplayObject 
		 */		
		public function removeFront():DisplayObject
		{
			return _removeChildAt( this.numChildren );
		}
		
		
		
		/**
		 * この GFMeganeClip インスタンスの最背面にある子 DisplayObject を削除します。 
		 * @return DisplayObject - 削除された DisplayObject 
		 */
		public function removeBottom():DisplayObject
		{
			return _removeChildAt( 0 );
		}
		
		
		
		/**
		 * この GFMeganeClip インスタンスの DisplayObjectTree の最前面にインデックスされている子 DisplayObject を返します。 
		 * @return DisplayObject - 最前面にインデックスされている DisplayObject 
		 * 
		 */		
		public function getFront():DisplayObject
		{
			return this.getChildAt( this.numChildren );
		}
		
		
		
		/**
		 * この GFMeganeClip インスタンスの DisplayObjectTree の最背面にある子 DisplayObject を返します。 
		 * @return DisplayObject - 最背面にインデックスされている子 DisplayObject
		 * 
		 */		
		public function getBottom():DisplayObject
		{
			return this.getChildAt( 0 );
		}
		
		/*---------------------------------------------
		* Graphics 関連
		*--------------------------------------------*/
		
		/**
		 * 線の描画で、線の幅を指定します。 
		 * @param thick:Number 線の幅を指定します。
		 * @return GFMeganeClip
		 */		
		public function setLineWidth( thick:Number = 0 ):GFMeganeClip
		{
			_thick = thick;
			_g.lineStyle( _thick );
			return this;
		}
		
		
		
		/**
		 * 描画の時の、単一の塗り色を指定します。 
		 * @param color:uint @default 0
		 * @return GFMeganeClip
		 */		
		public function setColor( color:uint = 0):GFMeganeClip
		{
			_fillCol = color;
			return this;
		}
		
		
		
		/**
		 * 描画の時の、塗の透明度を指定します。 
		 * @param alpha:Number @default 1
		 * @return GFMeganeClip
		 */		
		public function setAlpha( alpha:Number = 1 ):GFMeganeClip
		{
			_fillAlpha = alpha;
			return this;
		}
		
		
		
		/**
		 * 線の描画スタイルを一括で指定します。
		 * @param thick:Number 線の幅
		 * @param color:uint 線の色
		 * @param alpha:Number 線の透明度
		 * @return GFMeganeClip
		 */		
		public function setLineStyle( thick:Number = 0, color:uint = 0, alpha:Number = 1 ):GFMeganeClip
		{
			_g.lineStyle( thick, color, alpha );
			return this;
		}
		
		
		
		/**
		 * 線の描画で使用するビットマップを指定します。
		 * @param bitmap:BitmapData  線を描画するときに使用するビットマップ
		 * @param matrix:Matrix 変換マトリクス
		 * @param repeat:Boolean ビットマップを繰り返すかどうか
		 * @param smooth:Boolean ビットマップにスムージングを適用するかどうか
		 * @return GFMeganeClip
		 * 
		 */		
		public function setBitmapLine( bitmap:BitmapData, matrix:Matrix = null, repeat:Boolean = true, smooth:Boolean = false ):GFMeganeClip
		{
			_g.lineBitmapStyle( bitmap, matrix, repeat, smooth );
			return this;
		}
		
		
		
		/**
		 * 線の描画で使用するグラデーションを指定します。
		 * @param colors:Array グラデーションで使用する塗り色を格納した配列
		 * @param alphas:Array colors 配列内の各色に対応した透明度を格納した配列
		 * @param ratios:Array 色分布比率の配列
		 * @param type:String 使用するグラデーションのタイプを指定します。
		 * @param matrix:Matrix @default = null 塗の変換マトリックスを指定します。
		 * @param spreadMethod:String @defualt = "pad" 使用する spread メソッドを指定します。
		 * @param interpolationMethod:String @default = "rgb" 使用する interpolationMethod を指定します。
		 * @param focalPointRatio:Number @default = 0 グラデーションの焦点位置を制御する数値です。
		 * @return GFMeganeClip
		 */		
		public function setGradientLine( colors:Array, alphas:Array, ratios:Array, type:String = GradientType.LINEAR, matrix:Matrix = null, spreadMethod:String = SpreadMethod.PAD, interpolationMethod:String = InterpolationMethod.RGB, focalPointRatio:Number = 0 ):GFMeganeClip
		{
			_g.lineGradientStyle( type, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio );
			return this;
		}
		
		
		
		/**
		 * 線の描画で、線として使用するシェーダーを指定します。 
		 * @param shader
		 * @param matrix
		 * @return GFMeganeClip
		 * 
		 */		
		public function setShaderLine( shader:Shader, matrix:Matrix = null ):GFMeganeClip
		{
			_g.lineShaderStyle( shader, matrix );
			return this;
		}
		
		
		
		/**
		 * 線の詳細な設定を指定します。 
		 * @param thick:Number 線の幅
		 * @param color:uint 線の色
		 * @param alpha:Number 線の透明度
		 * @param pixelHint:Boolean ピクセルフィットするかどうか
		 * @param scaleMode:String スケールモードを設定します。
		 * @param caps:String	線の終端を設定します。
		 * @param joints:String 核で使用する接合点の外観を設定します。
		 * @param miterLimit:Number マイターが切り取られる限度を示す数値です。
		 * @return GFMeganeClip
		 */		
		public function setLineStyleFull( thick:Number = NaN, color:uint = 0, alpha:Number = 1, pixelHint:Boolean = false, scaleMode:String = "normal", caps:String = null, joints:String = null, miterLimit:Number = 3 ):GFMeganeClip
		{
			_g.lineStyle( thick, color, alpha, pixelHint, scaleMode, caps, joints, miterLimit );
			return this;
		}
		
		
		
		/**
		 * 描画時の他隠逸の塗り色を一括で指定します。 
		 * @param color:uint 塗りの色 @default0
		 * @param alpha:Number 塗りの透明度 @default 1
		 * @return GFMeganeClip
		 */		
		public function setFillStyle( color:uint = 0, alpha:Number = 1 ):GFMeganeClip
		{
			_fillCol = color;
			_fillAlpha = alpha;
			return this;
		}
		
		
		
		/**
		 * Graphics をクリアーします。 
		 * @return GFMeganeClip
		 */		
		public function clear():GFMeganeClip
		{
			_g.clear();
			return this;
		}
		
		
		
		/**
		 * 線を描画します。 
		 * @param x0:Number 開始 x 位置
		 * @param y0:Number 開始 y 位置
		 * @param x1:Number 終了 x 位置
		 * @param y1:Number 終了 y 位置
		 * @return GFMeganeClip
		 */		
		public function line( x0:Number, y0:Number, x1:Number, y1:Number):GFMeganeClip
		{
			//ふむ…
			_g.moveTo( x0, y0 );
			_g.lineTo( x1, y1 );
			return this;
		}
		
		
		
		/**
		 * 曲線を描画します。
		 * @param x0:Number 線の開始 x 位置
		 * @param y0:Number 線の開始 y 位置
		 * @param x1:Number 線の終了 x 位置
		 * @param y1:Number 線の終了 y 位置
		 * @param x2:Number コントロールポイントの x 位置
		 * @param y2:Number コントロールポイントの y 位置
		 * @return GFMeganeClip
		 */		
		public function curve( x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number ):GFMeganeClip
		{
			_g.moveTo( x0, y0 );
			_g.curveTo( x2, y2, x1, y1 );
			return this;
		}
		
		
		
		/**
		 * 単一色の塗りを実行します。
		 * @param color:uint
		 * @return GFMeganeClip
		 */		
		public function fill( color:uint = uint.MAX_VALUE ):GFMeganeClip
		{
			if( color != uint.MAX_VALUE ){ _fillCol = color; }
			_g.beginFill( _fillCol, _fillAlpha );
			return this;
		}
		
		
		
		/**
		 * グラデーションの塗を実行します。 
		 * @param colors:Array グラデーションで使用する塗り色を格納した配列
		 * @param alphas:Array colors 配列内の各色に対応した透明度を格納した配列
		 * @param ratios:Array 色分布比率の配列
		 * @param type:String 使用するグラデーションのタイプを指定します。
		 * @param matrix:Matrix @default = null 塗の変換マトリックスを指定します。
		 * @param spreadMethod:String @defualt = "pad" 使用する spread メソッドを指定します。
		 * @param interpolationMethod:String @default = "rgb" 使用する interpolationMethod を指定します。
		 * @param focalPointRatio:Number @default = 0 グラデーションの焦点位置を制御する数値です。
		 * @return GFMeganeClip
		 */				
		public function gradient( colors:Array, alphas:Array, ratios:Array, type:String = GradientType.LINEAR, matrix:Matrix = null, spreadMethod:String = SpreadMethod.PAD, interpolationMethod:String = InterpolationMethod.RGB, focalPointRatio:Number = 0 ):GFMeganeClip
		{
			_g.beginGradientFill( type, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio );
			return this;
		}
		
		
		
		/**
		 * グラデーションの塗を実行します。
		 * パラメーターをオブジェクトで指定できます。 
		 * @param params:Object
		 * @return 
		 * 
		 */		
		public function gradAsObj( params:Object ):GFMeganeClip
		{
			if(!params["colors"] || !params["alphas"] || !params["ratios"] ){ throw new Error( "必須プロパティがかけています。" ); } 
			
			_g.beginGradientFill( params["type"], params["colors"], params["alphas"], params["ratios"], params["matrix"], params["spreadMethod"], params["interpolationMethod"], params["focalPointRatio"] );
			return this;
		}
		
		
		
		/**
		 * ビットマップでの塗を実行します。 
		 * @param bitmapData:BitmapData
		 * @param matrix:Matrix
		 * @return GFMeganeClip
		 */		
		public function bitmapFill(bitmapData:BitmapData = null, matrix:Matrix = null, repeat:Boolean = true, smooth:Boolean = false):GFMeganeClip
		{
			if( bitmapData != null ) _fillBmd = bitmapData;
			if( matrix != null ) _fillMat = matrix;
			_g.beginBitmapFill( bitmapData, matrix, repeat, smooth );
			return this;
		}
		
		
		
		/**
		 * シェイダーでの塗を実行します。 
		 * @param shader
		 * @param matrix
		 * @return 
		 * 
		 */		
		public function shaderFill( shader:Shader = null, matrix:Matrix = null ):GFMeganeClip
		{
			if( shader != null ) _fillShader = shader;
			if( matrix != null ) _fillMat = matrix;
			_g.beginShaderFill( _fillShader, _fillMat );
			return this;
		}
		
		
		
		/**
		 * 矩形を描きます。
		 * @param x:Number 矩形の x 位置
		 * @param y:Number 矩形の y 位置
		 * @param width:Number 矩形の幅
		 * @param height:Number 矩形の高さ
		 * @return GFMeganeClip
		 */		
		public function square(x:Number, y:Number, width:Number, height:Number):GFMeganeClip
		{
			_g.drawRect( x, y, width, height );
			return this;
		}
		
		
		
		/**
		 * 円を描きます。 
		 * @param x:Number 円の x 位置
		 * @param y:Number 円の y 位置
		 * @param radius:Number 円の半径
		 * @return GFMeganeClip
		 * 
		 */		
		public function circle( x:Number, y:Number, radius:Number ):GFMeganeClip
		{
			_g.drawCircle( x, y, radius );
			return this;
		}
		
		
		
		/**
		 * 楕円を描画します。 
		 * @param x:Number 円の x 位置
		 * @param y:Number 円の y 位置
		 * @param width:Number 円の幅
		 * @param height:Number 円の高さ
		 * @return GFMeganeClip
		 * 
		 */		
		public function ellipse(x:Number, y:Number, width:Number, height:Number):GFMeganeClip
		{
			_g.drawEllipse( x, y, width, height );
			return this;
		}
		
		
		
		/**
		 * 角丸の矩形を描画します。 
		 * @param x:Number 矩形の x 位置 
		 * @param y:Number 矩形の y 位置
		 * @param width:Number 矩形の幅
		 * @param height:Number 矩形の高さ
		 * @param radius:Number 角丸の半径
		 * @return GFMeganeClip
		 */		
		public function roundRect( x:Number, y:Number, width:Number, height:Number, radius:Number ):GFMeganeClip
		{
			_g.drawRoundRect( x, y, width, height, radius, radius );
			return this;
		}
		
		
		
		/**
		 *  描画を終了します。 
		 */		
		public function end():void
		{
			_g.endFill();
		}
		
		
		/*/////////////////////////////////
			private methods
		/*/////////////////////////////////
		
		
		private function _addChildAt( child:DisplayObject, index:int ):DisplayObject
		{
			_children.push( super.addChildAt( child, index ));
			return child;
		}
		
		
		
		private function _removeChildAt( index:int ):DisplayObject
		{
			var child:DisplayObject = super.removeChildAt( index );
			var len:int = this.numChildren;
			for( var i:int = 0; i < len; i++ ){ if( _children[i] == child ){ _children.splice( i, 1 ); return child; } }
			return child;
		}
		
		
				
		/** 縦横比固定用　変更前の幅保持 */
		private var _prevW:Number;
		
		/** 縦横比固定用　変更前の高さ保持 */
		private var _prevH:Number;
		
		
		private var _children:Array;
		private var _listeners:GFUniqueCollection;
		private var _numListeners:uint = 0;
		private var _g:Graphics;
		private var _thick:Number = 0;
		private var _fillCol:uint = 0;
		private var _fillAlpha:Number = 1;
		private var _fillBmd:BitmapData;
		private var _fillShader:Shader;
		private var _fillMat:Matrix;
	}
}


/**
 * 無理やり一枚にまとめるために… 
 * @author glassesfactory
 */
class GFUniqueCollection
{
	public function get numItems():uint{ return _collection.length; }
	
	//Constractor
	public function GFUniqueCollection( ...items:Array )
	{
		for( var i:int = 0; i < items.length; i++ )
		{
			_addItemAt( items[i], _collection.length );
		}
	}
	
	public function addItem( item:* ):*{ return _addItemAt( item, _collection.length ); }
	
	
	public function addItemAt( item:*, index:int ):*{ return _addItemAt( item, index ); }
	
	
	public function addItems( ...items:Array ):*
	{
		var objs:Array = [];
		for( var i:int = 0; i < items.length; i++ )
		{
			objs.push( _addItemAt( items[i], _collection.length ));
		}
		return objs;
	}
	
	
	public function removeItem( item:* ):*
	{
		var ind:int = getItemIndex( item );
		return _removeItemAt( ind );
	}
	
	public function removeItemAt( index:int ):*{ return _removeItemAt( index ); }
	
	public function getItemIndex( item:* ):int
	{
		var len:uint = _collection.length;
		for( var i:int = 0; i < len; i++ )
		{
			if( _collection[i] === item ){ return i; }
		}
		return -1;
	}
	
	
	public function getItemAt( index:int ):*{ return _collection[index] as Object }
	
	
	public function toArray():Array
	{
		return _collection.slice();
	}
	
	private function _addItemAt( item:*, index:int ):*
	{
		//すでに登録があった場合は配列の中身を更新します。
		var ind:int = getItemIndex( item );
		if( ind > -1 )
		{
			_removeItemAt(ind);
		}
		
		_collection.splice( index, 0, item );
		return item; 
	}
	
	
	
	private function _removeItemAt( index:int ):*{ _collection.splice( index, 1 ); }
	
	
	/**
	 *  
	 * @param index
	 * @return 
	 */		
	public function hasItem( item:* ):Boolean
	{
		var len:uint = super.length;
		for( var i:int = 0; i < len; i++ )
		{
			if( _collection[i] === item ){ return true; }
		}
		return false; 
	}
	
	private var _collection:Array;
}
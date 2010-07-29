/*//////////////////////////////////
* TextField作成クラス
*//////////////////////////////////

package net.glassesfactory.utils
{
	import flash.text.*;
	
	public class TextMaker
	{
		public function TextMaker(){}
		
		public static function makeTextField( str:String, size:Number, font:Font = null, useHtml:Boolean = false, w:Number = NaN, color:uint = 0xffffff ):TextField
		{
			var tf:TextField = new TextField();
			var tfm:TextFormat = new TextFormat();
			tfm.size = size;
			tfm.color = color;
			if( font ){ tfm.font = font.fontName; }
			else{ tfm.font = "_ゴシック"; }
			tf.embedFonts = true;
			tf.defaultTextFormat = tfm;
			tf.wordWrap = true;
			tf.autoSize = TextFieldAutoSize.LEFT;
			if( w ) tf.width = w;
			if( useHtml )	tf.htmlText = str;
			else tf.text = str;
			return tf;
		}
		
		public static function makeInputField( size:Number, font:Font, col:uint = 0, defStr:String = "", isMultiline:Boolean = false, w:Number = NaN, h:Number = NaN ):TextField
		{
			var tf:TextField = new TextField();
			var tfm:TextFormat = new TextFormat();
			tfm.size =  size;
			tfm.color =  col;
			if( font ){ tfm.font = font.fontName;}
			else{ tfm.font = "_ゴシック"; }
			tf.embedFonts = true;
			tf.defaultTextFormat = tfm;
			tf.wordWrap = true;
			tf.autoSize = TextFieldAutoSize.NONE;
			tf.type = TextFieldType.INPUT;
			tf.multiline = isMultiline;
			if( w ){ tf.width = w; }
			if( h ){ tf.height = h; }
			if( defStr != "" ){ tf.text = defStr; }
			return tf;
		}
	}
}
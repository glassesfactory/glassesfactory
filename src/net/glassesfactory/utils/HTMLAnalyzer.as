/*
 Strign中のHTMLを解析してタグ抽出させる
 最初の参考:http://f-site.org/articles/2006/07/12085255.html
 まぁこっからHTML解析用のクラスでも作って行くか。
*/

package net.glassesfactory.utils
{
	public class HTMLAnalyzer
	{
		public function HTMLAnalyzer(){}
		
		/**
		 * <p>複数のIMGタグからSRCを抽出。<br/>
		 * 結果をArrayにいれて返す。
		 * @param	str	String　抽出したい元HTML<br/>
		 * @return	matchStr	Array	抽出されたURLが格納された配列
		 */
		public static function getAnalyzeIMGStr(str:String):Array
		{
			var myPattern1:RegExp = /src=\"(.*?)\"/ig;
			//var matchStr:Array= str.match( myPattern1 );
			//var matchAry:Array = matchStr.map( removeSrc );
			var matchAry:Array = str.match( myPattern1 ).map( removeSrc );
			return matchAry;
		}
		
		public static function getAnalyzeAHerf( str:String ):Array
		{
			var myPattern2:RegExp = /href=\"(.*?)\"/ig;
			//var matchHref:Array = str.match( myPattern2 );
			var matchAry:Array = str.match( myPattern2 ).map( removeHref );
			return matchAry;
		}
		
		private static function removeSrc( str:String,i:int, ary:Array ):String
		{
			var result:String = str.substring( 5, str.length );
			var result2:String = result.substr( 0, result.length - 1);
			return result2;
		}
		
		private static function removeHref( str:String, i:int, ary:Array ):String
		{
			var result:String = str.substring( 6, str.length );
			var result2:String = result.substr( 0, result.length - 1 );
			return result2;
		}
	}
}
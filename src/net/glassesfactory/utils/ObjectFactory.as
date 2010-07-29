/*////////////////////////////////////////////

glassesfactory

Autor MEGANE
Copyright 2010 glasses factory
http://glasses-factory.net

/*////////////////////////////////////////////

/**
 * オブジェクト周り便利クラス
 */

package net.glassesfactory.utils
{
	
	
	
	public class ObjectFactory
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
		
		
		/*/////////////////////////////////
		* public methods
		/*/////////////////////////////////
		
		/**
		 * @public static
		 * 保持しているプロパティ名を配列にして返す
		 * @param target 抽出したいターゲットとなるオブジェクト
		 * --------------------------------------------------------------
		 * @return names プロパティ名を抽出して格納した配列
		 */
		public static function getPropertyNames( target:Object ):Array
		{
			var names:Array = [];
			
			for( var name:String in target )
			{
				names.push( name );
			}
			
			return names;
		}
		
		/**
		 * @public static
		 * プロパティの動的引継
		 * @param prop 引継たいプロパティをまとめたオブジェクト
		 * @param target ターゲットとなるオブジェクト
		 * --------------------------------------------------------------
		 * @return target　引継ぎ済みのオブジェクトを返す 
		 */
		public static function setProperties( prop:Object, target:Object = null ):Object
		{
			if( target == null ){ target = {} }
			
			for( var pram:String in prop )
			{
				target[pram] = prop[pram];
			}
			
			return target; 
		}
		
		//Constractor
		public function ObjectFactory()
		{
		}
	}
}
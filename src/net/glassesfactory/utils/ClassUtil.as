/*////////////////////////////////////////////

glassesfactory

Autor	YAMAGUCHI EIKICHI
Date	2010/04/25

Copyright 2010 glasses factory
http://glasses-factory.net

/*////////////////////////////////////////////

/**
 * Class便利クラス
 */
package net.glassesfactory.utils
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.system.ApplicationDomain;
	
	public class ClassUtil
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
		
		//Constractor
		public function ClassUtil()
		{
			throw new ArgumentError("インスタンス化できません", 2012);
		}
		
		public static function getClass( name:String ):*
		{
			var classRef:Class = ApplicationDomain.currentDomain.getDefinition( name ) as Class;
			return new classRef();
		}
		
		//暫定
		public static function getBitmapDataClass( name:String, w:Number, h:Number ):*
		{
			var classRef:Class = ApplicationDomain.currentDomain.getDefinition( name ) as Class;
			return new classRef( w, h );
		}
		
		public static function duplicate( target:MovieClip ):*
		{
			var classRef:Class = target.constructor;
			var copy:* = new classRef();
			return copy;
		}
		
		/*/////////////////////////////////
		* private methods
		/*/////////////////////////////////
		
		
		/*/////////////////////////////////
		* private variables
		/*/////////////////////////////////
	}
}
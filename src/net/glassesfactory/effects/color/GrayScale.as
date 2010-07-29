/*////////////////////////////////////////////

glassesfactory

Autor	YAMAGUCHI EIKICHI
Date	2010/07/12

Copyright 2010 glasses factory
http://glasses-factory.net

/*////////////////////////////////////////////

package net.glassesfactory.effects.color
{
	import flash.display.DisplayObject;
	import flash.filters.ColorMatrixFilter;
	
	import net.glassesfactory.effects.IEffect;
	
	public class GrayScale implements IEffect
	{
		/*/////////////////////////////////////////
		 * public consts
		/*/////////////////////////////////////////
		
		/*/////////////////////////////////////////
		 * public vars
		/*/////////////////////////////////////////
		
		
		/*/////////////////////////////////////////
		 * getter
		/*/////////////////////////////////////////
		
		
		/*/////////////////////////////////////////
		 * setter
		/*/////////////////////////////////////////
		
		
		/*/////////////////////////////////////////
		 * public methods
		/*/////////////////////////////////////////
		
		//Constractor
		public function GrayScale( target:DisplayObject )
		{
			_target = target;
			_originalFilters = target.filters;
		}
		
		/**
		 * フィルタを適用
		 * @param	brightness 明るさ
		 */
		public function apply( brightness:int = 0 ):void
		{
			var tmpFilters:Array = _target.filters;
			var grayFilter:ColorMatrixFilter = getGrayFilter( brightness );
			tmpFilters.push( grayFilter );
			_target.filters = tmpFilters;
		}
		
		/**
		 * フィルタのリセット
		 */
		public function reset():void
		{
			_target.filters = _originalFilters;
		}
		
		
		/*/////////////////////////////////////////
		 * private methods
		/*/////////////////////////////////////////
		
		private function getGrayFilter( brightness:int = 0 ):ColorMatrixFilter
		{
			var mt:Array = [];
			var ra:Number = 0.298912;
			var ga:Number = 0.586611;
			var ba:Number = 0.114478;
			mt = mt.concat([ ra, ga, ba, 0, brightness ]);
			mt = mt.concat([ ra, ga, ba, 0, brightness ]);
			mt = mt.concat([ ra, ga, ba, 0, brightness ]);
			mt = mt.concat([ 0, 0, 0, 1, 0 ]);
			var grayMatrix:ColorMatrixFilter = new ColorMatrixFilter( mt );
			return grayMatrix; 
		}
		
		
		/*/////////////////////////////////////////
		 * private vars
		/*/////////////////////////////////////////
		
		private var _target:DisplayObject;
		
		private var _originalFilters:Array;
	}
}
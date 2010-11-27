/*////////////////////////////////////////////

glassesfactory

Autor	YAMAGUCHI EIKICHI
(@glasses_factory)
Date	2010/11/25

Copyright 2010 glasses factory
http://glasses-factory.net

/*////////////////////////////////////////////

package net.glassesfactory.events
{
	import flash.events.Event;
	
	public class GFTwitterProxyEvent extends Event
	{
		/*/////////////////////////////////
		* public variables
		/*/////////////////////////////////
		
		public static const LOAD_COMPLETE:String = "load_complete";
		
		/*/////////////////////////////////
		* getter
		/*/////////////////////////////////
		
		public function get result():Object{ return _result; }
		private var _result:Object;
		
		/*/////////////////////////////////
		* setter
		/*/////////////////////////////////
		
		
		/*/////////////////////////////////
		* public methods
		/*/////////////////////////////////
		
		//Constractor
		public function GFTwitterProxyEvent(type:String, result:Object, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_result = result;
		}
		
		
		override public function clone():Event
		{
			return new GFTwitterProxyEvent( type, _result, bubbles, cancelable ); 
		}
		
		
		/*/////////////////////////////////
		* private methods
		/*/////////////////////////////////
		
		
		/*/////////////////////////////////
		* private variables
		/*/////////////////////////////////
		
		
	}
}
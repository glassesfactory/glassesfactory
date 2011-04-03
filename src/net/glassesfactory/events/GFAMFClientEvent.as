/*////////////////////////////////////////////

glassesfactory

Autor	YAMAGUCHI EIKICHI
(@glasses_factory)
Date	2011/04/03

Copyright 2010 glasses factory
http://glasses-factory.net

/*////////////////////////////////////////////

package net.glassesfactory.events
{
	import flash.events.Event;
	
	public class GFAMFClientEvent extends Event
	{
		/*/////////////////////////////////
		* public variables
		/*/////////////////////////////////
		
		
		/*=====================================
		 EventType
		======================================*/
		
		public static const CONNECT:String = "connect";
		public static const COMPLETE:String = "complete";
		public static const REQUEST_FAULT:String = "request_fault";
		public static const CLIENT_ERROR:String = "client_error";
		
		
		public function get result():Object{ return _result; }
		private var _result:Object;
		
		public var text:String;
		
		/*/////////////////////////////////
		* public methods
		/*/////////////////////////////////
		
		//Constractor
		public function GFAMFClientEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, result:Object = null )
		{
			super(type, bubbles, cancelable);
			_result = result;
		}
		
		
		/*/////////////////////////////////
		* private methods
		/*/////////////////////////////////
		
		
		/*/////////////////////////////////
		* private variables
		/*/////////////////////////////////
		
		
	}
}
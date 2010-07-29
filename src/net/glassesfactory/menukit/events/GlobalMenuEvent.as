package net.glassesfactory.menukit.events
{
	import flash.events.Event;
	
	public class GlobalMenuEvent extends Event
	{
		/*/////////////////////////////////
			public static const
		/*/////////////////////////////////
		
		public static const CHANGED:String = "changed";
		
		public static const OVER:String = "over";
		
		public static const OUT:String = "out";
		
		public static const HIDE:String = "hide";
		
		
		/*/////////////////////////////////
			getter
		/*/////////////////////////////////
		
		public function get index():uint
		{
			return _index;
		}
		
		
		/*/////////////////////////////////
			public methods
		/*/////////////////////////////////
		
		//Constractor
		public function GlobalMenuEvent( type:String,index:uint = 0 )
		{
			super(type);
			this._index = index
			return;
		}
		
		override public function clone():Event
		{
			return new GlobalMenuEvent( type, index );
		}
		
		override public function toString():String
		{
			return formatToString( "GlobalMenuEvent", "type", "bubbles", "cancelable", "index" )
		}
		
		
		/*/////////////////////////////////
			public variables
		/*/////////////////////////////////
		
		private var _index:uint; 
	}
}
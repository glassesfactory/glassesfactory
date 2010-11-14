package net.glassesfactory.events
{
	import flash.events.Event;
	
	public class GFWindowEvent extends Event
	{
		public static const WINDOW_ACTIVE:String = "onWindowActive";
		public static const WINDOW_DEACTIVE:String = "onWindowDeactive";
		
		
		public function GFWindowEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
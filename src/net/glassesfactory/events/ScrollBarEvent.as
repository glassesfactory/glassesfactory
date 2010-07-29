package net.glassesfactory.events
{
	import flash.events.Event;

	public class ScrollBarEvent extends Event
	{ 
		public static const VALUE_CHANGED:String = "value_changed";
		
		private var _v:Number;
		
		public function get v():Number
		{
			return _v;
		}
		
		public function ScrollBarEvent( type:String,vect:Number ):void
		{
			super( type );
			this._v = vect;
			return;
		}
		
		override public function clone():Event
		{
			return new ScrollBarEvent(type,v);
		}
		
		override public function toString():String
		{
			return formatToString("ScrollBarEvent","type","bubbles","cancelable","v");
		}
	}
}
package net.glassesfactory 
{
	public class SimpleFunnelBase
	{
		//x位置:整数値
		public var x:int;
		
		//y位置:整数値
		public var y:int;
		
		//x速度:数字
		public var vx:Number;
		
		//y速度:数字
		public var vy:Number;
		
		//x保持
		public var x0:Number;
		
		//y保持
		public var y0:Number;
		
		public function SimpleFunnelBase()
		{
			x = 0;
			y = 0;
			vx = 0;
			vy = 0;
			x0 = 0;
			y0 = 0;
		}
	}
}
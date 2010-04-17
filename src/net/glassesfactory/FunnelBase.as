package net.glassesfactory 
{
	public class FunnelBase extends SimpleFunnelBase
	{
		//角速度
		public var vr:Number;
		
		//x加速度
		public var ax:Number;
		
		//y加速度
		public var ay:Number;
		
		//角加速度
		public var ar:Number;
		
		//x力
		public var fx:Number;
		
		//y力
		public var fy:Number;
		
		//角力
		public var fr:Number;
		
		//重み
		public var mass:Number;
		
		//角度
		public var rad:Number;
		
		//揺らぎ
		public const rnd:Number = Math.random() * 1.658568;
		
		public function FunnelBase()
		{
			super();
			vr = 0;
			ax = 0;
			ay = 0;
			ar = 0;
			fx = 0;
			fy = 0;
			fr = 0;
			mass = 1;
			rad = 0;
		}
	}
}
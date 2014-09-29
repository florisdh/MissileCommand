package Factories 
{
	import flash.geom.Vector3D;
	import GameObjects.Rockets.FastRocket;
	import GameObjects.Rockets.Rocket;
	import GameObjects.Rockets.SlowRocket;
	/**
	 * ...
	 * @author FDH
	 */
	public class RocketFactory extends Factory 
	{
		// -- Static -- //
		
		public static const ROCKET_SLOW:uint = 0;
		public static const ROCKET_NORMAL:uint = 1;
		public static const ROCKET_FAST:uint = 2;
		
		// -- Properties -- //
		
		// -- Vars -- //
		
		// -- Construct -- //
		
		public function RocketFactory(engine:Engine) 
		{
			super(engine);
			
		}
		
		// -- PublicMethods -- //
		
		public function AddRocket(start:Vector3D, target:Vector3D, rocketType:uint):void 
		{
			var rocket:Rocket = _getRocket(rocketType);
			rocket.Position = start;
			rocket.Target = target;
			TargetEngine.AddObject(rocket);
		}
		
		// -- PrivateMethods -- //
		
		private function _getRocket(type:uint):Rocket
		{
			switch (type) 
			{
				case ROCKET_SLOW:
					return new SlowRocket();
				break;
				case ROCKET_NORMAL:
					return new Rocket();
				break;
				case ROCKET_FAST:
					return new FastRocket();
				break;
				default:
					return null;
			}
		}
	}

}
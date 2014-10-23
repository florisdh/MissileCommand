package Factories 
{
	import flash.geom.Vector3D;
	import GameObjects.GameObj;
	import GameObjects.Rockets.PlayerRocket;
	import GameObjects.Rockets.Rocket;
	import GameObjects.Rockets.EnemyRocket1;
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
		
		// -- Overrides -- //
		
		override protected function getType(type:int):GameObj 
		{
			switch (type) 
			{
				case ROCKET_SLOW:
					return new EnemyRocket1();
				break;
				case ROCKET_NORMAL:
					return new Rocket();
				break;
				case ROCKET_FAST:
					return new PlayerRocket();
				break;
				default:
					return null;
			}
		}
	}

}
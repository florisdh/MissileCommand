package Factories 
{
	import flash.geom.Vector3D;
	import GameObjects.GameObj;
	import GameObjects.Rockets.EnemyRocket2;
	import GameObjects.Rockets.EnemyRocket3;
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
		
		public static const ROCKET_PLAYER:uint = 0;
		public static const ROCKET_ENEMY1:uint = 1;
		public static const ROCKET_ENEMY2:uint = 2;
		public static const ROCKET_ENEMY3:uint = 3;
		
		// -- Overrides -- //
		
		override protected function getType(type:int):GameObj 
		{
			switch (type) 
			{
				case ROCKET_PLAYER:
					return new PlayerRocket();
				break;
				case ROCKET_ENEMY1:
					return new EnemyRocket1();
				break;
				case ROCKET_ENEMY2:
					return new EnemyRocket2();
				break;
				case ROCKET_ENEMY3:
					return new EnemyRocket3();
				break;
				default:
					return null;
			}
		}
	}

}
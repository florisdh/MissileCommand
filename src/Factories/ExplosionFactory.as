package Factories 
{
	import GameObjects.Explosion;
	import GameObjects.GameObj;
	/**
	 * ...
	 * @author FDH
	 */
	public class ExplosionFactory extends Factory 
	{
		
		override protected function getType(type:int):GameObj 
		{
			var explosion:Explosion = new Explosion();
			
			switch (type) 
			{
				case 0:
					explosion.Scale = 0.2;
				break;
				case 1:
					explosion.Scale = 0.4;
				break;
				case 2:
					explosion.Scale = 0.6;
				break;
				case 3:
					explosion.Scale = 0.8;
				break;
				case 4:
					explosion.Scale = 1;
				break;
				case 5:
					explosion.Scale = 1.2;
				break;
				default:
			}
			
			return explosion;
		}
		
	}

}
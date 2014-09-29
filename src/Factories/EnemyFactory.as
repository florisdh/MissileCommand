package Factories 
{
	/**
	 * ...
	 * @author FDH
	 */
	public class EnemyFactory extends Factory 
	{
		// -- Properties -- //
		
		// -- Vars -- //
		
		//
		private var _missileFactory:RocketFactory;
		
		// -- Construct -- //
		
		public function EnemyFactory(missileFactory:RocketFactory) 
		{
			_missileFactory = missileFactory;
			super(_missileFactory.TargetEngine);
		}
		
		// -- PublicMethods -- //
		
		
	}

}
package
{
	/**
	 * ...
	 * @author FDH
	 */
	public class Settings 
	{
		// -- Properties -- //
		
		// Shoot interval of player bases
		public var PlayerBasesSchootInterval:Vector.<int>;
		
		public var PlayerRocketSpeed:Number = 20;
		
		public var EnemyRocketSpeed:Number = 2;
		
		// -- Construct -- //
		
		public function Settings() 
		{
			Reset();
		}
		
		// -- PublicMethods -- //
		
		public function Reset()
		{
			PlayerBasesSchootInterval = new <int> [ 500, 500, 500 ];
			
		}
	}

}
package Factories 
{
	import GameObjects.Cars.Car;
	import GameObjects.Cars.Car1;
	import GameObjects.GameObj;
	/**
	 * ...
	 * @author FDH
	 */
	public class CarFactory extends Factory 
	{
		// -- Static -- //
		
		public static const Car_1:uint = 0;
		public static const Car_2:uint = 1;
		
		// -- Overrides -- //
		
		override protected function getType(type:int):GameObj 
		{
			switch (type) 
			{
				case Car_1:
					return new Car1();
				break;
				case Car_2:
					throw new Error("ERROR: Car 2 has not been implemented yet.");
				break;
				default:
					return null;
			}
		}
		
	}

}
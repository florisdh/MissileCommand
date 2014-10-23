package GameObjects.Cars {
	import flash.events.Event;
	import GameObjects.GameObj;
	/**
	 * ...
	 * @author FDH
	 */
	public class Car extends GameObj 
	{
		// -- Properties -- //
		
		public var Speed:Number = 3;
		
		// -- Vars -- //
		
		// -- Construct -- //
		
		public function Car() 
		{
			super();
			WillExplode = false;
			Collide = false;
		}
		
		// -- Overrides -- //
		
		override public function update(e:Event):void 
		{
			_velo.x = Speed;
			
			super.update(e);
		}
		
		// -- Methods -- //
		
		
		
	}

}
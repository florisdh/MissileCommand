package Factories {
	import GameObjects.GameObj;
	/**
	 * ...
	 * @author FDH
	 */
	public class Factory 
	{
		// -- Properties -- //
		
		// -- Vars -- //
		
		// -- PublicMethods -- //
		
		public function create(type:int, engine:Engine):GameObj
		{
			var newObj:GameObj = getType(type);
			engine.AddObject(newObj);
			return newObj;
		}
		
		protected function getType(type:int):GameObj
		{
			throw new Error("Abstract class, override is required.");
		}
	}

}
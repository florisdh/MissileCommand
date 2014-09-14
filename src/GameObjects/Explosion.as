package GameObjects 
{
	import flash.events.Event;
	/**
	 * ...
	 * @author FDH
	 */
	public class Explosion extends GameObj 
	{
		
		public function Explosion() 
		{
			_baseObj = new Art_Explosion();
			super();
		}
		
		override public function update(e:Event):void 
		{
			super.update(e);
			
			// Check if anim done
			if (_baseObj.currentFrameLabel != "Explode")
			{
				Destroy();
			}
			
			// Set collision bounds
			CollisionRange = _baseObj.width / 2;
		}
		
	}

}
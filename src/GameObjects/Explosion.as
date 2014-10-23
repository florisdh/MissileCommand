package GameObjects 
{
	import flash.events.Event;
	import flash.media.Sound;
	/**
	 * ...
	 * @author FDH
	 */
	public class Explosion extends GameObj 
	{
		private var _lastFrameInd:int = 0;
		
		private var _sound:Sound;
		
		public function Explosion() 
		{
			_baseObj = new Art_Explosion();
			super();
			WillExplode = false;
			_sound = new Sound_Explosion();
			_sound.play();
		}
		
		override public function update(e:Event):void 
		{
			super.update(e);
			
			// Check if anim done
			if (_baseObj.currentFrameLabel != "Explode" || _baseObj.currentFrame < _lastFrameInd)
			{
				Destroy();
			}
			
			// Set collision bounds
			CollisionRange = _baseObj.width / 2;
			
			_lastFrameInd = _baseObj.currentFrame;
		}
		
	}

}
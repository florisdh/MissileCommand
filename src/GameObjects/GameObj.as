package GameObjects 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Vector3D;
	import GameObjects.Events.ObjectEvent;
	
	/**
	 * ...
	 * @author FDH
	 */
	public class GameObj extends Sprite 
	{
		// Event types
		public static const DESTROY:String = "DESTROY";
		
		// -- Properties -- //
		
		// If the obj is not destroying and not destroyed
		public var IsAlive:Boolean = true;
		
		// Base Art Object
		protected var _baseObj:MovieClip;
		
		// Forces
		protected var _velo:Vector3D = new Vector3D();
		
		public function GameObj() 
		{
			if (_baseObj) addChild(_baseObj);
		}
		
		public function update(e:Event):void 
		{
			// Apply velo on object
			this.x += _velo.x;
			this.y += _velo.y;
			
			// Clear Velo
			_velo.scaleBy(0);
		}
		
		public function Destroy():void 
		{
			if (!IsAlive) return;
			IsAlive = false;
			dispatchEvent(new ObjectEvent(GameObj.DESTROY, this));
		}
	}

}
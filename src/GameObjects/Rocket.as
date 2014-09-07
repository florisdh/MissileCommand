package GameObjects 
{
	import adobe.utils.CustomActions;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Vector3D;
	
	/**
	 * ...
	 * @author FDH
	 */
	public class Rocket extends GameObj 
	{
		// -- EVENTS -- //
		
		public static const EXPLODE:String = "EXPLODE";
		
		// -- Properties -- //
		
		// Speed to move at
		public var Speed:Number = 8;
		
		// Velo of the rocket's engine
		public var _thrustVelo:Vector3D;
		
		// -- Vars -- //
		
		// Target to go to
		private var _target:Vector3D;
		
		// Distance to target
		private var _explodeDistance:Number = 15;
		private var _disToTarget:Number;
		private var _lastDisToTarget:Number;

		// -- Construct -- //
		
		public function Rocket() 
		{
			_baseObj = new Missile();
			_baseObj.rotation = -90;
			_baseObj.scaleX = 0.5;
			_baseObj.scaleY = 0.5;
			super();
		}
		
		// -- Overrides -- //
		
		override public function update(e:Event):void 
		{
			if (!IsAlive) return;
			
			// Calculate current frame movement
			_velo = _velo.add(_thrustVelo);
			
			// Add distance
			_lastDisToTarget = _disToTarget;
			_disToTarget = _calcDisToTarget();
			if (_disToTarget > _lastDisToTarget || _disToTarget <= _explodeDistance)
			{
				Destroy();
			}
			
			super.update(e);
		}
		
		// -- Methods -- //
		
		private function _calcMoveDir(multiplier:Number = 1):Vector3D
		{
			// Calc offset from this to target
			var rv:Vector3D = new Vector3D
			(
				_target.x - this.x,
				_target.y - this.y
			);
			
			// Normalize vector & store distance to target
			_disToTarget = rv.normalize();
			
			// Apply multiplier
			rv.scaleBy(multiplier);
			
			return rv;
		}
		
		private function _calcDisToTarget():Number
		{
			return Vector3D.distance(new Vector3D(this.x, this.y), _target);
		}
	
		public function set Target(newVal:Vector3D):void
		{
			_target = newVal;
			_thrustVelo = _calcMoveDir(Speed);
			RotateToPoint(newVal);
		}
		
		public function RotateToPoint(target:Vector3D):void 
		{
			var rad:Number = Math.atan2(_target.y - this.y, _target.x - this.x);
			this.rotation = rad * 180 / Math.PI;
		}
	}

}
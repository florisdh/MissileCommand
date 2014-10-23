package Controllers 
{
	import Factories.RocketFactory;
	import flash.geom.Vector3D;
	import GameObjects.Events.ObjectEvent;
	import GameObjects.GameObj;
	import GameObjects.MissileBase;
	import GameObjects.Rockets.Rocket;
	/**
	 * ...
	 * @author FDH
	 */
	public class MissileBaseController 
	{
		// -- Properties -- //
		
		// -- Vars -- //
		
		private var _missileBases:Vector.<MissileBase>;
		private var _rocketFactory:RocketFactory;
		private var _engine:Engine;
		
		// -- Construct -- //
		
		public function MissileBaseController(engine:Engine, rocketFactory:RocketFactory) 
		{
			_missileBases = new Vector.<MissileBase>();
			_rocketFactory = rocketFactory;
			_engine = engine;
		}
		
		// -- PublicMethods -- //
		
		public function addBase(x:int, y:int):void 
		{
			// Create base
			var missileSpawn:MissileBase = new MissileBase();
			
			// Position
			missileSpawn.x = x;
			missileSpawn.y = y;
			
			// Add Event listeners
			missileSpawn.addEventListener(MissileBase.SHOOT, onBaseShoot);
			missileSpawn.addEventListener(GameObj.DESTROY, onBaseDestroy);
			
			// Add to array & engine
			_missileBases.push(missileSpawn);
			_engine.AddObject(missileSpawn);
		}
		
		public function getClosestBase(pos:Vector3D):MissileBase 
		{
			var closestBase:MissileBase;
			var closestDistance:Number = -1;
			
			// Calculate closest missile spawn
			for each (var c:MissileBase in _missileBases)
			{
				// Skip if destroyed
				if (!c.IsAlive) continue;
				
				var cDis:Number = Vector3D.distance(c.Position, pos);
				if (cDis < closestDistance || closestDistance < 0)
				{
					closestBase = c;
					closestDistance = cDis;
				}
			}
			
			return closestBase;
		}
		
		public function getRandomBase():MissileBase
		{
			var baseAmount:int = _missileBases.length;
			if (baseAmount == 0) return null;
			
			var rndBaseIndex:int = Math.floor(Math.random() * baseAmount);
			return _missileBases[rndBaseIndex];
		}
		
		// -- PrivateMethods -- //
		
		private function onBaseDestroy(e:ObjectEvent):void 
		{
			var ind:int = _missileBases.indexOf(e.GameObject);
			if (ind >= 0) _missileBases.splice(ind, 1);
		}
		
		private function onBaseShoot(e:ObjectEvent):void 
		{
			var base:MissileBase = e.GameObject as MissileBase;
			var newRocket:Rocket = _rocketFactory.create(base.RocketType, _engine) as Rocket;
			newRocket.Position = base.Position;
			newRocket.Target = e.Target;
		}
		
	}

}
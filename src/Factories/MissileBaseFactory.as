package Factories 
{
	import flash.geom.Vector3D;
	import GameObjects.Events.ObjectEvent;
	import GameObjects.GameObj;
	import GameObjects.MissileBase;
	/**
	 * ...
	 * @author FDH
	 */
	public class MissileBaseFactory extends Factory 
	{
		// -- Properties -- //
		
		// -- Vars -- //
		
		// Player rocket spawns
		private var _missileBases:Vector.<MissileBase>;
		
		//
		private var _missileFactory:RocketFactory;
		
		// -- Construct -- //
		
		public function MissileBaseFactory(missileFactory:RocketFactory) 
		{
			_missileFactory = missileFactory;
			super(_missileFactory.TargetEngine);
			_missileBases = new Vector.<MissileBase>();
		}
		
		// -- PublicMethods -- //
		
		public function AddBase(x:int, y:int):void 
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
			TargetEngine.AddObject(missileSpawn);
		}
		
		public function GetClosestBase(pos:Vector3D):MissileBase 
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
		
		public function GetRandomBase():MissileBase
		{
			var rndBaseIndex:int = Math.floor(Math.random() * _missileBases.length);
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
			_missileFactory.AddRocket(base.Position, e.Target, base.RocketType);
		}
		
	}

}
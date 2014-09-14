package  
{
	import adobe.utils.CustomActions;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	import GameObjects.Events.ObjectEvent;
	import GameObjects.Explosion;
	import GameObjects.GameObj;
	import GameObjects.MissileBase;
	import GameObjects.ObjectController;
	import GameObjects.Rocket;
	import Wave;
	
	/**
	 * ...
	 * @author FDH
	 */
	public class Game
	{
		// -- Vars -- //
		
		private var _stage:Stage;
		
		// Controller of rockets + missileBases (Updating and destroying)
		private var _objController:ObjectController;
		
		// Player rocket spawns
		private var _missileSpawns:Vector.<MissileBase>;
		
		//
		private var _enemyRocketSpeed:Number = 5;
		
		// Levels
		private var _levels:Vector.<Level>;
		private var _currentLevel:int = -1;
		
		// -- Construct + init -- //
		
		public function Game(s:Stage) 
		{
			_stage = s;
			
			// Controller of all objects
			_objController = new ObjectController(s);
			
			// Add Road
			var road:BG_Road = new BG_Road();
			road.x = 0;
			road.y = s.stageHeight - road.height;
			s.addChild(road);
			
			// Add Missile bases
			initMissileSpawns();
			
			// Add event listeners
			s.addEventListener(Event.ENTER_FRAME, update);
			s.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			// Create all levels
			initLevels();
			
			// Start first Level
			NextLevel();
		}
		
		private function initMissileSpawns():void 
		{
			_missileSpawns = new Vector.<MissileBase>();
			
			var missileSpawn1:MissileBase = new MissileBase();
			missileSpawn1.x = 40;
			missileSpawn1.y = 550;
			missileSpawn1.addEventListener(MissileBase.SHOOT, onPlayerShoot);
			_objController.AddObject(missileSpawn1);
			
			var missileSpawn2:MissileBase = new MissileBase();
			missileSpawn2.x = 350;
			missileSpawn2.y = 545;
			missileSpawn2.addEventListener(MissileBase.SHOOT, onPlayerShoot);
			_objController.AddObject(missileSpawn2);
			
			var missileSpawn3:MissileBase = new MissileBase();
			missileSpawn3.x = 670;
			missileSpawn3.y = 550;
			missileSpawn3.addEventListener(MissileBase.SHOOT, onPlayerShoot);
			_objController.AddObject(missileSpawn3);
			
			_missileSpawns.push(missileSpawn1, missileSpawn2, missileSpawn3);
		}
		
		private function initLevels():void 
		{
			_currentLevel = -1;
			_levels = new Vector.<Level>();
			
			var level01:Level = new Level(onLevelDone, EnemyShoot);
			level01.AddWave(1000, 10);
			level01.AddWave(900, 10);
			level01.AddWave(800, 10);
			
			var level02:Level = new Level(onLevelDone, EnemyShoot);
			level02.AddWave(1000, 10);
			level02.AddWave(900, 10);
			level02.AddWave(800, 10);
			
			// Add to array
			_levels.push(level01, level02);
		}
		
		// -- EventCalls -- //
		
		public function update(e:Event):void 
		{
			// Update GameObjects
			_objController.update(e);
		}
		
		public function onMouseUp(e:MouseEvent):void
		{
			var targetPos:Vector3D = new Vector3D(e.stageX, e.stageY);
			
			var closestBase:MissileBase;
			var closestDistance:Number = -1;
			
			// Calculate closest missile spawn
			for each (var c:MissileBase in _missileSpawns)
			{
				var cDis:Number = Vector3D.distance(c.Position, targetPos);
				if (cDis < closestDistance || closestDistance < 0)
				{
					closestBase = c;
					closestDistance = cDis;
				}
			}
			
			// Shoot
			closestBase.ShootMissile(targetPos);
		}
		
		private function onPlayerShoot(e:ObjectEvent):void 
		{
			if (!e.GameObject is MissileBase) return;
			var base:MissileBase = e.GameObject as MissileBase;
			ShootMissile(base.Position, e.Target);
		}
		
		private function onLevelDone():void 
		{
			NextLevel();
		}
		
		private function EnemyShoot():void
		{
			// Calc Spawn Pos
			var spawnPos:Vector3D = new Vector3D(Math.random() * _stage.stageWidth);
			
			// Select random base
			var rndBaseIndex:int = Math.ceil(Math.random() * _missileSpawns.length - 1);
			var target:MissileBase = _missileSpawns[rndBaseIndex];
			// Add some offset to the bases
			var targetPos:Vector3D = target.Position.add(new Vector3D(-target.width + Math.random() * (target.width * 2)));
			
			// Shoot
			ShootMissile(spawnPos, targetPos, _enemyRocketSpeed);
		}
		
		private function NextLevel():void 
		{
			// Stop Current Level
			if (_currentLevel >= 0 && _currentLevel < _levels.length)
			{
				var cLevel:Level = _levels[_currentLevel];
				if (cLevel.Started) cLevel.Stop();
			}
			
			// Increase level
			_currentLevel++;
			
			// Check if done
			if (_currentLevel >= _levels.length)
			{
				trace("-> All Levels done");
				return;
			}
			
			// Start Next Level
			trace("Level " + _currentLevel + " started");
			_levels[_currentLevel].Start();
		}
		
		private function ShootMissile(start:Vector3D, target:Vector3D, speed:Number = 8):void 
		{
			var rocket:Rocket = new Rocket();
			rocket.Position = start;
			rocket.Speed = speed;
			rocket.Target = target;
			rocket.addEventListener(Rocket.EXPLODE, onRocketExplode);
			_objController.AddObject(rocket);
		}
		
		private function onRocketExplode(e:ObjectEvent):void 
		{
			var explosion:Explosion = new Explosion();
			explosion.Position = e.Target;
			_objController.AddObject(explosion);
		}
	}

}
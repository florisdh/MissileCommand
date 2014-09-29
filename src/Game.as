package  
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	import Factories.*;
	import GameObjects.*;
	
	/**
	 * ...
	 * @author FDH
	 */
	public class Game
	{
		// -- Vars -- //
		
		private var _stage:Stage;
		
		// Settings, loaded from file, contains ShootInterval, etc
		private var _settings:Settings;
		
		// Controller of rockets + missileBases (Updating and destroying)
		private var _engine:Engine;
		
		// Factories
		private var _rocketFactory:RocketFactory;
		private var _basesFactory:MissileBaseFactory;
		
		// Levels
		private var _levels:Vector.<Level>;
		private var _currentLevel:int;
		
		// -- Construct + init -- //
		
		public function Game(s:Stage) 
		{
			_stage = s;
			
			// Load settings
			_settings = new Settings();
			
			// Controller of all objects
			_engine = new Engine(s);
			
			// Create rocket factory
			_rocketFactory = new RocketFactory(_engine);
			
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
			_basesFactory = new MissileBaseFactory(_rocketFactory);
			
			_basesFactory.AddBase(40, 550);
			_basesFactory.AddBase(350, 545);
			_basesFactory.AddBase(670, 550);
		}
		
		private function initLevels():void 
		{
			_currentLevel = -1;
			_levels = new Vector.<Level>();
			
			var level01:Level = new Level(onLevelDone, EnemyShoot);
			level01.AddWave(600, 15);
			level01.AddWave(500, 15);
			level01.AddWave(400, 15);
			
			var level02:Level = new Level(onLevelDone, EnemyShoot);
			level02.AddWave(400, 15);
			level02.AddWave(300, 15);
			level02.AddWave(200, 15);
			
			var level03:Level = new Level(onLevelDone, EnemyShoot);
			level03.AddWave(200, 15);
			level03.AddWave(100, 15);
			level03.AddWave(50, 15);
			
			var level04:Level = new Level(onLevelDone, EnemyShoot);
			level04.AddWave(100, 20);
			level04.AddWave(50, 20);
			level04.AddWave(40, 10);
			
			var level05:Level = new Level(onLevelDone, EnemyShoot);
			level05.AddWave(30, 25);
			level05.AddWave(25, 25);
			level05.AddWave(20, 50);
			level05.AddWave(20, 200);
			
			// Add to array
			_levels.push(level01, level02, level03, level04, level05);
		}
		
		// -- EventCalls -- //
		
		public function update(e:Event):void 
		{
			// Update GameObjects
			_engine.update(e);
		}
		
		public function onMouseUp(e:MouseEvent):void
		{
			var targetPos:Vector3D = new Vector3D(e.stageX, e.stageY);
			
			// Get closest base
			var closestBase:MissileBase = _basesFactory.GetClosestBase(targetPos);
			
			// Shoot
			if (closestBase) closestBase.ShootMissile(targetPos);
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
			var target:MissileBase = _basesFactory.GetRandomBase();
			
			// Add some offset to the target location
			var targetPos:Vector3D = target.Position.add(new Vector3D(-target.width + Math.random() * (target.width * 2)));
			
			// Shoot
			_rocketFactory.AddRocket(spawnPos, targetPos, RocketFactory.ROCKET_SLOW);
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
		
	}

}
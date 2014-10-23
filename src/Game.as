package  
{
	import Controllers.EnemyController;
	import Controllers.MissileBaseController;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Vector3D;
	import Factories.*;
	import flash.text.TextField;
	import flash.utils.Timer;
	import GameObjects.*;
	import GameObjects.Cars.Car;
	import GameObjects.Rockets.Rocket;
	import UI.Controls.Label;
	
	/**
	 * ...
	 * @author FDH
	 */
	public class Game extends Sprite
	{
		// -- Events -- //
		
		public static const GAMEOVER:String = "GAMEOVER";
		public static const WON:String = "WON";
		
		// -- SCORE -- //
		
		public static var HIGHSCORE:int = 0;
		public static var SCORE:int = 0;
		
		// -- Vars -- //
		
		// Status
		private var _started:Boolean = false;
		private var _paused:Boolean = false;
		
		// BG
		private var _road:BG_Road;
		
		// Controller of all gameObjects (Updating, destroying, collision check etc)
		private var _engine:Engine;
		
		// Controllers
		private var _missileController:MissileBaseController;
		private var _enemyController:EnemyController;
		
		// Factories
		private var _rocketFactory:RocketFactory;
		private var _carFactory:CarFactory;
		
		// Levels
		private var _levels:Vector.<Level>;
		private var _currentLevel:int;
		
		// UI
		private var _levelIndicator:Label;
		
		// Rocket type of enemy
		private var _enemyRocketType:int;
		
		// Spawn timer here <- todo: create own class
		private var _carSpawnTimer:Timer;
		
		// -- Construct + init -- //
		
		public function Game() 
		{
		}
		
		private function init():void 
		{
			_enemyRocketType = RocketFactory.ROCKET_ENEMY1;
			
			// Controller of all objects
			_engine = new Engine(stage);
			
			// Add Road
			_road = new BG_Road();
			_road.x = 0;
			_road.y = stage.stageHeight - _road.height;
			stage.addChild(_road);
			
			// Factories
			_rocketFactory = new RocketFactory();
			_carFactory = new CarFactory();
			
			// Add Missile bases
			initMissileSpawns();
			
			// Add UI
			_levelIndicator = new Label("");
			_levelIndicator.x = stage.stageWidth / 2
			_levelIndicator.y = stage.stageHeight / 2;
			_levelIndicator.TextSize = 4;
			stage.addChild(_levelIndicator);
			
			// SPawning carz
			_carSpawnTimer = new Timer(4000);
			_carSpawnTimer.addEventListener(TimerEvent.TIMER, onCarSpawn);
			_carSpawnTimer.start();
			
			// Add event listeners
			stage.addEventListener(Event.ENTER_FRAME, update);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			// Create all levels
			initLevels();
			
			// Start first Level
			NextLevel();
		}
		
		private function initMissileSpawns():void 
		{
			_missileController = new MissileBaseController(_engine, _rocketFactory);
			_missileController.addBase(40, 550);
			_missileController.addBase(350, 545);
			_missileController.addBase(670, 550);
		}
		
		private function initLevels():void 
		{
			_currentLevel = -1;
			_levels = new Vector.<Level>();
			
			var level01:Level = new Level(onLevelDone, EnemyShoot);
			level01.AddWave(300, 15);
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
			if (_paused || !_started) return;
			
			// Update GameObjects
			_engine.update(e);
			
			if (_missileController.BaseAmount == 0)
			{
				dispatchEvent(new Event(GAMEOVER));
				Pause();
			}
		}
		
		public function onMouseUp(e:MouseEvent):void
		{
			if (_paused || !_started) return;
			
			var targetPos:Vector3D = new Vector3D(e.stageX, e.stageY);
			
			// Get closest base
			var closestBase:MissileBase = _missileController.getClosestBase(targetPos);
			
			// Shoot
			if (closestBase) closestBase.ShootMissile(targetPos);
		}
		
		private function onLevelDone():void 
		{
			// Change rocket type when higher level
			switch (_currentLevel) 
			{
				case 1:
					_enemyRocketType = RocketFactory.ROCKET_ENEMY2;
				break;
				case 3:
					_enemyRocketType = RocketFactory.ROCKET_ENEMY3;
				break;
				default:
			}
			
			NextLevel();
			
			// Spawn a car
			spawnCar(10, 1);
		}
		
		private function onCarSpawn(e:Event):void 
		{
			var spawnPoint:int = Math.random() * 2;
			switch (spawnPoint) 
			{
				case 0:
					spawnCar(0, 1);
				break;
				case 1:
					spawnCar(stage.stageWidth, -1);
				break;
				default:
			}
		}
		
		private function EnemyShoot():void
		{
			// Calc Spawn Pos
			var spawnPos:Vector3D = new Vector3D(Math.random() * stage.stageWidth);
			
			// Select random base
			var target:MissileBase = _missileController.getRandomBase();
			
			// Add some offset to the target location
			var targetPos:Vector3D = target.Position.add(new Vector3D(-target.width + Math.random() * (target.width * 2)));
			
			// Shoot
			var newRocket:Rocket = _rocketFactory.create(_enemyRocketType, _engine) as Rocket;
			newRocket.Position = spawnPos;
			newRocket.Target = targetPos;
		}
		
		// -- Methods -- //
		
		public function Start():void 
		{
			if (_started) return;
			_started = true;
			init();
		}
		
		public function Pause():void 
		{
			if (_paused) return;
			_paused = true;
			
			if (_currentLevel < _levels.length) _levels[_currentLevel].Pause();
		}
		
		public function Resume():void 
		{
			if (!_paused) return;
			_paused = false;
			
			if (_currentLevel < _levels.length) _levels[_currentLevel].Resume();
		}
		
		public function Stop():void 
		{
			if (!_started) return;
			_started = false;
			_paused = false;
			
			// Stop Level
			if (_currentLevel < _levels.length) _levels[_currentLevel].Stop();
			
			// Remove all items
			_engine.Destroy();
			stage.removeChild(_levelIndicator);
			stage.removeChild(_road);
			
			// Remove event listeners
			stage.removeEventListener(Event.ENTER_FRAME, update);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
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
				dispatchEvent(new Event(WON));
				Stop();
				return;
			}
			
			// Show user
			showText("Level " + (_currentLevel + 1));
			
			// Start Next Level
			_levels[_currentLevel].Start();
		}
		
		private function showText(text:String):void 
		{
			_levelIndicator.Text = text;
			_levelIndicator.fadeOut(50, 0.0175);
		}
		
		private function spawnCar(x:int, dir:int):void 
		{
			var newCar:Car = _carFactory.create(0, _engine) as Car;
			newCar.x = x;
			newCar.scaleX = newCar.scaleY = 0.6;
			newCar.y = _road.y + 25;
			newCar.Speed *= dir;
		}
		
		// -- Get&Set -- //
		
		public function get Started():Boolean
		{
			return _started;
		}
		
		public function get Paused():Boolean
		{
			return _paused;
		}
		
		public function set Paused(newVal:Boolean):void 
		{
			_paused = newVal;
		}
	}
}
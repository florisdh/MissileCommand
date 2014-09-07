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
	import GameObjects.GameObj;
	import GameObjects.MissileBase;
	import GameObjects.ObjectController;
	import GameObjects.Rocket;
	import Waves.Wave;
	
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
		
		// Waves
		private var _waves:Vector.<Wave>;
		private var _waveIndex:int = 0;
		
		// -- Construct + init -- //
		
		public function Game(s:Stage) 
		{
			_stage = s;
			
			// Controller of all objects
			_objController = new ObjectController(s);
			
			// Add bg
			var _bg:BG_Road = new BG_Road();
			_bg.x = 0;
			_bg.y = s.stageHeight - _bg.height;
			s.addChild(_bg);
			
			initMissileControllers();
			initWaves();
			
			_waves[_waveIndex].Start();
		}
		
		private function initMissileControllers():void 
		{
			_missileSpawns = new Vector.<MissileBase>();
			
			var missileSpawn1:MissileBase = new MissileBase();
			missileSpawn1.x = 20;
			missileSpawn1.y = 535;
			missileSpawn1.addEventListener(MissileBase.SHOOT, onPlayerShoot);
			_objController.AddObject(missileSpawn1);
			
			var missileSpawn2:MissileBase = new MissileBase();
			missileSpawn2.x = 350;
			missileSpawn2.y = 530;
			missileSpawn2.addEventListener(MissileBase.SHOOT, onPlayerShoot);
			_objController.AddObject(missileSpawn2);
			
			var missileSpawn3:MissileBase = new MissileBase();
			missileSpawn3.x = 660;
			missileSpawn3.y = 535;
			missileSpawn3.addEventListener(MissileBase.SHOOT, onPlayerShoot);
			_objController.AddObject(missileSpawn3);
			
			_missileSpawns.push(missileSpawn1, missileSpawn2, missileSpawn3);
		}
		
		private function initWaves():void 
		{
			_waves = new Vector.<Wave>();
			_waves.push(new Wave(1500, 10, onWaveDone, onWaveShoot));
			_waves.push(new Wave(1300, 15, onWaveDone, onWaveShoot));
			_waves.push(new Wave(1000, 20, onWaveDone, onWaveShoot));
			_waves.push(new Wave(700, 25, onWaveDone, onWaveShoot));
		}
		
		// -- EventCalls -- //
		
		public function update(e:Event):void 
		{
			// Update GameObjects
			_objController.update(e);
		}
		
		public function onMouseUp(e:MouseEvent):void
		{
			var base:MissileBase;
			var targetPos:Vector3D = new Vector3D(e.stageX, e.stageY);
			var dis:Number = -1;
			
			// Calculate closest missile spawn
			for each (var c:MissileBase in _missileSpawns)
			{
				var cDis:Number = Vector3D.distance(c.RocketSpawnPos, targetPos);
				if (cDis < dis || dis < 0)
				{
					base = c;
					dis = cDis;
				}
			}
			
			// Shoot
			base.ShootMissile(targetPos);
		}
		
		private function onPlayerShoot(e:ObjectEvent):void 
		{
			var base:MissileBase = e.GameObject as MissileBase;
			ShootMissile(base.RocketSpawnPos, e.Target);
		}
		
		private function onWaveDone():void 
		{
			NextWave();
		}
		
		private function onWaveShoot():void
		{
			// Calc Spawn Pos
			var spawnPos:Vector3D = new Vector3D(Math.random() * _stage.stageWidth);
			
			// Select random base
			var rndBaseIndex:int = Math.ceil(Math.random() * _missileSpawns.length-1);
			var target:Vector3D = _missileSpawns[rndBaseIndex].RocketSpawnPos;
			
			// Shoot
			ShootMissile(spawnPos, target, 5);
		}
		
		// -- Methods -- //
		
		private function NextWave():void 
		{
			// Stop Current Wave
			var lastWave:Wave = _waves[_waveIndex];
			if (lastWave.Started) lastWave.Stop();
			
			// Check if done
			if (_waveIndex >= _waves.length - 1)
			{
				_waveIndex = 0;
				trace("-> All Waves Won!!");
			}
			else 
			{
				_waveIndex++;
				trace("-> Next Wave: " + _waveIndex);
			}
			
			// Start Next Wave
			_waves[_waveIndex].Start();
		}
		
		
		private function ShootMissile(start:Vector3D, target:Vector3D, speed:Number = 8):void 
		{
			var rocket:Rocket = new Rocket();
			rocket.x = start.x;
			rocket.y = start.y;
			rocket.Speed = speed;
			rocket.Target = target;
			_objController.AddObject(rocket);
		}
		
	}

}
package  {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import GameObjects.Rockets.Rocket;
	/**
	 * ...
	 * @author FDH
	 */
	public class Wave
	{
		// -- Events -- //
		public var OnDone:Function;
		public var OnShoot:Function;
		
		// -- Properties -- //
		
		public var SpawnInterval:int;
		public var SpawnIntervalFluctuation:int = 800;
		
		public var Amount:int;
		
		public function get Started():Boolean
		{
			return _started;
		}
		
		// -- Vars -- //
		
		private var _started:Boolean = false;
		private var _currentAmount:int = 0;
		private var _spawnTimer:Timer;
		
		public function Wave(interval:int, amount:int, onDone:Function, onShoot:Function)
		{
			SpawnInterval = interval;
			Amount = amount;
			OnDone = onDone;
			OnShoot = onShoot;
		}
		
		private function init():void
		{
			_started = false;
			_currentAmount = 0;
			
			_spawnTimer = new Timer(0);
			_spawnTimer.addEventListener(TimerEvent.TIMER, SpawnTimer_Tick);
		}
		
		// Start or resume the wave
		public function Start():void 
		{
			// Reset if not started
			if (!_started) init();
			
			// Start timer for next Spawn
			_spawnTimer.delay = _calcInterval();
			_spawnTimer.start();
		}
		
		// Pauze the wave
		public function Pauze():void 
		{
			if (!_started) return;
			_spawnTimer.stop();
		}
		
		// Stop the wave
		public function Stop():void 
		{
			if (!_started) return;
			_started = false;
			
			_spawnTimer.stop();
		}
		
		// Reset the wave
		public function Reset():void
		{
			init();
		}
		
		private function SpawnTimer_Tick(e:Event):void 
		{
			// If done
			if (_currentAmount >= Amount)
			{
				OnDone();
				_spawnTimer.stop();
				return;
			}
			_currentAmount++;
			
			// Restart timer
			_spawnTimer.delay = _calcInterval();
			
			// Shoot missile
			OnShoot();
		}
		
		private function _calcInterval():int
		{
			//return SpawnInterval + (Math.random() * SpawnIntervalFluctuation * 2 - SpawnIntervalFluctuation);
			return SpawnInterval + Math.random() * SpawnIntervalFluctuation;
		}
	}

}
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
		
		// -- Vars -- //
		
		private var _started:Boolean = false;
		private var _paused:Boolean = false;
		
		// Time left in the timer before pause
		private var _lastTimerTime:int = -1;
		
		private var _currentAmount:int;
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
			_currentAmount = -1;
			_spawnTimer = new Timer(0);
			_spawnTimer.addEventListener(TimerEvent.TIMER, SpawnTimer_Tick);
		}
		
		// -- Event Callbacks -- //
		
		private function SpawnTimer_Tick(e:Event):void 
		{
			NextSpawn();
		}
		
		// -- Methods -- //
		
		public function Start():void 
		{
			if (_started) return;
			_started = true;
			
			// Reset Vars
			init()
			
			// Start timer for next Spawn
			RestartTimer();
		}
		
		public function Resume():void 
		{
			if (!_started || !_paused) return;
			_paused = false;
			
			RestartTimer();
		}
		
		public function Pause():void 
		{
			if (!_started || _paused) return;
			_paused = true;
			
			_spawnTimer.stop();
		}
		
		public function Stop():void 
		{
			if (!_started) return;
			_started = false;
			_paused = false;
			_spawnTimer.stop();
		}
		
		public function NextSpawn():void 
		{
			_currentAmount++;
			
			// If done
			if (_currentAmount >= Amount)
			{
				OnDone();
				Stop();
				return;
			}
			
			RestartTimer();
			
			// Shoot missile
			OnShoot();
		}
		
		private function RestartTimer():void
		{
			_spawnTimer.delay = SpawnInterval + Math.random() * SpawnIntervalFluctuation;
			if (!_spawnTimer.running) _spawnTimer.start();
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
		
	}

}
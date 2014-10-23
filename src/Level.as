package  
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author FDH
	 */
	public class Level 
	{
		// -- Events -- //
		public var OnDone:Function;
		public var OnShoot:Function;
		
		// -- Properties -- //
		
		public var Waves:Vector.<Wave>;
		public var Done:Boolean = false;
		
		// -- Vars -- //
		
		private var _started:Boolean = false;
		private var _paused:Boolean = false;
		
		private var _waveTimer:Timer;
		private var _waveInterval:int = 2000;
		private var _currentWave:int;
		
		public function Level(onDone:Function, onShoot:Function) 
		{
			Waves = new Vector.<Wave>();
			OnDone = onDone;
			OnShoot = onShoot;
		}
		
		private function init():void 
		{
			_currentWave = -1;
			_waveTimer = new Timer(_waveInterval, 1);
			_waveTimer.addEventListener(TimerEvent.TIMER, onWaveTimerTick);
		}
		
		// Starts
		public function Start():void 
		{
			if (Waves.length == 0 || _started) return;
			_started = true;
			
			// Reset Vars
			init();
			
			// Start wave
			NextWave();
		}
		
		public function Resume():void
		{
			if (!_started || !_paused) return;
			_paused = false;
			
			// Resume wave
			Waves[_currentWave].Resume();
			
			_waveTimer.start();
		}
		
		public function Pause():void 
		{
			if (!_started || _paused) return;
			_paused = true;
			
			// Pause wave
			Waves[_currentWave].Pause();
			
			// Pause Level Timer
			_waveTimer.stop();
		}
		
		public function Stop():void 
		{
			if (!_started) return;
			_started = false;
			_paused = false;
			_waveTimer.stop();
		}
		
		public function AddWave(interval:Number, amount:int):void 
		{
			Waves.push(new Wave(interval, amount, onWaveDone, OnShoot));
		}
		
		public function NextWave():void 
		{
			// Stop current wave if stil running
			if (_currentWave >= 0 && _currentWave < Waves.length)
			{
				var lastWave:Wave = Waves[_currentWave];
				if (lastWave.Started) lastWave.Stop();
			}
			
			// Increase wave
			_currentWave++;
			
			// Check if done
			if (!Done && _currentWave >= Waves.length)
			{
				OnDone();
				Stop();
				return;
			}
			
			// Start wave
			Waves[_currentWave].Start();
		}
		
		private function onWaveDone():void 
		{
			// Check if all waves done
			if (_currentWave >= Waves.length - 1)
			{
				OnDone();
				return;
			}
			
			// Wait for next wave
			if (!_waveTimer.running) _waveTimer.start();
		}
		
		private function onWaveTimerTick(e:TimerEvent):void 
		{
			NextWave();
		}
		
		// -- Get&Set -- //
		
		// Time between waves in milliseconds 
		
		public function get WaveInterval():int
		{
			return _waveInterval;
		}
		public function set WaveInterval(val:int):void 
		{
			_waveTimer.delay = val;
			_waveInterval = val;
		}
		
		public function get Started():Boolean
		{
			return _started;
		}
	}

}
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
		
		// -- Vars -- //
		
		private var _started:Boolean = false;
		private var _waveTimer:Timer;
		private var _waveInterval:int = 2000;
		private var _currentWave:int = -1;
		
		public function Level(onDone:Function, onShoot:Function) 
		{
			Waves = new Vector.<Wave>();
			OnDone = onDone;
			OnShoot = onShoot;
		}
		
		private function init():void 
		{
			_currentWave = -1;
			_started = false;
			_waveTimer = new Timer(_waveInterval, 1);
			_waveTimer.addEventListener(TimerEvent.TIMER, onWaveTimerTick);
		}
		
		// Starts or resumes
		public function Start():void 
		{
			if (Waves.length == 0) return;
			
			// Reset vals if not started
			if (!_started) init();
			
			// Start wave
			NextWave();
		}
		
		public function Pauze():void 
		{
			
		}
		
		public function Stop():void 
		{
			
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
				return;
			}
			
			// Start wave
			trace("-> Wave " + _currentWave + " started");
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
	}

}
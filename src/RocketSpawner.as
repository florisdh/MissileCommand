package  
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Vector3D;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author FDH
	 */
	public class RocketSpawner
	{
		// Time to spawn
		public var SpawnInterval:int = 800;
		public var SpawnIntervalFluctiation:int = 600;
		
		//
		public var Enabled:Boolean = true;
		
		//
		public var Targets:Vector.<Vector3D>;
		
		// 
		private var _timer:Timer;
		
		public function RocketSpawner(targets:Vector3D)
		{
			super();
			
			Targets = targets;
			
			_timer = new Timer(CalculateNextSpawnTime(), 1);
			_timer.addEventListener(TimerEvent.TIMER, onTimerTick);
			_timer.start();
		}
		
		public function update(e:Event):void 
		{
			
		}
		
		private function onTimerTick(e:Event):void 
		{
			if (!Enabled) return;
			
			// Set timer again
			_timer.delay = CalculateNextSpawnTime();
			_timer.start();
			
			// Calculate spawn position
			var spawnPos:Vector3D = new Vector3D();
		}
		
		private function CalculateNextSpawnTime():int 
		{
			return SpawnInterval + Math.random() * SpawnIntervalFluctiation;
		}
		
		private function CalculateNextSpawnPos():Vector3D 
		{
			
		}
		
	}
}
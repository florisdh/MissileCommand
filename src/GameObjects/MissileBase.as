package GameObjects 
{
	import adobe.utils.CustomActions;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Vector3D;
	import flash.utils.Timer;
	import GameObjects.Events.ObjectEvent;
	/**
	 * ...
	 * @author FDH
	 */
	public class MissileBase extends GameObj 
	{
		// -- EVENTS -- //
		
		public static const SHOOT:String = "SHOOT";
		
		// -- Properties -- //
		
		// Interval between shots
		public function set ShootInterval(millisec:int):void
		{
			_shootInterval = millisec;
			_shootTimer.delay = millisec;
		}
		public function get ShootInterval():int
		{
			return _shootInterval;
		}
		
		public function get CanShoot():Boolean 
		{
			return _canShoot;
		}
		
		public function get RocketSpawnPos():Vector3D
		{
			return new Vector3D(this.x + this.width / 2, this.y + this.height / 2);
		}
		
		// -- Vars -- //
		
		private var _shootInterval:int = 500;
		private var _shootTimer:Timer;
		private var _canShoot:Boolean = true;
		private var _shooting:Boolean = false;
		private var _target:Vector3D;
		
		// Anim states
		private var _animState:String;
		private var _animDone:Boolean = true;
		private var _animDoneAction:Function;
		
		// -- Construct -- //
		
		public function MissileBase() 
		{
			// Add baseObject
			_baseObj = new MissileLaunch();
			super();
			
			// Create shoot interval timer
			_shootTimer = new Timer(_shootInterval, 1);
			_shootTimer.addEventListener(TimerEvent.TIMER, function(ev:Event):void
			{
				_shootTimer.stop();
				_canShoot = true;
			});
			
			// Set default anim
			_animState = "Idle";
		}
		
		// -- Overrides -- //
		
		override public function update(e:Event):void 
		{
			// Animate
			if (_animState && _baseObj.currentFrameLabel != _animState)
			{
				_baseObj.stop();
				_baseObj.prevFrame();
				_animDone = true;
				
				if (_shooting)
				{
					_shooting = false;
					
					// Close gate
					CloseGate();
					
					// Fire
					dispatchEvent(new ObjectEvent(MissileBase.SHOOT, this, _target));					
				}
			}
			
			super.update(e);
		}
		
		// -- Methods -- //
		
		public function ShootMissile(target:Vector3D):void 
		{
			// Shoot interval
			if (!_canShoot) return;
			_canShoot = false;
			_shooting = true;
			_shootTimer.start();
			
			// Set target & open gate
			_target = target;
			OpenGate();
		}
		
		public function OpenGate():void 
		{
			if (_animState != "Open")
			{
				_animState = "Open";
				_baseObj.gotoAndPlay(_animState);
				_animDone = false;
			}
		}
		
		public function CloseGate():void 
		{
			if (_animState != "Close")
			{
				_animState = "Close";
				_baseObj.gotoAndPlay(_animState);
				_animDone = false;
			}
		}
		
	}

}
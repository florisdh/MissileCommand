package GameObjects 
{
	import adobe.utils.CustomActions;
	import Factories.RocketFactory;
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
		
		public var RocketType:uint = RocketFactory.ROCKET_FAST;
		
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
			_baseObj = new Art_MissileLaunch();
			super();
			
			// Create shoot interval timer
			_shootTimer = new Timer(_shootInterval, 1);
			_shootTimer.addEventListener(TimerEvent.TIMER, function(ev:Event):void
			{
				_shootTimer.stop();
				_canShoot = true;
			});
			
			// Set bounds
			CollisionRange = 20;
			
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
		
		override public function onCollide(other:GameObj):void 
		{
			if (!(other is Explosion)) return;
			
			super.onCollide(other);
		}
		
		// -- PublicMethods -- //
		
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
		
		// -- GetSet -- //
		
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
		
		
	}

}
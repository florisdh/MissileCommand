package GameObjects 
{
	import adobe.utils.CustomActions;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Vector3D;
	import GameObjects.Events.ObjectEvent;
	
	/**
	 * ...
	 * @author FDH
	 */
	public class GameObj extends Sprite 
	{
		// -- Events -- //
		public static const DESTROY:String = "DESTROY";
		public static const EXPLODE:String = "EXPLODE";
		
		// -- Properties -- //
		
		// If the obj is not destroying and not destroyed
		public var IsAlive:Boolean = true;
		
		// Collider
		public var Collide:Boolean = true;
		public var CollisionRange:Number = 10;
		
		// Explosion
		public var WillExplode:Boolean = true;
		public var ExplosionType:Number = 1;
		
		// If to draw the collision bounds (for debugging)
		public var ShowCollisionRange:Boolean = false;
		
		// -- Vars -- //
		
		// Spawn position
		protected var _basePos:Vector3D;
		
		// Base Art Object
		protected var _baseObj:MovieClip;
		
		// Forces
		protected var _velo:Vector3D = new Vector3D();
		
		// -- Construct -- //
		
		public function GameObj() 
		{
			if (_baseObj) addChild(_baseObj);
			
			// Set line style for collision range drawing
			graphics.lineStyle(2, 0xFF0000);
		}
		
		// -- PublicMethods -- //
		
		public function update(e:Event):void 
		{
			// Apply velo on object
			this.x += _velo.x;
			this.y += _velo.y;
			
			// Clear Velo
			_velo.scaleBy(0);
			
			// Draw collision range
			if (ShowCollisionRange)
			{
				graphics.drawCircle(0, 0, CollisionRange);
			}
		}
		
		public function onCollide(other:GameObj):void 
		{
			if (WillExplode)
			{
				Explode();
			}
		}
		
		public function Destroy():void 
		{
			if (!IsAlive) return;
			IsAlive = false;
			dispatchEvent(new ObjectEvent(DESTROY, this));
		}
		
		public function Explode():void 
		{
			if (!IsAlive) return;
			dispatchEvent(new ObjectEvent(EXPLODE, this, Position));
			Destroy();
		}
		
		// -- GetSet -- //
		
		public function get Position():Vector3D
		{
			return new Vector3D(x, y);
		}
		
		public function set Position(pos:Vector3D):void
		{
			this.x = pos.x;
			this.y = pos.y;
			_basePos = pos;
		}
		
		public function set Scale(newScale:Number):void 
		{
			scaleX = scaleY = newScale;
		}
		
	}

}
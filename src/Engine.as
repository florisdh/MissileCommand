package
{
	import adobe.utils.CustomActions;
	import Factories.ExplosionFactory;
	import Factories.Factory;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Vector3D;
	import GameObjects.Events.ObjectEvent;
	import GameObjects.Explosion;
	import GameObjects.GameObj;
	/**
	 * ...
	 * @author FDH
	 */
	public class Engine 
	{
		// All objects in the game
		public var GameObjs:Vector.<GameObj> = new Vector.<GameObj>();
		
		// Stage of the game
		private var _stage:Stage;
		
		private var _explosionFactory:Factory;
		
		// State
		private var _started:Boolean = false;
		
		public function Engine(stage:Stage)
		{
			_stage = stage;
			_started = true;
			_explosionFactory = new ExplosionFactory();
		}
		
		public function AddObject(obj:GameObj):void 
		{
			// Add to stage
			_stage.addChild(obj);
			
			// Add to array
			GameObjs.push(obj);
			
			// Add event listeners
			obj.addEventListener(GameObj.DESTROY, onObjectDestroy);
			obj.addEventListener(GameObj.EXPLODE, onObjectExplode);
		}
		
		public function AddObjects(objs:Vector.<GameObj>):void 
		{
			for each (var c:GameObj in objs) 
			{
				AddObject(c);
			}
		}
		
		public function RemoveObject(obj:GameObj):void 
		{
			// Get array index
			var index:int = GameObjs.indexOf(obj);
			
			RemoveObjectFromInd(index);
			
			// Remove from RAM
			obj = null;
		}
		
		public function RemoveObjectFromInd(index:int):void 
		{
			// Check if in array
			if (index < 0) return;
			
			var obj:GameObj = GameObjs[index];
			
			// Remove event listeners
			obj.removeEventListener(GameObj.DESTROY, onObjectDestroy);
			
			// Remove from stage
			_stage.removeChild(obj);
			
			// Remove from array
			GameObjs.splice(index, 1);
		}
		
		public function update(e:Event):void 
		{
			if (!_started) return;
			
			// Update all objects
			for each (var c:GameObj in GameObjs)
			{
				c.update(e);
			}
			
			// Check for collision between objects
			for each (var c:GameObj in GameObjs)
			for each (var o:GameObj in GameObjs)
			{
				// Skip self, dead or no colliding part
				if (c == o || !c.IsAlive || !o.IsAlive || !c.Collide || !o.Collide) continue;
				
				// Calc distance
				var dis:Number = Vector3D.distance(c.Position, o.Position);
				
				// Check if in bounds
				if (dis < c.CollisionRange + o.CollisionRange)
				{
					c.onCollide(o);
				}
			}
		}
		
		public function Destroy():void 
		{
			_started = false;
			for (var i:int = GameObjs.length - 1; i >= 0; i-- )
			{
				RemoveObjectFromInd(i);
			}
		}
		
		private function onObjectDestroy(e:ObjectEvent):void 
		{
			RemoveObject(e.GameObject);
		}
		
		private function onObjectExplode(e:ObjectEvent):void 
		{
			var explosion:Explosion = _explosionFactory.create(e.GameObject.ExplosionType, this) as Explosion;
			explosion.Position = e.Target;
		}
	}

}
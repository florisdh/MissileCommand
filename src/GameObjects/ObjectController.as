package GameObjects 
{
	import adobe.utils.CustomActions;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Vector3D;
	import GameObjects.Events.ObjectEvent;
	/**
	 * ...
	 * @author FDH
	 */
	public class ObjectController 
	{
		// All objects in the game
		public var GameObjs:Vector.<GameObj> = new Vector.<GameObj>();
		
		// Stage of the game
		private var _stage:Stage;
		
		public function ObjectController(stage:Stage)
		{
			_stage = stage;
		}
		
		public function AddObject(obj:GameObj):void 
		{
			// Add to stage
			_stage.addChild(obj);
			
			// Add to array
			GameObjs.push(obj);
			
			// Add event listeners
			obj.addEventListener(GameObj.DESTROY, onObjectDestroy);
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
			
			// Check if in array
			if (index < 0) return;
			
			// Remove event listeners
			obj.removeEventListener(GameObj.DESTROY, onObjectDestroy);
			
			// Remove from array
			GameObjs.splice(index, 1);
			
			// Remove from stage
			_stage.removeChild(obj);
			
			// Remove from ram
			obj = null;
		}
		
		public function update(e:Event):void 
		{
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
		
		private function onObjectDestroy(ev:ObjectEvent):void 
		{
			RemoveObject(ev.GameObject);
		}
	}

}
package GameObjects.Events 
{
	import flash.events.Event;
	import flash.geom.Vector3D;
	import GameObjects.GameObj;
	
	/**
	 * ...
	 * @author FDH
	 */
	public class ObjectEvent extends Event 
	{
		public var GameObject:GameObj;
		public var Target:Vector3D;
		
		public function ObjectEvent(type:String, obj:GameObj, target:Vector3D = null) 
		{
			super(type, false, false);
			GameObject = obj;
			Target = target;
		}
		
	}

}
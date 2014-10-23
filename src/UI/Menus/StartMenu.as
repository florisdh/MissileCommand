package UI.Menus 
{
	import flash.events.Event;
	/**
	 * ...
	 * @author FDH
	 */
	public class StartMenu extends Menu 
	{
		// -- Events -- //
		
		public static const START:String = "START";
		public static const FULLSCREEN:String = "FULLSCREEN";
		public static const ABOUT:String = "ABOUT";
		
		// -- Properties -- //
		
		// -- Vars -- // 
		
		// -- Construct & Init -- //
		
		public function StartMenu() 
		{
			super();
			BackGroundAlpha = 1;
		}
		
		override protected function init(e:Event = null):void 
		{
			super.init(e);
			addLabel("Missile Command", 400, 200, 6, 0xEEEEEE);
			addButton("Start Game", 400, 300, START, 0xDDDDDD, 0xCCCCCC);
			addButton("FullScreen", 400, 350, FULLSCREEN, 0xDDDDDD, 0xCCCCCC);
			addButton("About", 400, 400, ABOUT, 0xDDDDDD, 0xCCCCCC);
		}
		
		// -- Methods -- //
		
		override protected function draw():void 
		{
		}
	}

}
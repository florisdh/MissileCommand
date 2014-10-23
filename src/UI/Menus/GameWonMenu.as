package UI.Menus 
{
	import flash.events.Event;
	/**
	 * ...
	 * @author FDH
	 */
	public class GameWonMenu extends Menu 
	{
		// -- Events -- //
		
		public static const RETRY:String = "RETRY";
		public static const EXIT:String = "EXIT";
		
		
		public function GameWonMenu() 
		{
			super();
			BackGroundAlpha = 1;
		}
		
		override protected function init(e:Event = null):void 
		{
			super.init(e);
			addLabel("YOU HAVE WON THE GAME!", 400, 200, 5);
			addButton("Retry", 400, 350, RETRY);
			addButton("Exit", 400, 400, EXIT);
		}
	}

}
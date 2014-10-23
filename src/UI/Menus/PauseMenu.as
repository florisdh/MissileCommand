package UI.Menus 
{
	import flash.events.Event;
	/**
	 * ...
	 * @author FDH
	 */
	public class PauseMenu extends Menu 
	{
		// -- Properties -- //
		
		public static const RESUME:String = "RESUME";
		public static const QUIT:String = "QUIT";
		
		// -- Vars -- // 
		
		[Embed(source="../../../ART/PauseMenuBackGround.png")]
		private static var Art_PauseMenu:Class;
		
		// -- Construct & Init -- //
		
		public function PauseMenu() 
		{
			super();
			BackGroundAlpha = 1;
			DrawBackGround = false;
			addChild(new Art_PauseMenu());
		}
		
		override protected function init(e:Event = null):void 
		{
			super.init(e);
			
			addLabel("Paused", 400, 200, 6, 0x101010);
			addButton("Resume", 400, 250, RESUME, 0x666666, 0x333333);
			addButton("Quit", 400, 300, QUIT, 0x666666, 0x333333);
		}
		
	}

}
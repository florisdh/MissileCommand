package 
{
	import adobe.utils.CustomActions;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author FDH
	 */
	public class Main extends Sprite 
	{
		private var _game:Game;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			// Create game
			_game = new Game(stage);
			
			// Events
			addEventListener(Event.ENTER_FRAME, _game.update);
			stage.addEventListener(MouseEvent.MOUSE_UP, _game.onMouseUp);
		}
		
	}
	
}
package 
{
	import adobe.utils.CustomActions;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import UI.Menus.Menu;
	import UI.Menus.PauseMenu;
	import UI.Menus.StartMenu;
	
	/**
	 * ...
	 * @author FDH
	 */
	public class Main extends Sprite 
	{
		// -- Constants -- //
		
		private static const BUTTON_PAUSE:int = 27; // Escape
		
		// -- Vars -- //
		
		private var _game:Game;
		private var _menu:Menu;
		
		private var _fullScreen:Boolean = false;
		
		// -- Construct -- //
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			// Create game
			_game = new Game();
			addChild(_game);
			
			// Show start menu
			showStartMenu();
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		// -- EventCallBacks -- //
		
		private function onKeyDown(e:KeyboardEvent):void 
		{
			// Pause or resume game
			if (e.keyCode == BUTTON_PAUSE && _game.Started)
			{
				if (_game.Paused) resumeGame();
				else pauseGame();
			}
		}
		
		// -- Methods -- //
		
		private function startGame(e:Event = null):void 
		{
			hideMenu();
			
			_game.Start();
			stage.focus = null;
		}
		
		private function pauseGame(e:Event = null):void 
		{
			_game.Pause();
			showPauseMenu();
			stage.focus = null;
		}
		
		private function resumeGame(e:Event = null):void 
		{
			hideMenu();
			_game.Resume();
			stage.focus = null;
		}
		
		private function stopGame(e:Event = null):void 
		{
			_game.Stop();
			//removeChild(_game);
			//_game = null;
			//_game = new Game();
			//addChild(_game);
			showStartMenu();
			stage.focus = null;
		}
		
		private function showStartMenu():void 
		{
			// Hide last menu
			hideMenu();
			
			// Create Start Menu
			_menu = new StartMenu();
			_menu.addEventListener(StartMenu.START, startGame);
			_menu.addEventListener(StartMenu.FULLSCREEN, fullScreen);
			stage.addChild(_menu);
		}
		
		private function showPauseMenu():void 
		{
			// Hide last menu
			hideMenu();
			
			// Create Pause Menu & Put on top
			_menu = new PauseMenu();
			_menu.addEventListener(PauseMenu.RESUME, resumeGame);
			_menu.addEventListener(PauseMenu.QUIT, stopGame);
			stage.addChildAt(_menu, stage.numChildren);
		}
		
		private function hideMenu():void 
		{
			if (_menu)
			{
				_menu.close();
				stage.removeChild(_menu);
				_menu = null;
			}
		}
		
		private function fullScreen(e:Event = null):void 
		{
			if (_fullScreen)
			{
				_fullScreen = false;
				stage.displayState = StageDisplayState.NORMAL;
			}
			else
			{
				_fullScreen = true;
				stage.displayState = StageDisplayState.FULL_SCREEN;
			}
		}
	}
	
}
package UI.Menus {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import UI.Controls.Button;
	import UI.Controls.Control;
	import UI.Controls.Label;
	
	/**
	 * ...
	 * @author FDH
	 */
	public class Menu extends Sprite 
	{
		// -- Properties -- //
		
		public var DrawBackGround:Boolean = true;
		public var BackGroundColor:uint = 0x000000;
		public var BackGroundAlpha:Number = 0.5;
		
		// -- Vars -- //
		
		private var _controls:Vector.<Control> = new Vector.<Control>();
		
		// -- Construct -- //
		
		public function Menu() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		protected function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			redraw();
		}
		
		// -- Methods -- //
		
		public function close():void 
		{
			
		}
		
		public function redraw():void 
		{
			if (DrawBackGround) drawBackGround();
			draw();
		}
		
		// -- PrivateMethods -- //
		
		protected function drawBackGround():void 
		{
			graphics.beginFill(BackGroundColor, BackGroundAlpha);
			graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			graphics.endFill();
		}
		
		protected function draw():void 
		{
			
		}
		
		protected function addButton(text:String, x:int, y:int, clickEvent:String = "", color:uint = 0xFFFFFF, hoverColor:uint = 0xEEEEEE):Button
		{
			var newButton:Button = new Button();
			newButton.Text = text;
			newButton.x = x;
			newButton.y = y;
			newButton.TextColor = color;
			newButton.HoverTextColor = hoverColor;
			
			// ClickEvent
			if (clickEvent != "") newButton.addEventListener(MouseEvent.CLICK, function():void 
			{
				dispatchEvent(new Event(clickEvent));
			});
			
			// Add
			addControl(newButton);
			
			return newButton;
		}
		
		protected function addLabel(text:String, x:int, y:int, textScale:Number, color:uint = 0xFFFFFF):Label 
		{
			var newLabel:Label = new Label(text);
			newLabel.x = x;
			newLabel.y = y;
			newLabel.TextSize = textScale;
			newLabel.TextColor = color;
			
			addControl(newLabel);
			
			return newLabel;
		}
		
		protected function addControl(control:Control):void 
		{
			addChild(control);
			_controls.push(control);
		}
	}

}
package UI.Controls {
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.geom.Vector3D;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author FDH
	 */
	public class Label extends Control 
	{
		// -- Properties -- //
		
		// -- Vars -- //
		
		//
		private var _textField:TextField;
		
		//
		private var _fading:Boolean = false;
		private var _fadeTimer:Timer;
		private var _fadeSteps:Number;
		
		// -- Construct -- //
		
		public function Label(text:String = null) 
		{
			_textField = new TextField();
			_textField.selectable = false;
			_textField.autoSize = TextFieldAutoSize.CENTER;
			addChild(_textField);
			if (text) Text = text;
		}
		
		// -- Methods -- //
		
		public function fadeOut(interval:uint, steps:Number):void 
		{
			alpha = 1;
			_fadeSteps = steps;
			_fadeTimer = new Timer(interval);
			_fadeTimer.addEventListener(TimerEvent.TIMER, fadeTimerTick);
			_fadeTimer.start();
		}
		
		private function calcPos():void 
		{
			_textField.x = -_textField.width / 2;
			_textField.y = -_textField.height / 2;
		}
		
		// -- Event CallBacks -- //
		
		private function fadeTimerTick(e:TimerEvent):void 
		{
			alpha -= _fadeSteps;
			
			if (alpha < 0)
			{
				_fadeTimer.stop();
			}
		}
		
		// -- GetSet -- //
		
		public function get Text():String
		{
			return _textField.text;
		}
		
		public function set Text(newVal:String):void 
		{
			_textField.text = newVal;
			calcPos();
		}
		
		public function get TextSize():Number
		{
			return _textField.scaleX;
		}
		
		public function set TextSize(newVal:Number):void 
		{
			_textField.scaleX = _textField.scaleY = newVal;
			calcPos();
		}
		
		public function get TextColor():uint
		{
			return _textField.textColor;
		}
		
		public function set TextColor(newVal:uint):void 
		{
			_textField.textColor = newVal;
		}
	}

}
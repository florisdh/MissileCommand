package UI.Controls {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	/**
	 * ...
	 * @author FDH
	 */
	public class Button extends Control
	{
		// -- Properties -- //
		
		// -- Vars -- //
		
		public var _textColor:uint = 0xCCCCCC;
		public var _hoverTextColor:uint = 0xEEEEEE;
		
		private var _textScale:Number = 3;
		public var _textHoverScale:Number = 3.2;
		
		private var _hover:Boolean = false;
		
		private var _textField:TextField;
		
		// -- Construct -- //
		
		public function Button() 
		{
			buttonMode = true;
			
			_textField = new TextField();
			_textField.scaleX = _textField.scaleY = _textScale;
			_textField.textColor = TextColor;
			_textField.autoSize = TextFieldAutoSize.LEFT;
			_textField.mouseEnabled = false;
			addChild(_textField);
			
			addEventListener(MouseEvent.MOUSE_OVER, onMouseEnter);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseLeave);
		}
		
		// -- EventCallBacks -- //
		
		private function onMouseEnter(e:MouseEvent):void 
		{
			_hover = true;
			_textField.scaleX = _textField.scaleY = _textHoverScale;
			_textField.textColor = HoverTextColor;
			calcTextPos();
		}
		
		private function onMouseLeave(e:MouseEvent):void 
		{
			_hover = false;
			_textField.scaleX = _textField.scaleY = _textScale;
			_textField.textColor = TextColor;
			calcTextPos();
		}
		
		// -- Methods -- //
		
		private function calcTextPos():void 
		{
			_textField.x = -_textField.width / 2;
		}
		
		// -- GetSet -- //
		
		public function set Text(text:String):void 
		{
			_textField.text = text;
			calcTextPos();
		}
		public function get Text():String
		{
			return _textField.text;
		}
		
		public function set TextScale(newVal:Number):void 
		{
			_textScale = newVal;
			if (!_hover) _textField.scaleX = _textField.scaleY = newVal;
		}
		
		public function set HoverTextScale(newVal:Number):void 
		{
			_textHoverScale = newVal;
			if (_hover) _textField.scaleX = _textField.scaleY = newVal;
		}
		
		public function get TextColor():uint
		{
			return _textColor;
		}
		
		public function set TextColor(newVal:uint):void 
		{
			_textColor = newVal;
			if (!_hover) _textField.textColor = _textColor;
		}
		
		public function get HoverTextColor():uint
		{
			return _hoverTextColor;
		}
		
		public function set HoverTextColor(newVal:uint):void
		{
			_hoverTextColor = newVal;
			if (_hover) _textField.textColor = _hoverTextColor;
		}
	}

}
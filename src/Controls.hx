package;
import openfl.events.KeyboardEvent;
import openfl.Lib;
import openfl.ui.Keyboard;

/**
 * ...
 * @author 01101101
 */
class Controls {
	
	static var keys:Map<Int, Bool>;
	
	static public function init ()
	{
		keys = new Map();
		keys.set(Keyboard.UP, false);
		keys.set(Keyboard.RIGHT, false);
		keys.set(Keyboard.DOWN, false);
		keys.set(Keyboard.LEFT, false);
		keys.set(Keyboard.SPACE, false);
		keys.set(Keyboard.ESCAPE, false);
		
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
	}
	
	static public function isDown (k:Int) :Bool
	{
		if (!keys.exists(k))
			return false;
		else
			return keys.get(k);
	}
	
	static function keyDownHandler (e:KeyboardEvent)
	{
		if (!keys.exists(e.keyCode))
			return;
		else
			keys.set(e.keyCode, true);
	}
	
	static function keyUpHandler (e:KeyboardEvent)
	{
		if (!keys.exists(e.keyCode))
			return;
		else
			keys.set(e.keyCode, false);
	}
	
}
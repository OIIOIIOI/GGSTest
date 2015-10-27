package;

import openfl.display.Sprite;
import openfl.Lib;

/**
 * ...
 * @author 01101101
 */
class Main extends Sprite
{
	
	public function new () 
	{
		super();
		// Various inits
		UI.init();
		Sprites.init();
		Controls.init();
		// Create and add game
		Lib.current.stage.addChild(new Game());
	}

}

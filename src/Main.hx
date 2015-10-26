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
		
		UI.init();
		Sprites.init();
		Controls.init();
		
		Lib.current.stage.addChild(new Game());
	}

}

package;

import Entity;

/**
 * ...
 * @author 01101101
 */
class GameOver extends Entity {
	
	public function new () {
		super();
		setAnim(Sprites.GAME_OVER);
	}
	
}
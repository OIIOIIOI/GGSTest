package;

import Entity;

/**
 * ...
 * @author 01101101
 */
class StartArea extends Entity {
	
	public function new () {
		super();
		setAnim(Sprites.START);
		
		collRadius = 16;
		collType = CollType.START;
		collList.push(CollType.PLAYER);
	}
	
	override public function hurt (c:CollType)
	{
		super.hurt(c);
		Game.INST.flashTick = 3;
		SoundMan.playOnce(SoundMan.START);
	}
	
}
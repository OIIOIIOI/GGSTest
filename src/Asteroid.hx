package;

import Entity;

/**
 * ...
 * @author 01101101
 */
class Asteroid extends MovingEntity
{
	
	public function new ()
	{
		super();
		setAnim(Sprites.ASTEROID);
		
		collRadius = 17;
		collType = CollType.ENEMY;
		collList.push(CollType.PLAYER);
		collList.push(CollType.PLAYER_BULLET);
		
		isIndestructible = true;
		diesOffScreen = false;
	}
	
}
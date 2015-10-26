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
		setAnim(Sprites.MINE);
		
		collRadius = 17;
		collType = CollType.ENEMY;
		collList.push(CollType.PLAYER);
		collList.push(CollType.PLAYER_BULLET);
		
		xVelMax = yVelMax = 2;
		yVel = 1;
		
		isIndestructible = true;
		diesOffScreen = false;
	}
	
}
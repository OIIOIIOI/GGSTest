package;

import Entity;

/**
 * ...
 * @author 01101101
 */
class Bullet extends MovingEntity
{
	
	public function new ()
	{
		super();
		setAnim(Sprites.PLAYER_BULLET);
		
		collRadius = 8;
		collType = CollType.PLAYER_BULLET;
		collList.push(CollType.ENEMY);
		
		friction = 1;
		xVelMax = 0;
		yVelMax = 30;
		yVel = -yVelMax;
	}
	
}
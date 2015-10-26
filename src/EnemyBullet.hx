package;

import Entity;

/**
 * ...
 * @author 01101101
 */
class EnemyBullet extends MovingEntity
{
	
	public function new ()
	{
		super();
		setAnim(Sprites.ENEMY_A_BULLET);
		
		collRadius = 8;
		collType = CollType.ENEMY_BULLET;
		collList.push(CollType.PLAYER);
		
		friction = 1;
		xVelMax = 0;
		yVelMax = 10;
		yVel = yVelMax;
	}
	
}
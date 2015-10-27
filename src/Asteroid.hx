package;

import Entity;

/**
 * ...
 * @author 01101101
 */
class Asteroid extends MovingEntity
{
	
	public function new (vel:Float = 2)
	{
		super();
		setAnim(Sprites.MINE);
		
		collRadius = 17;
		collType = CollType.ENEMY;
		collList.push(CollType.PLAYER);
		collList.push(CollType.PLAYER_BULLET);
		
		xVelMax = yVelMax = vel;
		yVel = yVelMax;
		
		isIndestructible = true;
		diesOffScreen = false;
	}
	
}
package;

/**
 * ...
 * @author 01101101
 */
class Bullet extends MovingEntity
{
	
	public function new ()
	{
		super();
		setAnim(Sprites.BULLET);
		
		friction = 1;
		xVelMax = 0;
		yVelMax = 40;
		yVel = -yVelMax;
	}
	
}
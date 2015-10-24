package;

/**
 * ...
 * @author 01101101
 */
class MovingEntity extends Entity
{
	var friction:Float;
	var xVel:Float;
	var yVel:Float;
	var xVelMax:Float;
	var yVelMax:Float;
	
	public function new ()
	{
		super();
		friction = 1;
		xVelMax = 100;
		yVelMax = 100;
		xVel = yVel = 0;
	}
	
	override public function update ()
	{
		super.update();
		
		xVel = Math.max(Math.min(xVel * friction, xVelMax), -xVelMax);
		if (Math.abs(xVel) < 0.01)
			xVel = 0;
		x += xVel;
		
		yVel = Math.max(Math.min(yVel * friction, yVelMax), -yVelMax);
		if (Math.abs(yVel) < 0.01)
			yVel = 0;
		y += yVel;
		
		if (x < -100 || x > Game.WIDTH + 100 || y < -100 || y > Game.HEIGHT + 100) {
			isDead = true;
		}
	}
	
}
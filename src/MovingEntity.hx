package;
import openfl.ui.Keyboard;

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
	
	var currentMove:Move;
	var diesOffScreen:Bool;
	
	public function new ()
	{
		super();
		friction = 1;
		xVelMax = 100;
		yVelMax = 100;
		xVel = yVel = 0;
		
		currentMove = Move.STATIC;
		diesOffScreen = true;
	}
	
	override public function update ()
	{
		super.update();
		
		move();
		
		xVel = Math.max(Math.min(xVel * friction, xVelMax), -xVelMax);
		if (Math.abs(xVel) < 0.01)
			xVel = 0;
		x += xVel;
		
		yVel = Math.max(Math.min(yVel * friction, yVelMax), -yVelMax);
		if (Math.abs(yVel) < 0.01)
			yVel = 0;
		y += yVel;
		
		if (diesOffScreen && (x + cx < -100 || x + cx > Game.WIDTH + 100 || y + cy < -100 || y + cy > Game.HEIGHT + 100)) {
			isDead = true;
		}
	}
	
	function move ()
	{
		switch (currentMove)
		{
			case STATIC:
				return;
			case CONTROLLED:
				if (Controls.isDown(Keyboard.RIGHT))
					xVel += xVelMax * 0.2;
				if (Controls.isDown(Keyboard.LEFT))
					xVel -= xVelMax * 0.2;
				if (Controls.isDown(Keyboard.UP))
					yVel -= yVelMax * 0.2;
				if (Controls.isDown(Keyboard.DOWN))
					yVel += yVelMax * 0.2;
		}
	}
	
}

enum Move {
	CONTROLLED;
	STATIC;
}
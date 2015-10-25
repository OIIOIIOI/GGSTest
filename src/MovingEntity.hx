package;
import openfl.geom.Point;
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
	var velMax:Float;
	
	var currentMove:Move;
	var diesOffScreen:Bool;
	
	public function new ()
	{
		super();
		friction = 1;
		xVelMax = 100;
		yVelMax = 100;
		velMax = -1;
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
			
			case CHARGER:
				if (velMax == -1) {
					Game.TAP.x = xVelMax;
					Game.TAP.y = yVelMax;
					velMax = Game.TAP.length;
				}
				var tx = Game.INST.player.x + Game.INST.player.cx;
				var ty = Game.INST.player.y + Game.INST.player.cy;
				Game.TAP.x = tx - (x + cx);
				Game.TAP.y = ty - (y + cy);
				Game.TAP.normalize(velMax);
				xVel = Game.TAP.x * xVelMax;
				yVel = yVelMax;
			
			case CHASER:
				if (velMax == -1) {
					Game.TAP.x = xVelMax;
					Game.TAP.y = yVelMax;
					velMax = Game.TAP.length;
				}
				var tx = Game.INST.player.x + Game.INST.player.cx;
				var ty = Game.INST.player.y + Game.INST.player.cy;
				Game.TAP.x = tx - (x + cx);
				Game.TAP.y = ty - (y + cy);
				Game.TAP.normalize(velMax);
				xVel = Game.TAP.x * xVelMax;
				yVel = Game.TAP.y * yVelMax;
		}
	}
	
}

enum Move
{
	CONTROLLED;
	STATIC;
	CHARGER;
	CHASER;
}
package;

import Entity;
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
		
		// If offscreen, only move down
		if (isOffScreen())
			yVel = yVelMax;
		else
			move();// Apply selected move
		
		// Limit velocity and actually update the x position
		xVel = Math.max(Math.min(xVel * friction, xVelMax), -xVelMax);
		if (Math.abs(xVel) < 0.01)
			xVel = 0;
		// Only enemies and enemy bullets are affected by speedMod
		if (collType == CollType.ENEMY || collType == CollType.ENEMY_BULLET)
			x += xVel * Game.INST.speedMod;
		else
			x += xVel;
		// Same for y
		yVel = Math.max(Math.min(yVel * friction, yVelMax), -yVelMax);
		if (Math.abs(yVel) < 0.01)
			yVel = 0;
		// Only enemies and enemy bullets are affected by speedMod
		if (collType == CollType.ENEMY || collType == CollType.ENEMY_BULLET)
			y += yVel * Game.INST.speedMod;
		else
			y += yVel;
		
		// Kill entity if offscreen and should die
		if (diesOffScreen && isOffScreen()) {
			diedOffScreen();
			isDead = true;
		}
		else if (!diesOffScreen && !isOffScreen()) {
			diesOffScreen = true;
		}
	}
	
	function diedOffScreen () { }
	
	function move ()
	{
		switch (currentMove)
		{
			// Player controlled
			case CONTROLLED:
				if (Controls.isDown(Keyboard.RIGHT))
					xVel += xVelMax * 0.2;
				if (Controls.isDown(Keyboard.LEFT))
					xVel -= xVelMax * 0.2;
				if (Controls.isDown(Keyboard.UP))
					yVel -= yVelMax * 0.2;
				if (Controls.isDown(Keyboard.DOWN))
					yVel += yVelMax * 0.2;
			// Move towards the player on the x axis and always go down
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
			// Move towards the player on both axis
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
			
			default:
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
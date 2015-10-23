package;

import openfl.ui.Keyboard;

/**
 * ...
 * @author 01101101
 */
class Player extends MovingEntity
{
	var isFiring:Bool;
	var fireRate:Int;
	var fireTick:Int;
	
	public function new ()
	{
		super();
		setAnim(Sprites.PLAYER_SHIP);
		
		friction = 0.9;
		xVelMax = 5;
		yVelMax = 3;
		
		isFiring = false;
		fireRate = 10;
		fireTick = 0;
	}
	
	override public function update ()
	{
		// Player controls
		if (Controls.isDown(Keyboard.RIGHT))
			xVel += xVelMax * 0.2;
		if (Controls.isDown(Keyboard.LEFT))
			xVel -= xVelMax * 0.2;
		if (Controls.isDown(Keyboard.UP))
			yVel -= yVelMax * 0.2;
		if (Controls.isDown(Keyboard.DOWN))
			yVel += yVelMax * 0.2;
		
		// MovingEntity update
		super.update();
		
		// Player action
		isFiring = Controls.isDown(Keyboard.SPACE);
		
		if (isFiring) {
			if (fireTick == 0) {
				Game.INST.spawnBullet();
				fireTick = fireRate;
			}
			else
				fireTick--;
		}
		else {
			fireTick = 0;
		}
		
	}
	
}
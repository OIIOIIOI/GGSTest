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
		spriteID = Sprites.PLAYER_SHIP;
		
		isFiring = false;
		fireRate = 20;
		fireTick = 0;
	}
	
	override public function update ()
	{
		// Player controls
		if (Controls.isDown(Keyboard.RIGHT))
			xVel += xVelStep;
		if (Controls.isDown(Keyboard.LEFT))
			xVel -= xVelStep;
		if (Controls.isDown(Keyboard.UP))
			yVel -= yVelStep;
		if (Controls.isDown(Keyboard.DOWN))
			yVel += yVelStep;
		
		// MovingEntity update
		super.update();
		
		// Player action
		isFiring = Controls.isDown(Keyboard.SPACE);
		
		if (isFiring) {
			if (fireTick == 0) {
				// FIRE!
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
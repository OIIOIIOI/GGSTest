package;

import Entity;
import MovingEntity;
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
		
		collRadius = 15;
		collType = CollType.PLAYER;
		collList.push(CollType.ENEMY);
		
		friction = 0.9;
		xVelMax = 5;
		yVelMax = 3;
		
		isFiring = false;
		fireRate = 10;
		fireTick = 0;
		
		currentMove = Move.CONTROLLED;
		diesOffScreen = false;
	}
	
	override public function update ()
	{
		// MovingEntity update
		super.update();
		
		if (x < 10)	x = 10;
		else if (x + 2 * cx - 10 > Game.WIDTH)	x = Game.WIDTH - 2 * cx + 10;
		if (y + 2 * cy - 10 > Game.HEIGHT)	y = Game.HEIGHT - 2 * cy + 10;
		else if (y < 10)	y = 10;
		
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
package;

import Entity;
import MovingEntity;
import openfl.ui.Keyboard;
import Particle;

/**
 * ...
 * @author 01101101
 */
class Player extends MovingEntity
{
	var isFiring:Bool;
	var fireRate:Int;
	
	var lastShot:Int;
	
	public function new ()
	{
		super();
		setAnim(Sprites.PLAYER_SHIP);
		cy += 3;
		
		collRadius = 15;
		collType = CollType.PLAYER;
		collList.push(CollType.ENEMY);
		
		friction = 0.85;
		xVelMax = 5;
		yVelMax = 5;
		
		isFiring = false;
		fireRate = 15;
		lastShot = 0;
		
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
		
		if (isFiring && !isDead)
		{
			if (Game.INST.tick - lastShot >= fireRate)
			{
				var b = new Bullet();
				b.x = x + cx - b.cx;
				b.y = y - 16;
				
				Game.INST.addEntity(b);
				
				Game.INST.shake(1, 3);
				SoundMan.playOnce(SoundMan.PLAYER_SHOT);
				
				lastShot = Game.INST.tick;
			}
		}
	}
	
	override public function hurt (c:CollType)
	{
		if (c != CollType.POINTS && c != CollType.START)
			super.hurt(c);
		
		if (health <= 0)
		{
			Game.INST.spawnParticles(ParticleType.YELLOW, x + cx, y + cy, 10);
			Game.INST.shake(6, 60);
			Game.INST.flashTick = 10;
			SoundMan.playOnce(SoundMan.PLAYER_DEATH, 1.5);
			Game.INST.gameOver();
		}
	}
	
}
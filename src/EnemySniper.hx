package;

import Entity;
import Particle;
/**
 * ...
 * @author 01101101
 */
class EnemySniper extends MovingEntity
{
	var fireRate:Int;
	var fireTick:Int;
	
	public function new ()
	{
		super();
		setAnim(Sprites.ENEMY_SNIPER);
		
		collRadius = 20;
		collType = CollType.ENEMY;
		collList.push(CollType.PLAYER);
		collList.push(CollType.PLAYER_BULLET);
		
		fireRate = 99;// Can be set to less than an animation frame duration for multiple shots
		fireTick = 0;
		
		health = 3;
		
		yVel = yVelMax = 1;
		
		diesOffScreen = false;
	}
	
	override public function update ()
	{
		super.update();
		
		// If is on screen, is not "dead" (more than the core remaining) and is time (animation frame 0)
		if (health > 1 && frame == 0 && !isOffScreen())
		{
			// If fire delay has passed
			if (fireTick == 0)
			{
				// Create a bullet
				var b = new EnemyBullet();
				b.x = x + cx - b.cx;
				b.y = y + cy - b.cy;
				// Target player
				b.xVelMax = b.yVelMax = 2;
				var tx = Game.INST.player.x + Game.INST.player.cx;
				var ty = Game.INST.player.y + Game.INST.player.cy;
				Game.TAP.x = tx - (x + cx);
				Game.TAP.y = ty - (y + cy);
				Game.TAP.normalize(b.xVelMax);
				b.xVel = Game.TAP.x;
				b.yVel = Game.TAP.y;
				// Add the bullet
				Game.INST.addEntity(b);
				// Play sound
				SoundMan.playOnce(SoundMan.TURRET_SHOT);
				// Reset fire delay
				fireTick = fireRate;
			}
			else
				fireTick--;
		}
		else
			fireTick = 0;
	}
	
	override public function hurt (c:CollType)
	{
		super.hurt(c);
		
		if (health == 2)
		{
			// Throw a few particles
			Game.INST.spawnParticles(ParticleType.ORANGE, x + cx, y + cy, 4);
			SoundMan.playOnce(SoundMan.HURT);
			// Change sprite but keep the animation going
			var f = frame;
			setAnim(Sprites.ENEMY_SNIPER_HURT, false, true);
			frame = f;
		}
		else if (health == 1)
		{
			// Explode and shake
			Game.INST.spawnParticles(ParticleType.YELLOW, x + cx, y + cy, 6);
			Game.INST.shake(3, 6);
			SoundMan.playOnce(SoundMan.ENEMY_DEATH);
			// Scoring
			Game.INST.chain++;
			Game.INST.addScore(150);
			// Spawn points
			for (i in 0...12) {
				var p = new Points();
				p.x = x + cx + (Std.random(2) * 2 - 1) * Std.random(16);
				p.y = y + cy + (Std.random(2) * 2 - 1) * Std.random(16);
				Game.INST.addEntity(p);
			}
			// Change sprite again
			var f = frame;
			setAnim(Sprites.ENEMY_SNIPER_CORE);
			frame = f;
			// I'm indestructible now!
			isIndestructible = true;
			collRadius = 9;
		}
	}
	
	override function diedOffScreen ()
	{
		super.diedOffScreen();
		// Break chain only if more than the core was remaining
		if (health > 1) {
			Game.INST.chain = 0;
			UI.refresh();
		}
	}
	
}
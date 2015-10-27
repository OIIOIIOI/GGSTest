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
		
		fireRate = 99;
		fireTick = 0;
		
		health = 3;
		
		yVel = yVelMax = 1;
		
		diesOffScreen = false;
	}
	
	override public function update ()
	{
		super.update();
		
		if (health > 1 && frame == 0 && !isOffScreen())
		{
			if (fireTick == 0)
			{
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
				
				Game.INST.addEntity(b);
				
				SoundMan.playOnce(SoundMan.TURRET_SHOT);
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
			Game.INST.spawnParticles(ParticleType.ORANGE, x + cx, y + cy, 4);
			SoundMan.playOnce(SoundMan.HURT);
			
			var f = frame;
			setAnim(Sprites.ENEMY_SNIPER_HURT, false, true);
			frame = f;
		}
		else if (health == 1)
		{
			Game.INST.spawnParticles(ParticleType.YELLOW, x + cx, y + cy, 4);
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
			// Switch to last anim
			var f = frame;
			setAnim(Sprites.ENEMY_SNIPER_CORE, false, true);
			frame = f;
			// Indestructible now
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
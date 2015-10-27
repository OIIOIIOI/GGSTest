package;

import Entity;
import MovingEntity;
import Particle;

/**
 * ...
 * @author 01101101
 */
class EnemyCharger extends MovingEntity
{
	// "Hard" variant (orange 2 health)
	var hard:Bool;
	
	public function new (h:Bool = false)
	{
		super();
		hard = h;
		if (hard) {
			setAnim(Sprites.ENEMY_CHARGER_B);
			health = 2;
		}
		else
			setAnim(Sprites.ENEMY_CHARGER);
		
		collRadius = 12;
		collType = CollType.ENEMY;
		collList.push(CollType.PLAYER);
		collList.push(CollType.PLAYER_BULLET);
		
		xVelMax = 1;
		yVelMax = 1.5;
		
		currentMove = Move.CHARGER;
		diesOffScreen = false;
	}
	
	override public function hurt (c:CollType)
	{
		super.hurt(c);
		
		if (health <= 0)
		{
			// Explode and shake
			Game.INST.spawnParticles(ParticleType.YELLOW, x + cx, y + cy, 3);
			Game.INST.shake(3, 6);
			SoundMan.playOnce(SoundMan.ENEMY_DEATH);
			// Scoring
			Game.INST.chain++;
			if (hard)
				Game.INST.addScore(70);
			else
				Game.INST.addScore(40);
			// Spawn points
			for (i in 0...5) {
				var p = new Points();
				p.x = x + cx + (Std.random(2) * 2 - 1) * Std.random(16);
				p.y = y + cy + (Std.random(2) * 2 - 1) * Std.random(16);
				Game.INST.addEntity(p);
			}
		}
		else
		{
			// Throw a few particles and change sprite
			Game.INST.spawnParticles(ParticleType.ORANGE, x + cx, y + cy, 2);
			SoundMan.playOnce(SoundMan.HURT);
			if (health == 1)
				setAnim(Sprites.ENEMY_CHARGER);
		}
	}
	
	override function diedOffScreen ()
	{
		super.diedOffScreen();
		// Break chain (enemy got out)
		Game.INST.chain = 0;
		UI.refresh();
	}
	
}
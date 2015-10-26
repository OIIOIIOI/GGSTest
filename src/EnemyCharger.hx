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
	
	public function new ()
	{
		super();
		setAnim(Sprites.ENEMY_CHARGER, true);
		
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
			Game.INST.spawnParticles(ParticleType.YELLOW, x + cx, y + cy, 3);
			Game.INST.shake(3, 6);
			SoundMan.playOnce(SoundMan.ENEMY_DEATH);
			// Scoring
			Game.INST.chain++;
			Game.INST.addScore(100);
			// Spawn points
			for (i in 0...5) {
				var p = new Points();
				p.x = x + cx + (Std.random(2) * 2 - 1) * Std.random(16);
				p.y = y + cy + (Std.random(2) * 2 - 1) * Std.random(16);
				Game.INST.addEntity(p);
			}
		}
	}
	
	override function diedOffScreen ()
	{
		super.diedOffScreen();
		Game.INST.chain = 0;
	}
	
}
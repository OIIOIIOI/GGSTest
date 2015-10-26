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
		
		xVelMax = yVelMax = 2;
		
		currentMove = Move.CHARGER;
		diesOffScreen = false;
	}
	
	override public function hurt ()
	{
		super.hurt();
		
		if (health <= 0)
		{
			Game.INST.spawnParticles(ParticleType.YELLOW, x + cx, y + cy, 3);
			Game.INST.shake(3, 6);
			SoundMan.playOnce(SoundMan.ENEMY_DEATH);
		}
	}
	
}
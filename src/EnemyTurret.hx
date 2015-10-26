package;

import Entity;
import Particle;
/**
 * ...
 * @author 01101101
 */
class EnemyTurret extends MovingEntity
{
	var fireRate:Int;
	var fireTick:Int;
	
	public function new ()
	{
		super();
		setAnim(Sprites.ENEMY_A_SHIP);
		frame = Std.random(totalFrames - 1) + 1;
		
		collRadius = 20;
		collType = CollType.ENEMY;
		collList.push(CollType.PLAYER);
		collList.push(CollType.PLAYER_BULLET);
		
		fireRate = 99;
		fireTick = 0;
		
		health = 2;
		
		yVel = yVelMax = 0.5;
		
		diesOffScreen = false;
	}
	
	override public function update ()
	{
		super.update();
		
		if (frame == 0)
		{
			if (fireTick == 0)
			{
				for (i in 0...4)
				{
					var b = new EnemyBullet();
					b.xVelMax = b.yVelMax = 3;
					switch (i)
					{
						case 0:
							b.xVel = b.xVelMax;
							b.yVel = b.yVelMax;
							b.x = x + 2 * cx - b.cx;
							b.y = y + 2 * cy - b.cy;
						case 1:
							b.xVel = -b.xVelMax;
							b.yVel = b.yVelMax;
							b.x = x - b.cx;
							b.y = y + 2 * cy - b.cy;
						case 2:
							b.xVel = b.xVelMax;
							b.yVel = -b.yVelMax;
							b.x = x + 2 * cx - b.cx;
							b.y = y - b.cy;
						case 3:
							b.xVel = -b.xVelMax;
							b.yVel = -b.yVelMax;
							b.x = x - b.cx;
							b.y = y - b.cy;
					}
					Game.INST.addEntity(b);
				}
				SoundMan.playOnce(SoundMan.TURRET_SHOT);
				fireTick = fireRate;
			}
			else
				fireTick--;
		}
		else
			fireTick = 0;
	}
	
	override public function hurt ()
	{
		super.hurt();
		
		if (health <= 0)
		{
			Game.INST.spawnParticles(ParticleType.YELLOW, x + cx, y + cy, 8);
			Game.INST.shake(3, 6);
			SoundMan.playOnce(SoundMan.ENEMY_DEATH);
		}
		else
		{
			Game.INST.spawnParticles(ParticleType.ORANGE, x + cx, y + cy, 1);
			SoundMan.playOnce(SoundMan.HURT);
			if (health == 1) {
				setAnim(Sprites.ENEMY_A_SHIP_HURT);
				frame = 1;
			}
		}
	}
	
}
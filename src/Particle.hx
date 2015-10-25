package;

/**
 * ...
 * @author 01101101
 */
class Particle extends MovingEntity {
	
	var lifetime:Int;
	
	public function new (t:ParticleType) {
		super();
		
		switch (t)
		{
			case ParticleType.PLAYER_BULLET:
				lifetime = 20 + Std.random(10);
				setAnim(Sprites.PLAYER_BULLET_PART);
				xVel = (Std.random(2) * 2 - 1) * Std.random(300) / 100;
				yVel = Std.random(600) / 100;
			case ParticleType.ENEMY_A:
				lifetime = 60 + Std.random(40);
				setAnim(Sprites.ENEMY_A_PART);
				frame = Std.random(totalFrames);// Pick a random frame
				totalFrames = 1;// Disable animation
				xVel = (Std.random(2) * 2 - 1) * Std.random(100) / 100;
				yVel = (Std.random(2) * 2 - 1) * Std.random(100) / 100;
			case ParticleType.ASTEROID:
				lifetime = 60 + Std.random(40);
				setAnim(Sprites.ASTEROID_PART);
				frame = Std.random(totalFrames);// Pick a random frame
				totalFrames = 1;// Disable animation
				xVel = (Std.random(2) * 2 - 1) * Std.random(100) / 100;
				yVel = (Std.random(2) * 2 - 1) * Std.random(100) / 100;
		}
	}
	
	override public function update ()
	{
		super.update();
		
		lifetime--;
		if (lifetime <= 0)
			isDead = true;
	}
	
}

enum ParticleType {
	PLAYER_BULLET;
	ENEMY_A;
	ASTEROID;
}
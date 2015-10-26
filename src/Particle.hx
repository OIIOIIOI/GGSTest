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
			case ParticleType.YELLOW_BULLET:
				lifetime = 20 + Std.random(10);
				setAnim(Sprites.YELLOW_BULLET_PART);
				xVel = (Std.random(2) * 2 - 1) * Std.random(300) / 100;
				yVel = Std.random(600) / 100;
			case ParticleType.ORANGE:
				lifetime = 60 + Std.random(40);
				setAnim(Sprites.ORANGE_PART);
				frame = Std.random(totalFrames);// Pick a random frame
				totalFrames = 1;// Disable animation
				xVel = (Std.random(2) * 2 - 1) * Std.random(100) / 100;
				yVel = (Std.random(2) * 2 - 1) * Std.random(100) / 100;
			case ParticleType.YELLOW:
				lifetime = 60 + Std.random(40);
				setAnim(Sprites.YELLOW_PART);
				frame = Std.random(totalFrames);// Pick a random frame
				totalFrames = 1;// Disable animation
				xVel = (Std.random(2) * 2 - 1) * Std.random(100) / 100;
				yVel = (Std.random(2) * 2 - 1) * Std.random(100) / 100;
			case ParticleType.STAR:
				lifetime = 999;
				setAnim(Sprites.STAR_PART, true);
				xVel = 0;
				yVel = 2;
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
	YELLOW_BULLET;
	ORANGE;
	YELLOW;
	STAR;
}
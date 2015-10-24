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
			case BULLET:
				lifetime = 30 + Std.random(20);
				setAnim(Sprites.BULLET_PART);
				xVel = (Std.random(2) * 2 - 1) * Std.random(300) / 100;
				yVel = Std.random(500) / 100;
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
	BULLET;
}
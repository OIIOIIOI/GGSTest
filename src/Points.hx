package;

import Entity;
import MovingEntity;

/**
 * ...
 * @author 01101101
 */
class Points extends MovingEntity {
	
	public function new () {
		super();
		setAnim(Sprites.POINTS, true);
		
		collRadius = 6;
		collType = CollType.POINTS;
		collList.push(CollType.PLAYER);
		
		friction = 0.97;
		xVelMax = yVelMax = 2;
		xVel = (Std.random(2) * 2 - 1) * Std.random(100) / 100;
		yVel = (Std.random(2) * 2 - 1) * Std.random(100) / 100;
	}
	
	override public function update ()
	{
		super.update();
		
		if (Game.INST.getDistance(Game.INST.player, this) < 100) {
			friction = 1;
			currentMove = Move.CHASER;
		}
		else {
			friction = 0.97;
			currentMove = Move.STATIC;
		}
	}
	
	override public function hurt (c:CollType)
	{
		super.hurt(c);
		SoundMan.playOnce(SoundMan.POINTS, 0.25);
		Game.INST.addScore(9);
	}
	
}
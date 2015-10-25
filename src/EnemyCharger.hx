package;

import Entity;
import MovingEntity;

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
	
}
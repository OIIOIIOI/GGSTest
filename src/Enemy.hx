package;

import Entity;
/**
 * ...
 * @author 01101101
 */
class Enemy extends MovingEntity
{
	
	public function new ()
	{
		super();
		setAnim(Sprites.ENEMY_SHIP);
		
		collRadius = 20;
		collType = CollType.ENEMY;
		collList.push(CollType.PLAYER);
		collList.push(CollType.PLAYER_BULLET);
	}
	
}
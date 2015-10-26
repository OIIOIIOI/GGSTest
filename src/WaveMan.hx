package;

/**
 * ...
 * @author 01101101
 */
class WaveMan {
	
	static var currentWave:Array<Entity>;
	
	static public function spawnWave (w:Int)
	{
		currentWave = [];
		
		switch (w)
		{
			case 0:
				addSideChargers();
				addMine();
				addDoubleMine(-100);
				addTripleMine(-200);
				addTurret(-50);
				addDoubleTurret(-100);
		}
		
		for (e in currentWave)
		{
			Game.INST.addEntity(e);
		}
	}
	
	static function addSideChargers (y:Int = 0)
	{
		for (i in 0...3)
		{
			// Left colummn
			var e = new EnemyCharger();
			e.x = 16 - e.cx + Game.INST.shakeOffset;
			e.y = -i * 80 + y;
			currentWave.push(e);
			// Right column
			e = new EnemyCharger();
			e.x = Game.WIDTH - 16 - e.cx + Game.INST.shakeOffset;
			e.y = -i * 80 + 40 + y;
			currentWave.push(e);
		}
	}
	
	static function addMine (y:Int = 0)
	{
		var e = new Asteroid();
		e.x = Game.WIDTH / 2 - e.cx + Game.INST.shakeOffset;
		e.y = y;
		currentWave.push(e);
	}
	
	static function addDoubleMine (y:Int = 0)
	{
		for (i in 0...2)
		{
			var e = new Asteroid();
			e.x = Game.WIDTH / 3 * (i + 1) - e.cx + Game.INST.shakeOffset;
			e.y = y;
			currentWave.push(e);
		}
	}
	
	static function addTripleMine (y:Int = 0)
	{
		for (i in 0...3)
		{
			var e = new Asteroid();
			e.x = Game.WIDTH / 4 * (i + 1) + 32 * (i - 1) - e.cx + Game.INST.shakeOffset;
			e.y = y;
			currentWave.push(e);
		}
	}
	
	static function addTurret (y:Int = 0)
	{
		var e = new EnemyTurret();
		e.x = Game.WIDTH / 2 - e.cx + Game.INST.shakeOffset;
		e.y = y;
		currentWave.push(e);
	}
	
	static function addDoubleTurret (y:Int = 0)
	{
		var e = new EnemyTurret();
		e.x = 48 - e.cx + Game.INST.shakeOffset;
		e.y = y;
		currentWave.push(e);
		e = new EnemyTurret();
		e.x = Game.WIDTH - 48 - e.cx + Game.INST.shakeOffset;
		e.y = y;
		currentWave.push(e);
	}
}
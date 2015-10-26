package;

/**
 * ...
 * @author 01101101
 */
class WaveMan {
	
	static public var waveIndex:Int;
	static var currentWave:Array<Entity>;
	
	static public function spawnWave (w:Int)
	{
		if (w > 3)	w = 1;
		waveIndex = w;
		currentWave = [];
		
		switch (waveIndex)
		{
			case 0:
				addStartArea();
			case 1:
				addSideChargers(-100);
				addTurret(-100);
				addDoubleTurret(-150);
			case 2:
				addMine(-100);
				addDoubleMine(-200);
				addTripleMine(-300);
			case 3:
				addTurret(-100);
				addTurret(-300);
				addTripleMine(-150);
				addDoubleTurret(-200);
		}
		
		for (e in currentWave) {
			Game.INST.addEntity(e);
		}
		
		UI.refresh();
	}
	
	static public function update ()
	{
		currentWave = currentWave.filter(Game.INST.filterDead);
		// Spawn the next wave if the current one is done
		if (currentWave.length == 0)
			spawnWave(waveIndex + 1);
	}
	
	static function addStartArea ()
	{
		var e = new StartArea();
		e.x = Game.WIDTH / 2 - e.cx + Game.INST.shakeOffset;
		e.y = Game.HEIGHT / 2 - e.cy + Game.INST.shakeOffset;
		currentWave.push(e);
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
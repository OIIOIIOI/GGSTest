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
		waveIndex = w;
		currentWave = [];
		
		// Loop handling (player has completed all 10 waves once or more
		if (w > 10) {
			w = ((w - 1) % 10) + 1;
			// Speed goes up every loop
			Game.INST.speedMod * Math.pow(1.5, Std.int((w - 1) / 10));
		}
		
		switch (w)
		{
			case 0:
				addStartArea();
			case 1:
				addRight(EnemyCharger, -100);
				addLeft(EnemyCharger, -100);
				addCenter(EnemyCharger, -250, [true]);
				addRight(EnemyCharger, -400);
				addLeft(EnemyCharger, -400);
			case 2:
				addDual(EnemyCharger, -100);
				addDual(EnemyCharger, -300);
				addDual(EnemyCharger, -500);
				addRight(Asteroid, -100);
				addLeft(Asteroid, -250);
				addRight(Asteroid, -400);
				addLeft(Asteroid, -550);
			case 3:
				addQuad(EnemyCharger, -100);
				addCenter(EnemyTurret, -150);
				addLeft(EnemyCharger, -300);
				addRight(EnemyCharger, -300);
			case 4:
				addLeft(Asteroid, -300);
				addRight(Asteroid, -300);
				addCenter(EnemySniper, -100);
				addRight(EnemyCharger, -480);
				addLeft(EnemyCharger, -480);
				addRight(EnemyCharger, -580);
				addLeft(EnemyCharger, -580);
			case 5:
				addLeft(EnemyTurret, -100);
				addRight(EnemyTurret, -100);
				addLeft(EnemyTurret, -350);
				addRight(EnemyTurret, -350);
				addLeft(EnemyTurret, -600);
				addRight(EnemyTurret, -600);
			case 6:
				addCenter(EnemyCharger, -100);
				addDual(EnemyCharger, -160);
				addTriple(EnemyCharger, -220, [null, [true]]);
				addQuad(EnemyCharger, -280, [[true], [true]]);
				addCenter(EnemyCharger, -340);
				addDual(EnemyCharger, -340);
				addLeft(EnemyCharger, -340);
				addRight(EnemyCharger, -340);
			case 7:
				addCenter(EnemySniper, -100);
				addCenter(EnemySniper, -400);
				addCenter(Asteroid, -250, [1]);
				addLeft(EnemySniper, -250);
				addRight(EnemySniper, -250);
			case 8:
				addCenter(Asteroid, -100, [1.7]);
				addLeft(Asteroid, -100, [1.6]);
				addRight(Asteroid, -100, [1.4]);
				addDual(Asteroid, -100, [[1.5], [1.8]]);
				addQuad(EnemyCharger, -350);
				addQuad(EnemyCharger, -500, [[true], [true], [true], [true]]);
			case 9:
				addDual(EnemyTurret, -100);
				addTriple(EnemySniper, -250);
				addDual(Asteroid, -370, [[1], [1]]);
				addCenter(EnemyCharger, -600);
				addCenter(EnemyCharger, -700);
				addCenter(EnemyCharger, -800);
			case 10:
				for (i in 0...9) {
					addCenter(EnemyCharger, -60 * (i + 1), [i % 2 == 1]);
					addLeft(EnemyCharger, -60 * (i + 1), [i % 4 == 0]);
					addRight(EnemyCharger, -60 * (i + 1), [i % 4 == 0]);
				}
		}
		
		for (e in currentWave) {
			Game.INST.addEntity(e);
		}
		
		UI.refresh();
	}
	
	static public function update ()
	{
		currentWave = currentWave.filter(waveFilter);
		// Spawn the next wave if the current one is done
		if (currentWave.length == 0)
			spawnWave(waveIndex + 1);
	}
	
	static function waveFilter (e:Entity) :Bool
	{
		// Filter dead entities
		if (e.isDead)
			return false;
		// Filter indestructible entities that are more than 2/3 of the way out
		else if (e.isIndestructible && e.y + e.cy > Game.HEIGHT / 3 * 2)
			return false;
		else
			return true;
	}
	
	static function addStartArea ()
	{
		var e = new StartArea();
		e.x = Game.WIDTH / 2 - e.cx + Game.INST.shakeOffset;
		e.y = Game.HEIGHT / 2 - e.cy + Game.INST.shakeOffset;
		currentWave.push(e);
	}
	
	static function addCenter (c:Class<Entity>, y:Int = 0, p:Array<Dynamic> = null)
	{
		if (p == null)	p = [];
		var e = Type.createInstance(c, p);
		e.x = Game.WIDTH / 2 - e.cx + Game.INST.shakeOffset;
		e.y = y;
		currentWave.push(e);
	}
	
	static function addLeft (c:Class<Entity>, y:Int = 0, p:Array<Dynamic> = null)
	{
		if (p == null)	p = [];
		var e = Type.createInstance(c, p);
		e.x = Game.WIDTH / 6 - e.cx + Game.INST.shakeOffset;
		e.y = y;
		currentWave.push(e);
	}
	
	static function addRight (c:Class<Entity>, y:Int = 0, p:Array<Dynamic> = null)
	{
		if (p == null)	p = [];
		var e = Type.createInstance(c, p);
		e.x = Game.WIDTH / 6 * 5 - e.cx + Game.INST.shakeOffset;
		e.y = y;
		currentWave.push(e);
	}
	
	static function addDual (c:Class<Entity>, y:Int = 0, p:Array<Array<Dynamic>> = null)
	{
		if (p == null)	p = [];
		while (p.length < 2) {
			p.push([]);
		}
		for (i in 0...2)
		{
			var pa = (p[i] != null) ? p[i] : [];
			var e = Type.createInstance(c, pa);
			e.x = Game.WIDTH / 3 * (i + 1) - e.cx + Game.INST.shakeOffset;
			e.y = y;
			currentWave.push(e);
		}
	}
	
	static function addTriple (c:Class<Entity>, y:Int = 0, p:Array<Array<Dynamic>> = null)
	{
		if (p == null)	p = [];
		while (p.length < 3) {
			p.push([]);
		}
		for (i in 0...3)
		{
			var pa = (p[i] != null) ? p[i] : [];
			var e = Type.createInstance(c, pa);
			e.x = Game.WIDTH / 4 * (i + 1) + 24 * (i - 1) - e.cx + Game.INST.shakeOffset;
			e.y = y;
			currentWave.push(e);
		}
	}
	
	static function addQuad (c:Class<Entity>, y:Int = 0, p:Array<Array<Dynamic>> = null)
	{
		if (p == null)	p = [];
		while (p.length < 4) {
			p.push([]);
		}
		for (i in 0...2)
		{
			var pa = (p[i * 2] != null) ? p[i * 2] : [];
			var e = Type.createInstance(c, pa);
			e.x = Game.WIDTH / 2 + Game.WIDTH / 8 * (i * 2 + 1) - e.cx + Game.INST.shakeOffset;
			e.y = y;
			currentWave.push(e);
			
			pa = (p[i * 2 + 1] != null) ? p[i * 2 + 1] : [];
			e = Type.createInstance(c, pa);
			e.x = Game.WIDTH / 2 - Game.WIDTH / 8 * (i * 2 + 1) - e.cx + Game.INST.shakeOffset;
			e.y = y;
			currentWave.push(e);
		}
	}
}
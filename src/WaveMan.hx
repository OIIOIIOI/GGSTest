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
				addDual(EnemyCharger, -100);
				addCenter(EnemySniper, -50);
			case 2:
				addCenter(EnemyCharger, -100);
				addDual(EnemyCharger, -150, [true]);
				addTriple(EnemyCharger, -200);
			case 3:
				addCenter(EnemyCharger, -100, [true]);
				addDual(EnemyCharger, -150, [true]);
				addTriple(EnemyCharger, -200);
				addQuad(EnemyCharger, -250);
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
		// Filter indestructible entities that are more than 3/4 of the way out
		else if (e.isIndestructible && e.y + e.cy > Game.HEIGHT / 4 * 3)
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
	
	static function addDual (c:Class<Entity>, y:Int = 0, p:Array<Dynamic> = null)
	{
		if (p == null)	p = [];
		for (i in 0...2)
		{
			var e = Type.createInstance(c, p);
			e.x = Game.WIDTH / 3 * (i + 1) - e.cx + Game.INST.shakeOffset;
			e.y = y;
			currentWave.push(e);
		}
	}
	
	static function addTriple (c:Class<Entity>, y:Int = 0, p:Array<Dynamic> = null)
	{
		if (p == null)	p = [];
		for (i in 0...3)
		{
			var e = Type.createInstance(c, p);
			e.x = Game.WIDTH / 4 * (i + 1) + 24 * (i - 1) - e.cx + Game.INST.shakeOffset;
			e.y = y;
			currentWave.push(e);
		}
	}
	
	static function addQuad (c:Class<Entity>, y:Int = 0, p:Array<Dynamic> = null)
	{
		if (p == null)	p = [];
		for (i in 0...2)
		{
			var e = Type.createInstance(c, p);
			e.x = Game.WIDTH / 2 + Game.WIDTH / 8 * (i * 2 + 1) - e.cx + Game.INST.shakeOffset;
			e.y = y;
			currentWave.push(e);
			
			e = Type.createInstance(c, p);
			e.x = Game.WIDTH / 2 - Game.WIDTH / 8 * (i * 2 + 1) - e.cx + Game.INST.shakeOffset;
			e.y = y;
			currentWave.push(e);
		}
	}
}
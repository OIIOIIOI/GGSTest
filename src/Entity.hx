package;

/**
 * ...
 * @author 01101101
 */
class Entity
{
	
	public var spriteID(default, null):String;
	public var frame:Int;
	var totalFrames:Int;
	var animDelay:Int;
	var animTick:Int;
	
	public var x:Float;
	public var y:Float;
	
	// Center of the sprite
	public var cx:Int;
	public var cy:Int;
	
	public var collRadius:Int;
	public var collType:CollType;
	public var collList:Array<CollType>;
	
	public var isIndestructible:Bool;
	public var health:Int;
	public var isDead:Bool;
	
	public function new ()
	{
		setAnim("");
		
		x = y = 0;
		collRadius = 0;
		collList = [];
		
		isIndestructible = false;
		health = 1;
		isDead = false;
	}
	
	public function setAnim (id:String, randomStart:Bool = false, keepState:Bool = false)
	{
		spriteID = id;
		animDelay = 0;
		if (!keepState)		animTick = 0;
		totalFrames = 1;
		if (!keepState)		frame = 0;
		cx = cy = 0;
		
		var sheet = Sprites.getSheet(spriteID);
		if (sheet == null)	return;
		
		animDelay = sheet.delay;
		if (!keepState)		animTick = sheet.delay;
		if (randomStart)	animTick = Std.random(sheet.delay);
		totalFrames = sheet.frames;
		
		cx = Std.int(sheet.data.width / sheet.frames / 2);
		cy = Std.int(sheet.data.height / 2);
	}
	
	public function update ()
	{
		if (totalFrames > 1)
		{
			if (animTick <= 0)
			{
				animTick = animDelay;
				frame++;
				if (frame >= totalFrames)
					frame = 0;
			}
			else {
				animTick--;
			}
		}
	}
	
	public function hurt (c:CollType)
	{
		if (isIndestructible)
			return;
		
		health--;
		if (health <= 0)
			isDead = true;
	}
	
	public function isOffScreen () :Bool
	{
		return (x + 2 * cx < 0 || x > Game.WIDTH || y + 2 * cy < 0 || y > Game.HEIGHT);
	}
	
}

enum CollType
{
	PLAYER;
	ENEMY;
	PLAYER_BULLET;
	ENEMY_BULLET;
	POINTS;
	START;
}

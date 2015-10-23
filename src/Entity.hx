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
	
	public function new ()
	{
		setAnim("");
		
		x = y = 0;
	}
	
	public function setAnim (id:String)
	{
		spriteID = id;
		animDelay = animTick = 0;
		totalFrames = 1;
		frame = 0;
		var sheet = Sprites.getSheet(spriteID);
		if (sheet != null) {
			animDelay = animTick = sheet.delay;
			totalFrames = sheet.frames;
		}
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
	
}
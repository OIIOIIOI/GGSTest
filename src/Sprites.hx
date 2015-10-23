package;

import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;

/**
 * ...
 * @author 01101101
 */
class Sprites
{
	
	static public var PLAYER_SHIP:String = "player_ship";
	static public var BULLET:String = "bullet";
	
	static var sprites:Map<String, BitmapData>;
	
	static public function init ()
	{
		sprites = new Map();
		sprites.set(PLAYER_SHIP, Assets.getBitmapData("img/playerShip1_orange.png"));
		sprites.set(BULLET, Assets.getBitmapData("img/laserGreen04.png"));
	}
	
	static public function draw (c:BitmapData, id:String, x:Float = 0, y:Float = 0)
	{
		if (sprites == null || !sprites.exists(id))
			return;
		
		var data:BitmapData = sprites.get(id);
		
		Game.TAR.x = Game.TAR.y = 0;
		Game.TAR.width = data.width;
		Game.TAR.height = data.height;
		
		Game.TAP.x = x;
		Game.TAP.y = y;
		
		c.copyPixels(data, Game.TAR, Game.TAP);
	}
	
}
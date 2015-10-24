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
	
	static public var ENEMY_SHIP:String = "enemy_ship";
	static public var PLAYER_SHIP:String = "player_ship";
	static public var BULLET:String = "bullet";
	
	static public var BULLET_PART:String = "bullet_part";
	
	static var sprites:Map<String, SpriteSheet>;
	
	static public function init ()
	{
		sprites = new Map();
		
		sprites.set(ENEMY_SHIP, { data:Assets.getBitmapData("img/enemy3X.png"), frames:1, delay:0 });
		sprites.set(PLAYER_SHIP, { data:Assets.getBitmapData("img/ship3X.png"), frames:2, delay:3 });
		sprites.set(BULLET, { data:Assets.getBitmapData("img/bullet3X.png"), frames:1, delay:0 });
		
		sprites.set(BULLET_PART, { data:new BitmapData(3, 3, false, 0xFFECD078), frames:1, delay:0 } );
	}
	
	static public function getSheet (id:String) :SpriteSheet
	{
		if (sprites == null || !sprites.exists(id))
			return null;
		return sprites.get(id);
	}
	
	static public function draw (c:BitmapData, id:String, x:Float = 0, y:Float = 0, frame:Int = 0)
	{
		if (sprites == null || !sprites.exists(id))
			return;
		
		var sheet:SpriteSheet = sprites.get(id);
		var data = sheet.data;
		
		Game.TAR.width = data.width / sheet.frames;
		Game.TAR.height = data.height;
		Game.TAR.x = frame * Game.TAR.width;
		Game.TAR.y = 0;
		
		Game.TAP.x = Math.round(x);
		Game.TAP.y = Math.round(y);
		
		c.copyPixels(data, Game.TAR, Game.TAP);
	}
	
}

typedef SpriteSheet = {
	data:BitmapData,
	frames:Int,
	delay:Int
}
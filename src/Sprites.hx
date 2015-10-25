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
	static public var ENEMY_A_SHIP:String = "enemy_ship";
	static public var ENEMY_CHARGER:String = "enemy_charger";
	static public var PLAYER_SHIP:String = "player_ship";
	static public var PLAYER_BULLET:String = "bullet";
	static public var MINE:String = "mine";
	
	static public var PLAYER_BULLET_PART:String = "bullet_part";
	static public var ENEMY_A_PART:String = "enemy_a_part";
	static public var PLAYER_PART:String = "player_part";
	
	static var sprites:Map<String, SpriteSheet>;
	
	static public function init ()
	{
		sprites = new Map();
		
		sprites.set(ENEMY_A_SHIP, { data:Assets.getBitmapData("img/enemy_a.png"), frames:2, delay:20 });
		sprites.set(ENEMY_CHARGER, { data:Assets.getBitmapData("img/enemy_b.png"), frames:1, delay:0 });
		sprites.set(PLAYER_SHIP, { data:Assets.getBitmapData("img/player.png"), frames:2, delay:3 });
		sprites.set(PLAYER_BULLET, { data:Assets.getBitmapData("img/player_bullet.png"), frames:1, delay:0 });
		sprites.set(MINE, { data:Assets.getBitmapData("img/asteroid.png"), frames:1, delay:0 });
		
		sprites.set(PLAYER_BULLET_PART, { data:new BitmapData(3, 3, false, 0xFFECD078), frames:1, delay:0 } );
		sprites.set(ENEMY_A_PART, { data:Assets.getBitmapData("img/enemy_a_particles.png"), frames:4, delay:0 } );
		sprites.set(PLAYER_PART, { data:Assets.getBitmapData("img/player_particles.png"), frames:4, delay:0 } );
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

/*
 * PALETTE:
 * 
 * Purple:	542437
 * Red:		C02942
 * Orange:	D95B43
 * Yellow:	ECD078
 * Blue:	53777A
*/
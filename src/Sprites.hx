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
	static public var PLAYER_BULLET:String = "bullet";
	static public var MINE:String = "mine";
	static public var ENEMY_A_SHIP:String = "enemy_a_ship";
	static public var ENEMY_A_SHIP_HURT:String = "enemy_a_ship_hurt";
	static public var ENEMY_CHARGER:String = "enemy_charger";
	static public var ENEMY_CHARGER_B:String = "enemy_charger_b";
	static public var ENEMY_SNIPER:String = "enemy_sniper";
	static public var ENEMY_SNIPER_HURT:String = "enemy_sniper_hurt";
	static public var ENEMY_SNIPER_CORE:String = "enemy_sniper_core";
	static public var ENEMY_A_BULLET:String = "enemy_a_bullet";
	static public var POINTS:String = "points";
	static public var START:String = "start";
	static public var PAUSE:String = "pause";
	static public var GAME_OVER:String = "game_over";
	
	static public var YELLOW_PART:String = "yellow_part";
	static public var ORANGE_PART:String = "orange_part";
	static public var YELLOW_BULLET_PART:String = "yellow_bullet_part";
	static public var STAR_PART:String = "star_part";
	
	static var sprites:Map<String, SpriteSheet>;
	
	static public function init ()
	{
		sprites = new Map();
		// Store all assets and animation infos
		sprites.set(PLAYER_SHIP, { data:Assets.getBitmapData("img/player.png"), frames:2, delay:3 });
		sprites.set(PLAYER_BULLET, { data:Assets.getBitmapData("img/player_bullet.png"), frames:1, delay:0 });
		sprites.set(MINE, { data:Assets.getBitmapData("img/asteroid.png"), frames:2, delay:10 });
		sprites.set(ENEMY_A_SHIP, { data:Assets.getBitmapData("img/enemy_a.png"), frames:5, delay:15 });
		sprites.set(ENEMY_A_SHIP_HURT, { data:Assets.getBitmapData("img/enemy_a_hurt.png"), frames:5, delay:15 });
		sprites.set(ENEMY_CHARGER, { data:Assets.getBitmapData("img/enemy_b.png"), frames:1, delay:0 });
		sprites.set(ENEMY_CHARGER_B, { data:Assets.getBitmapData("img/enemy_c.png"), frames:1, delay:0 });
		sprites.set(ENEMY_SNIPER, { data:Assets.getBitmapData("img/enemy_sniper.png"), frames:3, delay:25 });
		sprites.set(ENEMY_SNIPER_HURT, { data:Assets.getBitmapData("img/enemy_sniper_hurt.png"), frames:3, delay:20 });
		sprites.set(ENEMY_SNIPER_CORE, { data:Assets.getBitmapData("img/enemy_sniper_core.png"), frames:2, delay:20 });
		sprites.set(ENEMY_A_BULLET, { data:Assets.getBitmapData("img/enemy_a_bullet.png"), frames:1, delay:0 });
		sprites.set(POINTS, { data:Assets.getBitmapData("img/points.png"), frames:4, delay:8 });
		sprites.set(START, { data:Assets.getBitmapData("img/start.png"), frames:2, delay:4 });
		sprites.set(PAUSE, { data:Assets.getBitmapData("img/paused.png"), frames:1, delay:0 });
		sprites.set(GAME_OVER, { data:Assets.getBitmapData("img/gameover.png"), frames:1, delay:0 });
		// Same for particles
		sprites.set(YELLOW_PART, { data:Assets.getBitmapData("img/player_particles.png"), frames:4, delay:0 } );
		sprites.set(ORANGE_PART, { data:Assets.getBitmapData("img/enemy_a_particles.png"), frames:4, delay:0 } );
		sprites.set(YELLOW_BULLET_PART, { data:new BitmapData(3, 3, false, 0xFFECD078), frames:1, delay:0 } );
		sprites.set(STAR_PART, { data:Assets.getBitmapData("img/star.png"), frames:2, delay:50 } );
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
 * Stars:	78334F
*/
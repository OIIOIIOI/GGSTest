package;
import openfl.Assets;
import openfl.media.SoundTransform;

/**
 * ...
 * @author 01101101
 */
class SoundMan {
	
	static public var PLAYER_SHOT:String = "snd/shoot";
	static public var PLAYER_DEATH:String = "snd/playerdeath";
	static public var ENEMY_DEATH:String = "snd/enemydeath";
	static public var INDESTRUCTIBLE:String = "snd/indestructible";
	static public var HURT:String = "snd/hurt";
	static public var TURRET_SHOT:String = "snd/turretshoot";
	static public var POINTS:String = "snd/points";
	static public var START:String = "snd/start";
	
	static var ext:String = ".mp3";
	
	static public function playOnce (s:String, vol:Float = 1)
	{
		// Choose variant if needed
		if (s == POINTS)	s = s + "" + Std.random(3);
		// Get sound
		var snd = Assets.getSound(s + ext);
		if (snd == null)
			return;
		// Turn down the volume if game is over
		if (Game.INST.isGameOver)
			vol *= 0.25;
		// Play sound
		if (vol == 1)
			snd.play();
		else {
			var st = new SoundTransform(vol);
			snd.play(0, 0, st);
		}
	}
	
}
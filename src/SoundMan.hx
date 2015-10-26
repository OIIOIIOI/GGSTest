package;
import openfl.Assets;

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
	
	#if html5
	static var ext:String = ".ogg";
	#else
	static var ext:String = ".mp3";
	#end
	
	static public function playOnce (s:String)
	{
		var snd = Assets.getSound(s + ext);
		if (snd == null)
			return;
		snd.play();
	}
	
}
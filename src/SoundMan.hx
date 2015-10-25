package;
import openfl.Assets;

/**
 * ...
 * @author 01101101
 */
class SoundMan {
	
	static public var PLAYER_SHOT:String = "snd/shoot.mp3";
	static public var ENEMY_DEATH:String = "snd/enemydeath.mp3";
	static public var INDESTRUCTIBLE:String = "snd/indestructible.mp3";
	
	static public function playOnce (s:String)
	{
		var snd = Assets.getSound(s);
		if (snd == null)
			return;
		snd.play();
	}
	
}
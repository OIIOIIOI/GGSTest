package;

import openfl.Assets;
import openfl.display.Sprite;
import openfl.text.AntiAliasType;
import openfl.text.Font;
import openfl.text.GridFitType;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

/**
 * ...
 * @author 01101101
 */
class UI {
	
	static var font:Font;
	static var formatLeft:TextFormat;
	static var formatRight:TextFormat;
	
	static var scoreTitleTF:TextField;
	static var scoreTF:TextField;
	static var waveTF:TextField;
	static var comboTF:TextField;
	
	static public var container:Sprite;
	
	static public function init ()
	{
		container = new Sprite();
		
		font = Assets.getFont("fnt/upheavtt.ttf");
		formatLeft = new TextFormat(font.fontName, 30, 0x53777A);
		formatLeft.align = TextFormatAlign.LEFT;
		formatRight = new TextFormat(font.fontName, 30, 0x53777A);
		formatRight.align = TextFormatAlign.RIGHT;
		
		scoreTitleTF = setupTF(new TextField(), formatRight);
		scoreTitleTF.text = "SCORE";
		scoreTitleTF.x = Game.WIDTH - scoreTitleTF.width - 5;
		scoreTitleTF.y = Game.HEIGHT - 53;
		
		scoreTF = setupTF(new TextField(), formatRight);
		scoreTF.text = "000000";
		scoreTF.x = scoreTitleTF.x;
		scoreTF.y = scoreTitleTF.y + 20;
		
		waveTF = setupTF(new TextField(), formatLeft);
		waveTF.text = "WAVE 1";
		waveTF.x = 5;
		waveTF.y = scoreTitleTF.y;
		
		comboTF = setupTF(new TextField(), formatLeft);
		comboTF.text = "NO CHAIN";
		comboTF.x = waveTF.x;
		comboTF.y = scoreTF.y;
		
		container.addChild(scoreTitleTF);
		container.addChild(scoreTF);
		container.addChild(waveTF);
		container.addChild(comboTF);
	}
	
	static function setupTF (tf:TextField, f:TextFormat) :TextField
	{
		tf.width = Game.WIDTH;
		tf.selectable = false;
		tf.mouseEnabled = false;
		tf.antiAliasType = AntiAliasType.ADVANCED;
		tf.gridFitType = GridFitType.PIXEL;
		tf.embedFonts = true;
		tf.defaultTextFormat = f;
		return tf;
	}
	
	static public function refresh ()
	{
		scoreTF.text = addZeros(Game.INST.score);
		if (Game.INST.chain == 0)
			comboTF.text = "NO CHAIN";
		else
			comboTF.text = Game.INST.chain + " CHAIN";
	}
	
	static function addZeros (s:Int) :String
	{
		var string = Std.string(s);
		while (string.length < 6) {
			string = "0" + string;
		}
		return string;
	}
	
}
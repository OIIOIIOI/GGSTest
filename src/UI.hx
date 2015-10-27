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
	static var formatCenter:TextFormat;
	
	static var scoreTitleTF:TextField;
	static var scoreTF:TextField;
	static var waveTF:TextField;
	static var comboTF:TextField;
	
	static var bestTitleTF:TextField;
	static var bestTF:TextField;
	
	static public var container:Sprite;
	
	static public function init ()
	{
		container = new Sprite();
		
		font = Assets.getFont("fnt/upheavtt.ttf");
		formatLeft = new TextFormat(font.fontName, 26, 0x53777A);
		formatLeft.align = TextFormatAlign.LEFT;
		formatRight = new TextFormat(font.fontName, 26, 0x53777A);
		formatRight.align = TextFormatAlign.RIGHT;
		formatCenter = new TextFormat(font.fontName, 26, 0x53777A);
		formatCenter.align = TextFormatAlign.CENTER;
		
		bestTitleTF = setupTF(new TextField(), formatCenter);
		bestTitleTF.text = "BEST SCORE";
		bestTitleTF.x = Std.int((Game.WIDTH - bestTitleTF.width) / 2);
		bestTitleTF.y = 0;
		
		bestTF = setupTF(new TextField(), formatCenter);
		bestTF.text = "";
		bestTF.x = bestTitleTF.x;
		bestTF.y = bestTitleTF.y + 16;
		
		scoreTitleTF = setupTF(new TextField(), formatRight);
		scoreTitleTF.text = "SPACE";
		scoreTitleTF.x = Game.WIDTH - scoreTitleTF.width - 5;
		scoreTitleTF.y = Game.HEIGHT - 45;
		
		scoreTF = setupTF(new TextField(), formatRight);
		scoreTF.text = "TO SHOOT";
		scoreTF.x = scoreTitleTF.x;
		scoreTF.y = scoreTitleTF.y + 16;
		
		waveTF = setupTF(new TextField(), formatLeft);
		waveTF.text = "ARROWS";
		waveTF.x = 5;
		waveTF.y = scoreTitleTF.y;
		
		comboTF = setupTF(new TextField(), formatLeft);
		comboTF.text = "TO MOVE";
		comboTF.x = waveTF.x;
		comboTF.y = scoreTF.y;
		
		container.addChild(bestTitleTF);
		container.addChild(bestTF);
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
		if (WaveMan.waveIndex == 0)
		{
			scoreTitleTF.text = "SPACE";
			scoreTF.text = "TO SHOOT";
			waveTF.text = "ARROWS";
			comboTF.text = "TO MOVE";
			bestTF.text = addZeros(Game.INST.bestScore);
			
			if (!container.contains(bestTitleTF))
				container.addChild(bestTitleTF);
			if (!container.contains(bestTF))
				container.addChild(bestTF);
		}
		else
		{
			scoreTitleTF.text = "SCORE";
			scoreTF.text = addZeros(Game.INST.score);
			waveTF.text = "WAVE " + WaveMan.waveIndex;
			if (Game.INST.chain == 0)
				comboTF.text = "NO CHAIN";
			else
				comboTF.text = Game.INST.chain + "-CHAIN";
			
			if (container.contains(bestTitleTF))
				container.removeChild(bestTitleTF);
			if (container.contains(bestTF))
				container.removeChild(bestTF);
		}
	}
	
	static function addZeros (s:Int) :String
	{
		var string = Std.string(s);
		while (string.length < 8) {
			string = "0" + string;
		}
		return string;
	}
	
}
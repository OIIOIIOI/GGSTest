package;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.errors.Error;
import openfl.events.Event;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.Lib;
import openfl.ui.Keyboard;

/**
 * ...
 * @author 01101101
 */
class Game extends Sprite
{
	
	static public var TAR:Rectangle = new Rectangle();// Throwaway Rectangle
	static public var TAP:Point = new Point();// Throwaway Point
	// I like to have these instead of creating a new Rectangle or Point each time I need one temporarily
	
	static public var WIDTH:Int = Lib.current.stage.stageWidth;
	static public var HEIGHT:Int = Lib.current.stage.stageHeight;
	
	static public var INST:Game;
	
	var shakeOffset:Int = 10;
	var shakeAmount:Int = 3;
	var shakeTick:Int;
	
	var canvas:Bitmap;
	var canvasData:BitmapData;
	
	var entities:Array<Entity>;
	var player:Player;
	
	public function new ()
	{
		if (INST != null)
			throw new Error("Game already instanciated!");
		else
			INST = this;
		
		super();
		
		canvasData = new BitmapData(WIDTH + 2 * shakeOffset, HEIGHT + 2 * shakeOffset, false, 0xFF001942);
		canvas = new Bitmap(canvasData);
		canvas.x = canvas.y = -shakeOffset;
		addChild(canvas);
		
		entities = new Array();
		
		player = new Player();
		entities.push(player);
		
		addEventListener(Event.ENTER_FRAME, update);
	}
	
	function update (e:Event)
	{
		// Update
		for (e in entities) {
			e.update();
		}
		// Render
		render();
		
		// Screenshake
		if (shakeTick > 0) {
			canvas.x = -shakeOffset + shakeAmount * Std.random(2) * 2 - 1;
			canvas.y = -shakeOffset + shakeAmount * Std.random(2) * 2 - 1;
			shakeTick--;
		}
		else if (shakeTick == 0) {
			canvas.x = canvas.y = -shakeOffset;
			shakeTick--;
		}
	}
	
	function render ()
	{
		canvasData.fillRect(canvasData.rect, 0xFF001942);
		
		for (e in entities) {
			Sprites.draw(canvasData, e.spriteID, e.x, e.y, e.frame);
		}
	}
	
	public function spawnBullet ()
	{
		var b = new Bullet();
		b.x = player.x + 43;
		b.y = player.y - 37;
		entities.push(b);
		entities.remove(player);
		entities.push(player);
	}
	
}
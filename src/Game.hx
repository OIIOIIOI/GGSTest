package;

import Entity;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.errors.Error;
import openfl.events.Event;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.Lib;
import openfl.ui.Keyboard;
import Particle;

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
	
	public var tick:Int = 0;
	
	public var paused:Bool = false;
	var canPress:Bool = true;
	var pauseEntity:Pause;
	
	public var shakeOffset:Int = 10;
	var shakeAmount:Int = 3;
	var shakeTick:Int = 0;
	
	public var flashTick:Int = 0;
	
	var canvas:Bitmap;
	var canvasData:BitmapData;
	var uiMatrix:Matrix;
	
	var entities:Array<Entity>;
	var particles:Array<Particle>;
	
	public var player:Player;
	
	public var score:Int;
	public var chain:Int;
	
	public function new ()
	{
		if (INST != null)
			throw new Error("Game already instanciated!");
		else
			INST = this;
		
		super();
		
		canvasData = new BitmapData(WIDTH + 2 * shakeOffset, HEIGHT + 2 * shakeOffset, false);
		canvas = new Bitmap(canvasData);
		canvas.x = canvas.y = -shakeOffset;
		addChild(canvas);
		
		uiMatrix = new Matrix();
		uiMatrix.translate(shakeOffset, shakeOffset);
		
		entities = [];
		particles = [];
		
		player = new Player();
		player.x = WIDTH / 2 + canvas.x;
		player.y = HEIGHT - canvas.y - 70;
		entities.push(player);
		
		score = chain = 0;
		WaveMan.spawnWave(0);
		
		addEventListener(Event.ENTER_FRAME, update);
	}
	
	function update (e:Event)
	{
		var pauseTick = 0;
		if (!canPress && !Controls.isDown(Keyboard.ESCAPE)) {
			canPress = true;
		}
		
		if (canPress && !paused && Controls.isDown(Keyboard.ESCAPE)) {
			paused = true;
			canPress = false;
			pauseTick = tick;
			if (pauseEntity == null) {
				pauseEntity = new Pause();
				pauseEntity.x = Game.WIDTH / 2 - pauseEntity.cx + Game.INST.shakeOffset;
				pauseEntity.y = Game.HEIGHT / 2 - pauseEntity.cy + Game.INST.shakeOffset;
			}
			entities.push(pauseEntity);
		}
		else if (canPress && paused && Controls.isDown(Keyboard.ESCAPE)) {
			paused = false;
			canPress = false;
			entities.remove(pauseEntity);
		}
		
		if (paused && pauseTick != tick)	return;
		
		tick++;
		
		// Update entities
		for (e in entities) {
			e.update();
		}
		// Collision checks
		checkCollisions();
		// Clean up dead entities
		entities = entities.filter(filterDead);
		
		// Update wave
		WaveMan.update();
		
		// Update particles
		for (p in particles) {
			p.update();
		}
		// Clean up dead particles
		particles = particles.filter(filterDead);
		
		// Render
		render();
		
		// Screen shake
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
	
	public function filterDead (e:Entity) :Bool
	{
		return !e.isDead;
	}
	
	function checkCollisions ()
	{
		for (i in 0...entities.length)
		{
			var ea = entities[i];
			// Skip entity if dead
			if (ea.isDead || ea.isOffScreen())
				continue;
			
			for (j in i + 1...entities.length) 
			{
				var eb = entities[j];
				// Skip entity if dead
				if (eb.isDead || eb.isOffScreen())
					continue;
				// Skip check if entities are not supposed to collide
				if (ea.collList.indexOf(eb.collType) == -1)
					continue;
				// Resolve collision if entities are effectively colliding
				if (getDistance(ea, eb) < ea.collRadius + eb.collRadius)
					resolveCollision(ea, eb);
			}
		}
	}
	
	public function getDistance (ea:Entity, eb:Entity) :Float
	{
		var dx = (eb.x + eb.cx) - (ea.x + ea.cx);
		var dy = (eb.y + eb.cy) - (ea.y + ea.cy);
		return Math.sqrt(dx * dx + dy * dy);
	}
	
	function resolveCollision (ea:Entity, eb:Entity)
	{
		if (!ea.isIndestructible)
			ea.hurt(eb.collType);
		else if (eb.collType == CollType.PLAYER_BULLET)
			SoundMan.playOnce(SoundMan.INDESTRUCTIBLE);
		
		if (!eb.isIndestructible)
			eb.hurt(ea.collType);
		else if (ea.collType == CollType.PLAYER_BULLET)
			SoundMan.playOnce(SoundMan.INDESTRUCTIBLE);
	}
	
	function render ()
	{
		if (flashTick > 0)
		{
			canvasData.fillRect(canvasData.rect, 0xFFFFFF);
			flashTick--;
		}
		else
		{
			canvasData.fillRect(canvasData.rect, 0xFF542437);
			// Render entities
			for (e in entities) {
				Sprites.draw(canvasData, e.spriteID, e.x, e.y, e.frame);
			}
			// Render particles
			for (p in particles) {
				Sprites.draw(canvasData, p.spriteID, p.x, p.y, p.frame);
			}
		}
		canvasData.draw(UI.container, uiMatrix);
	}
	
	public function shake (amount:Int, duration:Int)
	{
		// Apply screen shake if none is taking place currently or if new one is at least as strong
		if (shakeTick == -1 || amount >= shakeAmount) {
			shakeAmount = amount;
			shakeTick = duration;
		}
	}
	
	public function addEntity (e:Entity, playerOnTop:Bool = true)
	{
		entities.push(e);
		
		if (playerOnTop) {
			entities.remove(player);
			entities.push(player);
		}
	}
	
	public function spawnParticles (t:ParticleType, px:Float, py:Float, amount:Int)
	{
		switch (t)
		{
			case ParticleType.YELLOW_BULLET:
				for (i in 0...amount)
				{
					var p = new Particle(t);
					p.x = px;
					p.y = py;
					particles.push(p);
				}
			case ParticleType.ORANGE, ParticleType.YELLOW:
				for (i in 0...amount)
				{
					var p = new Particle(t);
					p.x = px + (Std.random(2) * 2 - 1) * (Std.random(8) + 4);
					p.y = py + (Std.random(2) * 2 - 1) * (Std.random(8) + 4);
					particles.push(p);
				}
		}
	}
	
	public function addScore (s:Int)
	{
		score += s * chain;
		UI.refresh();
	}
	
}
package;

import Entity;
import haxe.Timer;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.errors.Error;
import openfl.events.Event;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.Lib;
import openfl.net.SharedObject;
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
	
	public var isPaused:Bool = false;
	var pauseEntity:Pause;
	var canPressEscape:Bool = true;
	
	public var isGameOver:Bool = false;
	var gameOverEntity:GameOver;
	var canPressSpace:Bool = true;
	
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
	public var speedMod:Float = 1;
	
	var so:SharedObject;
	public var bestScore:Int;
	
	public function new ()
	{
		if (INST != null)
			throw new Error("Game already instanciated!");
		else
			INST = this;
		
		super();
		
		so = SharedObject.getLocal("bestScore");
		if (so.data.score == null)
			so.data.score = 0;
		bestScore = so.data.score;
		
		canvasData = new BitmapData(WIDTH + 2 * shakeOffset, HEIGHT + 2 * shakeOffset, false);
		canvas = new Bitmap(canvasData);
		canvas.x = canvas.y = -shakeOffset;
		addChild(canvas);
		
		uiMatrix = new Matrix();
		uiMatrix.translate(shakeOffset, shakeOffset);
		
		entities = [];
		particles = [];
		
		reset();
		
		addEventListener(Event.ENTER_FRAME, update);
	}
	
	function update (e:Event)
	{
		var pauseTick = 0;
		if (!canPressEscape && !Controls.isDown(Keyboard.ESCAPE)) {
			canPressEscape = true;
		}
		/*if (!canPressSpace && !Controls.isDown(Keyboard.SPACE)) {
			canPressSpace = true;
		}*/
		
		if (canPressEscape && !isPaused && Controls.isDown(Keyboard.ESCAPE) && WaveMan.waveIndex != 0 && !isGameOver) {
			isPaused = true;
			canPressEscape = false;
			pauseTick = tick;
			if (pauseEntity == null) {
				pauseEntity = new Pause();
				pauseEntity.x = Game.WIDTH / 2 - pauseEntity.cx + Game.INST.shakeOffset;
				pauseEntity.y = Game.HEIGHT / 2 - pauseEntity.cy + Game.INST.shakeOffset;
			}
			pauseEntity.isDead = false;
			addEntity(pauseEntity, false);
		}
		else if (canPressEscape && isPaused && Controls.isDown(Keyboard.ESCAPE)) {
			isPaused = false;
			canPressEscape = false;
			entities.remove(pauseEntity);
		}
		
		if (isPaused && pauseTick != tick)
			return;
		
		if (canPressSpace && isGameOver && Controls.isDown(Keyboard.SPACE)) {
			Game.INST.flashTick = 3;
			SoundMan.playOnce(SoundMan.START);
			reset();
		}
		
		tick++;
		
		// Star particles
		if (tick % 10 == 0)
		{
			var p = new Particle(ParticleType.STAR);
			p.x = Std.random(Game.WIDTH) + shakeOffset;
			particles.push(p);
		}
		
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
			// Render particles
			for (p in particles) {
				Sprites.draw(canvasData, p.spriteID, p.x, p.y, p.frame);
			}
			// Render entities
			for (e in entities) {
				Sprites.draw(canvasData, e.spriteID, e.x, e.y, e.frame);
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
		if (entities.remove(pauseEntity))
			entities.push(pauseEntity);
		if (entities.remove(gameOverEntity))
			entities.push(gameOverEntity);
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
			default:
		}
	}
	
	public function addScore (s:Int)
	{
		if (s > 0)
			score += s * chain;
		else if (score > 0)
			score += s;
		UI.refresh();
	}
	
	public function gameOver ()
	{
		isGameOver = true;
		canPressSpace = false;
		
		if (gameOverEntity == null)
		{
			gameOverEntity = new GameOver();
			gameOverEntity.x = Game.WIDTH / 2 - gameOverEntity.cx + Game.INST.shakeOffset;
			gameOverEntity.y = Game.HEIGHT / 2 - gameOverEntity.cy + Game.INST.shakeOffset;
		}
		gameOverEntity.isDead = false;
		addEntity(gameOverEntity);
		
		if (score > bestScore)
		{
			so.data.score = bestScore = score;
			so.flush();
		}
		
		Timer.delay(allowReset, 2500);
	}
	
	function allowReset () {
		canPressSpace = true;
	}
	
	function reset ()
	{
		for (e in entities) {
			e.isDead = true;
		}
		for (p in particles) {
			p.isDead = true;
		}
		entities = [];
		particles = [];
		
		for (i in 0...30) {
			var p = new Particle(ParticleType.STAR);
			p.x = Std.random(Game.WIDTH) + shakeOffset;
			p.y = Std.random(Game.HEIGHT) + shakeOffset;
			particles.push(p);
		}
		
		player = new Player();
		player.x = WIDTH / 2 + canvas.x;
		player.y = HEIGHT - canvas.y - 70;
		addEntity(player);
		
		score = chain = 0;
		speedMod = 1;
		WaveMan.spawnWave(0);
		
		isGameOver = false;
	}
	
}
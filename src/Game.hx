package;

import Entity;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.errors.Error;
import openfl.events.Event;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.Lib;
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
	
	var shakeOffset:Int = 10;
	var shakeAmount:Int = 3;
	var shakeTick:Int;
	
	var canvas:Bitmap;
	var canvasData:BitmapData;
	
	var entities:Array<Entity>;
	var particles:Array<Particle>;
	
	var player:Player;
	
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
		
		entities = [];
		particles = [];
		
		for (i in 0...5) {
			var e = new Enemy();
			e.x = Std.random(WIDTH - 48);
			e.y = Std.random(Std.int(HEIGHT / 2));
			entities.push(e);
		}
		
		player = new Player();
		player.x = WIDTH / 2 + canvas.x;
		player.y = HEIGHT - canvas.y - 70;
		entities.push(player);
		
		addEventListener(Event.ENTER_FRAME, update);
	}
	
	function update (e:Event)
	{
		// Update
		for (e in entities) {
			e.update();
		}
		// Collision checks
		checkCollisions();
		// Clean up dead entities
		entities = entities.filter(filterDead);
		
		// Update
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
	
	function filterDead (e:Entity) :Bool
	{
		var b = e.isDead;
		if (b)	e = null;
		return !b;
	}
	
	function checkCollisions ()
	{
		for (i in 0...entities.length)
		{
			var ea = entities[i];
			// Skip entity if dead
			if (ea.isDead)	continue;
			
			for (j in i + 1...entities.length) 
			{
				var eb = entities[j];
				// Skip entity if dead
				if (eb.isDead)	continue;
				// Skip check if entities are not supposed to collide
				if (ea.collList.indexOf(eb.collType) == -1)	continue;
				// Resolve collision if entities are effectively colliding
				if (getDistance(ea, eb) < ea.collRadius + eb.collRadius)
					resolveCollision(ea, eb);
			}
		}
	}
	
	function getDistance (ea:Entity, eb:Entity) :Float
	{
		var dx = (eb.x + eb.cx) - (ea.x + ea.cx);
		var dy = (eb.y + eb.cy) - (ea.y + ea.cy);
		return Math.sqrt(dx * dx + dy * dy);
	}
	
	function resolveCollision (ea:Entity, eb:Entity)
	{
		ea.isDead = true;
		eb.isDead = true;
		if (ea.collType == CollType.ENEMY || eb.collType == CollType.ENEMY) {
			shake(3, 6);
			SoundMan.playOnce(SoundMan.ENEMY_DEATH);
		}
		
		if (ea.collType == CollType.PLAYER_BULLET)
			spawnParticles(ParticleType.BULLET, ea.x, ea.y);
		
		if (eb.collType == CollType.PLAYER_BULLET)
			spawnParticles(ParticleType.BULLET, eb.x, eb.y);
	}
	
	function render ()
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
	
	public function shake (amount:Int, duration:Int)
	{
		// Apply screen shake if none is taking place currently or if new one is at least as strong
		if (shakeTick == -1 || amount >= shakeAmount) {
			shakeAmount = amount;
			shakeTick = duration;
		}
	}
	
	public function spawnBullet ()
	{
		var b = new Bullet();
		b.x = player.x + 18;
		b.y = player.y - 16;
		entities.push(b);
		entities.remove(player);
		entities.push(player);
		
		shake(1, 3);
		
		SoundMan.playOnce(SoundMan.PLAYER_SHOT);
	}
	
	public function spawnParticles (t:ParticleType, px:Float, py:Float)
	{
		switch (t)
		{
			case ParticleType.BULLET:
				for (i in 0...15)
				{
					var p = new Particle(t);
					p.x = px;
					p.y = py;
					particles.push(p);
				}
		}
	}
	
}
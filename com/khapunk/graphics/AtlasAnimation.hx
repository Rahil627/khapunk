package com.khapunk.graphics;
import com.khapunk.graphics.atlas.AtlasRegion;
import com.khapunk.graphics.Atlasmap;

/**
 * ...
 * @author Sidar Talei
 */
class AtlasAnimation implements IAnimation<AtlasRegion,Atlasmap>
{

	/**
	 * Constructor.
	 * @param	name		Animation name.
	 * @param	frames		Array of frame indices to animate.
	 * @param	frameRate	Animation speed.
	 * @param	loop		If the animation should loop.
	 */
	public function new(name:String, frames:Array<AtlasRegion>, frameRate:Float = 0, loop:Bool = true,parent:Atlasmap = null)
	{
        this.name       = name;
        this.frames     = frames;
        this.frameRate  = frameRate;
        this.loop       = loop;
        this.frameCount = frames.length;
		_parent = parent;
	}
	/**
	 * Plays the animation.
	 * @param	reset		If the animation should force-restart if it is already playing.
	 */
	public function play(reset:Bool = false, reverse:Bool = false)
	{
		if(name == null)
			_parent.playAnimation(this, reset, reverse);
		else
			_parent.play(name, reset, reverse);
	}

	public var parent(null, set):Atlasmap;
	private function set_parent(value:Atlasmap):Atlasmap {
		_parent = value;
		return _parent;
	}
	
	/**
	 * Name of the animation.
	 */
	public var name(default, null):String;

	/**
	 * Array of frame indices to animate.
	 */
	public var frames(default, null):Array<AtlasRegion>;

	/**
	 * Animation speed.
	 */
	public var frameRate(default, null):Float;

	/**
	 * Amount of frames in the animation.
	 */
	public var frameCount(default, null):Int;

	/**
	 * If the animation loops.
	 */
	public var loop(default, null):Bool;

	private var _parent:Atlasmap;
}
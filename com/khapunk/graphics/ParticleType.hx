package com.khapunk.graphics;

import com.khapunk.KP;
import com.khapunk.utils.Ease;
import com.khapunk.graphics.Rectangle;

/**
 * Template used to define a particle type used by the Emitter class. Instead
 * of creating this object yourself, fetch one with Emitter's add() function.
 */
@:allow(com.khapunk.graphics.Emitter)
class ParticleType
{
	/**
	 * Constructor.
	 * @param	name			Name of the particle type.
	 * @param	frames			Array of frame indices to animate through.
	 * @param	width			Unused parameter.
	 * @param	frameWidth		Frame width.
	 * @param	frameHeight		Frame height.
	 */
	public function new(name:String, frames:Array<Int>)
	{
		_red = _green = _blue = _alpha = 1;
		_redRange = _greenRange = _blueRange = _alphaRange = 0;

		_name = name;
		if (frames == null) frames = new Array<Int>();
		_frames = frames;

        _angle    = _angleRange    = 0;
        _gravity  = _gravityRange  = 0;
        _duration = _durationRange = 0;
        _distance = _distanceRange = 0;
		_scale = 1;
		_scaleRange = 0;
		_rotation = 0;
		_rotationRange = 0;
	}

	/**
	 * Defines the motion range for this particle type.
	 * @param	angle			Launch Direction.
	 * @param	distance		Distance to travel.
	 * @param	duration		Particle duration.
	 * @param	angleRange		Random amount to add to the particle's direction.
	 * @param	distanceRange	Random amount to add to the particle's distance.
	 * @param	durationRange	Random amount to add to the particle's duration.
	 * @param	ease			Optional ease function.
	 * @param	backwards		If the motion should be played backwards.
	 * @return	This ParticleType object.
	 */
	public function setMotion(angle:Float, distance:Float, duration:Float, angleRange:Float = 0, distanceRange:Float = 0, durationRange:Float = 0, ease:EaseFunction = null, backwards:Bool = false):ParticleType
	{
		_angle = angle * KP.RAD;
		_distance = distance;
		_duration = duration;
		_angleRange = angleRange * KP.RAD;
		_distanceRange = distanceRange;
		_durationRange = durationRange;
		_ease = ease;
		_backwards = backwards;
		return this;
	}
	
	/**
	 * Defines the motion range for this particle type based on the vector.
	 * @param	x				X distance to move.
	 * @param	y				Y distance to move.
	 * @param	duration		Particle duration.
	 * @param	durationRange	Random amount to add to the particle's duration.
	 * @param	ease			Optional easer function.
	 * @return	This ParticleType object.
	 */
	public function setMotionVector(x:Float, y:Float, duration:Float, durationRange:Float = 0, ease:EaseFunction = null):ParticleType
	{
		_angle = Math.atan2(y, x);
		_angleRange = 0;
		_distance = Math.sqrt(x * x + y * y);
		_distanceRange = 0;
		_duration = duration;
		_durationRange = durationRange;
		_ease = ease;
		return this;
	}

	/**
	* Sets the gravity range of this particle type.
	* @param	gravity			Gravity amount to affect to the particle y velocity.
	* @param	gravityRange	Random amount to add to the particle's gravity.
	* @return	This ParticleType object.
	*/
	public function setGravity(gravity:Float = 0, gravityRange:Float = 0):ParticleType
	{
		_gravity = gravity;
		_gravityRange = gravityRange;
		return this;
	}

	/**
	 * Sets the alpha range of this particle type.
	 * @param	start		The starting alpha.
	 * @param	finish		The finish alpha.
	 * @param	ease		Optional easer function.
	 * @return	This ParticleType object.
	 */
	public function setAlpha(start:Float = 1, finish:Float = 0, ease:EaseFunction = null):ParticleType
	{
		start = start < 0 ? 0 : (start > 1 ? 1 : start);
		finish = finish < 0 ? 0 : (finish > 1 ? 1 : finish);
		_alpha = start;
		_alphaRange = finish - start;
		_alphaEase = ease;
		//createBuffer();
		return this;
	}

	
	/**
	 * Sets the alpha range of this particle type.
	 * @param	start		The starting alpha.
	 * @param	finish		The finish alpha.
	 * @param	ease		Optional easer function.
	 * @return	This ParticleType object.
	 */
	public function setScale(start:Float = 1, finish:Float = 0, ease:EaseFunction = null):ParticleType
	{
		//start = start < 0 ? 0 : (start > 1 ? 1 : start);
		//finish = finish < 0 ? 0 : (finish > 1 ? 1 : finish);
		_scale = start;
		_scaleRange = finish - start;
		_scaleEase = ease;
		//createBuffer();
		return this;
	}
	
		
	/**
	 * Sets the alpha range of this particle type.
	 * @param	start		The starting alpha.
	 * @param	finish		The finish alpha.
	 * @param	ease		Optional easer function.
	 * @return	This ParticleType object.
	 */
	public function setRotation(start:Float = 0, finish:Float = 360, ease:EaseFunction = null):ParticleType
	{
		_rotation = start * KP.RAD;
		_rotationRange = finish * KP.RAD - start;
		_rotationEase = ease;
		return this;
	}
	
	/**
	 * Sets the color range of this particle type.
	 * @param	start		The starting color.
	 * @param	finish		The finish color.
	 * @param	ease		Optional easer function.
	 * @return	This ParticleType object.
	 */
	public function setColor(start:Int = 0xFFFFFF, finish:Int = 0, ease:EaseFunction = null):ParticleType
	{
		start &= 0xFFFFFF;
		finish &= 0xFFFFFF;
		_red = (start >> 16 & 0xFF) / 255;
		_green = (start >> 8 & 0xFF) / 255;
		_blue = (start & 0xFF) / 255;
		_redRange = (finish >> 16 & 0xFF) / 255 - _red;
		_greenRange = (finish >> 8 & 0xFF) / 255 - _green;
		_blueRange = (finish & 0xFF) / 255 - _blue;
		_colorEase = ease;
		//createBuffer();
		return this;
	}
	
		/**
	 * 
	 * @param	shouldLoop		Whether it should loop or not. 
	 * 							If set to false the animation is distributed over lifetime.
	 * @param	speed		How fast it should animate.
	 * @param	speedRange		Random speed to add to speed.
	 * @return	This ParticleType object.
	 */
	public function setAnimLoop(shouldLoop:Bool, speed:Float, speedRange:Float):ParticleType
	{
		_loopAnim = shouldLoop;
		_loopSpeed = speed;
		_loopSpeedRange = speedRange;
		return this;
	}

	/** @private Creates the buffer if it doesn't exist. */
	/*private function createBuffer()
	{
		if (_buffer != null) return;
		_buffer = KP.createBitmap(Std.int(_frame.width), Std.int(_frame.height), true);
		_bufferRect = _buffer.rect;
	}*/

	// Particle information.
	private var _name:String;
	private var _frames:Array<Int>;

	// Motion information.
	private var _angle:Float;
	private var _angleRange:Float;
	private var _distance:Float;
	private var _distanceRange:Float;
	private var _duration:Float;
	private var _durationRange:Float;
	private var _ease:EaseFunction;
	private var _backwards:Bool;
	
	// Scale information
	private var _scale:Float;
	private var _scaleRange:Float;
	private var _scaleEase:EaseFunction;
	
	// Rotation information
	private var _rotation:Float;
	private var _rotationRange:Float;
	private var _rotationEase:EaseFunction;
	
	// Gravity information.
	private var _gravity:Float;
	private var _gravityRange:Float;

	// Alpha information.
	private var _alpha:Float;
	private var _alphaRange:Float;
	private var _alphaEase:EaseFunction;

	// Color information.
	private var _red:Float;
	private var _redRange:Float;
	private var _green:Float;
	private var _greenRange:Float;
	private var _blue:Float;
	private var _blueRange:Float;
	private var _colorEase:EaseFunction;
	
	private var _loopAnim:Bool = false;
	private var _loopSpeed:Float;
	private var _loopSpeedRange:Float;
	// Buffer information.
	//private var _buffer:BitmapData;
	//private var _bufferRect:Rectangle;
}

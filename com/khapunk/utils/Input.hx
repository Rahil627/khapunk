package com.khapunk.utils;
import com.khapunk.utils.Gamepad.GamepadState;
import com.khapunk.utils.Gesture;
import haxe.ds.Vector;
import kha.input.Gamepad;
import kha.input.Keyboard;
import kha.input.Mouse;
import kha.input.Sensor;
import kha.input.SensorType;
import kha.input.Surface;
import kha.input.KeyCode;
import kha.math.Vector2;
import kha.Scaler;
import kha.ScreenCanvas;
import kha.System;

/**
 * ...
 * @author ...
 */
class Input
{
	private static inline var kKeyStringMax = 100;
	
	private static var _enabled:Bool = false;
	private static var _key:Map<Int, Bool> = new Map<Int, Bool>();
	private static var _keyNum:Int = 0;
	private static var _press:Array<Int> = new Array<Int>();
	private static var _pressNum:Int = 0;
	private static var _release:Array<Int> = new Array<Int>();
	private static var _releaseNum:Int = 0;
	private static var _mouseWheelDelta:Int = 0;
	private static var _touches:Map<Int,Touch> = new Map<Int,Touch>();
	private static var _gamepads:Map<Int,com.khapunk.utils.Gamepad> = new Map<Int,com.khapunk.utils.Gamepad>();
	private static var _control:Map < String, Array<Int> > = new Map < String, Array<Int> > ();
	private static var _touchOrder:Array<Int> = new Array();
	
	/**
	 * Returns true if the device supports multi touch
	 */
	public static var multiTouchSupported(default, null):Bool = false;
	public static var accelerationSupported(default, null):Bool = false;
	public static var gyroscopeSupported(default, null):Bool = false;

	
	private static var _mouseX:Int = 0;
	private static var _mouseY:Int = 0;
	
	/**
	 * Contains the string of the last keys pressed
	 */
	public static var keyString:String = "";

	/**
	 * Holds the last key pressed
	 */
	public static var lastKey:Int;

	/**
	 * If any mouse button is held down
	 */
	public static var mouseDown:Bool;
	/**
	 * If all mouse buttons are up
	 */
	public static var mouseAllUp:Bool;
	/**
	 * If any mouse button was recently pressed
	 */
	public static var mousePressed:Bool;
	/**
	 * If any mouse button was recently released
	 */
	public static var mouseReleased:Bool;

	/**
	 * If left mouse button is down
	 */
	public static var leftMouseDown:Bool = false;
	/**
	 * If right mouse button is down
	 */
	public static var rightMouseDown:Bool = false;
	/**
	 * If middle mouse button is down
	 */
	public static var midMouseDown:Bool = false;
	
	/**
	 * If left mouse button was recently clicked
	 */
	public static var leftMouseClicked:Bool = false;
	
	/**
	 * If right mouse button was recently clicked
	 */
	public static var rightMouseClicked:Bool = false;
	
	/**
	 * If middle mouse button was recently clicked
	 */
	public static var midMouseClicked:Bool = false;
	
	/**
	 * If left mouse button was recently released
	 */
	public static var leftMouseReleased:Bool = false;
	
	/**
	 * If right mouse button was recently released
	 */
	public static var rightMouseReleased:Bool = false;
	
	/**
	 * If middle mouse button was recently released
	 */
	public static var midMouseReleased:Bool = false;
	
	/**
	 * Whether the mouse is moving 
	 */
	public static var mouseMoved:Bool = false;
	
	/**
	 * If the mouse wheel has moved
	 */
	public static var mouseWheel:Bool;
	
	public static var MouseDeltaX:Int;
	public static var MouseDeltaY:Int;
	
	/**
	 * If the mouse wheel was moved this frame, this was the delta.
	 */
	public static var mouseWheelDelta(get, never):Int;
	public static function get_mouseWheelDelta():Int
	{
		if (mouseWheel)
		{
			mouseWheel = false;
			return _mouseWheelDelta;
		}
		return 0;
	}

	/**
	 * X position of the mouse on the screen.
	 */
	public static var mouseX(get, never):Int;
	private static function get_mouseX():Int
	{
		//return Std.int(_mouseX / (Sys.pixelWidth / Game.the.width));//KP.screen.mouseX;
		return Scaler.transformX(_mouseX, _mouseY,Engine.backbuffer,ScreenCanvas.the,System.screenRotation);
	}

	/**
	 * Y position of the mouse on the screen.
	 */
	public static var mouseY(get, never):Int;
	private static function get_mouseY():Int
	{
		//return Std.int(_mouseY / (Sys.pixelHeight/Game.the.height));//KP.screen.mouseX;
		return Scaler.transformY(_mouseX, _mouseY,Engine.backbuffer,ScreenCanvas.the,System.screenRotation);
	}
	
	
	/**
	 * The absolute mouse x position on the screen (unscaled).
	 */
	public static var screenMouseX(get, never):Int;
	private static function get_screenMouseX():Int
	{
		return _mouseX;//Std.int(KP.stage.mouseX);
	}

	/**
	 * The absolute mouse y position on the screen (unscaled).
	 */
	public static var screenMouseY(get, never):Int;
	private static function get_screenMouseY():Int
	{
		return  _mouseY;// Std.int(KP.stage.mouseY);
	}
	
	public static var accX(default, null):Float = 0;
	public static var accY(default, null):Float = 0;
	public static var accZ(default, null):Float = 0;
	
	public static var gyroX(default, null):Float;
	public static var gyroY(default, null):Float;
	public static var gyroZ(default, null):Float;
	
	
	
	
		/**
	 * Defines a new input.
	 * @param	name		String to map the input to.
	 * @param	keys		The keys to use for the Input.
	 */
	public static function define(name:String, keys:Array<Int>)
	{
		_control.set(name, keys);
	}
	
	/**
	 * If the input or key is held down.
	 * @param	input		An input name or key to check for.
	 * @return	True or false.
	 */
	public static function check(input:Dynamic):Bool
	{
		if (Std.is(input, String))
		{
#if debug
			if (!_control.exists(input))
			{
				//KP.log("Input '" + input + "' not defined");
				return false;
			}
#end
			var v:Array<Int> = _control.get(input),
				i:Int = v.length;
			while (i-- > 0)
			{
				
				if (v[i] < 0)
				{
					
					if (_keyNum > 0) return true;
					continue;
				}
				if (_key[v[i]] == true) return true;
			}
			return false;
		}
	
		return input < 0 ? _keyNum > 0 : _key.get(input);
	}
	
	/**
	 * If the input or key was pressed this frame.
	 * @param	input		An input name or key to check for.
	 * @return	True or false.
	 */
	public static function pressed(input:Dynamic):Bool
	{
		
		if (Std.is(input, String) && _control.exists(input))
		{
			
			var v:Array<Int> = _control.get(input),
				i:Int = v.length;
				
			while (i-- > 0)
			{
				
				if ((v[i] < 0) ? _pressNum != 0 : KP.indexOf(_press, v[i]) >= 0) return true;
				
			}
			
			return false;
		}
		
		return (input < 0) ? _pressNum != 0 : KP.indexOf(_press, input) >= 0;
	}
	
	/**
	 * If the input or key was released this frame.
	 * @param	input		An input name or key to check for.
	 * @return	True or false.
	 */
	public static function released(input:Dynamic):Bool
	{
		if (Std.is(input, String))
		{
			var v:Array<Int> = _control.get(input),
				i:Int = v.length;
			while (i-- > 0)
			{
				if ((v[i] < 0) ? _releaseNum != 0 : KP.indexOf(_release, v[i]) >= 0) return true;
			}
			return false;
		}
		return (input < 0) ? _releaseNum != 0 : KP.indexOf(_release, input) >= 0;
	}
	
	public static function enable()
	{
		
		Keyboard.get().notify(onKeyDown, onKeyUp);
		Mouse.get().notify(onMouseDown, onMouseUp, onMouseMove, onMouseWheel);
		if (Surface.get() != null) {
			Surface.get().notify(onTouch, onTouchEnd, onTouchMove);
			multiTouchSupported = true;
		}
	
		if (Sensor.get(SensorType.Accelerometer) != null)
		{
			Sensor.get(SensorType.Accelerometer).notify(onAccel);
			accelerationSupported = true;
		}
		if (Sensor.get(SensorType.Gyroscope) != null)
		{
			Sensor.get(SensorType.Gyroscope).notify(onGyro);
			gyroscopeSupported = true;
		}
		
	}
	
	/**
	 * Returns a joystick object (creates one if not connected)
	 * @param  id The id of the joystick, starting with 0
	 * @return    A Joystick object
	 */
	public static function gamepad(id:Int):com.khapunk.utils.Gamepad
	{
		var joy:com.khapunk.utils.Gamepad = _gamepads.get(id);
		if (joy == null)
		{
			if (Gamepad.get(id) != null)
			{
				
				joy = new com.khapunk.utils.Gamepad();
				Gamepad.get(id).notify(joy.onGamepadAxis, joy.onGamepadButton);
				_gamepads.set(id, joy);
			}
		}
		return joy;
	}
	
	/**
	 * Returns the number of connected joysticks
	 */
	public static var gamepads(get, never):Int;
	private static function get_gamepads():Int
	{
		var count:Int = 0;
		for (gamepad in _gamepads)
		{
			if (gamepad.connected)
			{
				count += 1;
			}
		}
		return count;
	}
	
	static private function onGyro(x: Float, y: Float, z: Float) : Void 
	{
		
		gyroX = x;
		gyroY = y;
		gyroZ = z;
	}
	
	static private function onAccel(x: Float, y: Float, z: Float) : Void 
	{
		accX = x;
		accY = y;
		accZ = z;
	}
	
	/**
	 * Updates the input states
	 */
	public static function update()
	{
		
		while (_pressNum > 0) _press[--_pressNum] = -1;
        while (_releaseNum > 0) _release[--_releaseNum] = -1;
		
		if (mousePressed) 		mousePressed = false;
		if (mouseReleased)		mouseReleased = false;
		
		if (leftMouseClicked) 	leftMouseClicked = false;
		if (rightMouseClicked) 	rightMouseClicked = false;
		if (midMouseClicked) 	midMouseClicked = false;
		
		if (leftMouseReleased) 	leftMouseReleased = false;
		if (rightMouseReleased) rightMouseReleased = false;
		if (midMouseReleased) 	midMouseReleased = false;
		
		if (mouseMoved) 		mouseMoved = false;
		
		for (gamepad in _gamepads) gamepad.update();
		
		if (multiTouchSupported)
		{
			for (touch in _touches) touch.update();
			if (Gesture.enabled) Gesture.update();
			
			for (touch in _touches)
			{
				if (touch.released && !touch.pressed)
				{
					_touches.remove(touch.id);
					_touchOrder.remove(touch.id);
				}
			}
		}
	}
	
	//------------------------------------------------
	//Touch input

	public static var touches(get, never):Map<Int,Touch>;
	private static inline function get_touches():Map<Int,Touch> { return _touches; }

	public static var touchOrder(get, never):Array<Int>;
	private static inline function get_touchOrder():Array<Int> { return _touchOrder; }
	
	private static function onTouch(id:Int, x:Int, y:Int) : Void {
		
		var tp:Touch = new Touch(
		Scaler.transformX(x, y,Engine.backbuffer,ScreenCanvas.the,System.screenRotation), 
		Scaler.transformY(x, y,Engine.backbuffer,ScreenCanvas.the,System.screenRotation), 
		id);
		
		_touches.set(id, tp);
		_touchOrder.push(id);
		
	}
	
	private static function onTouchEnd(id:Int, x:Int, y:Int) : Void
	{
		_touches.get(id).released = true;
	}
	
	private static function onTouchMove(id:Int, x:Int, y:Int) : Void
	{
		_touches.get(id).x = Scaler.transformX(x, y,Engine.backbuffer,ScreenCanvas.the,System.screenRotation);
		_touches.get(id).y = Scaler.transformY(x, y, Engine.backbuffer, ScreenCanvas.the, System.screenRotation);
		
	}
	
	/**
	 * Iterate over the currently active touch points
	 * @param	touchCallback
	 */
	public static function touchPoints(touchCallback:Touch->Void) : Void
	{
		for (touch in _touches)
		{
			touchCallback(touch);
		}
	}
	//------------------------------------------------
	private static function onKeyDown(key:Int) : Void
	{
		//var code:Int = keyCode(e);
		
		
		if (key == -1) // No key
			return;
		lastKey = key;
		
		if (key == KeyCode.Backspace) keyString = keyString.substr(0, keyString.length - 1);
		else //if ((code > 47 && code < 58) || (code > 64 && code < 91) || code == 32)
		{
			
			var char:String = String.fromCharCode(key);
			if (keyString.length > kKeyStringMax) keyString = keyString.substr(1);
			
			//if (key == Key.SHIFT)
			//	char = char.toUpperCase();
			//else char = char.toLowerCase();
			
			keyString += char;
			 
		}
		
		if (!_key[key])
		{
			_key[key] = true;
			_keyNum++;
			_press[_pressNum++] = key;
		}
	}
	
	private static function onKeyUp(key:Int) : Void
	{
		//var code:Int = keyCode(e);
		
		if (key == -1) // No key
			return;

		if (_key[key])
		{
			_key[key] = false;
			_keyNum--;
			_release[_releaseNum++] = key;
		}
	}
	
	
	
	private static function onMouseMove(x: Int, y: Int,xd: Int, yd: Int)
	{
		mouseMoved = true;
		_mouseX = x;
		_mouseY = y;
		
		MouseDeltaX = xd;
		MouseDeltaY = yd;
	}
	
	private static function onMouseDown(button: Int, x: Int, y: Int) : Void
	{
		switch(button)
		{
			case 0:
				leftMouseDown = true;
				leftMouseClicked = true;
			case 1:
				rightMouseDown = true;
				rightMouseClicked = true;
			case 2:
				midMouseDown = true;
				midMouseClicked = true;
		}
		
		if (!mouseDown)
		{
			mouseDown = true;
			mouseAllUp = false;
		}
		mousePressed = true;

		_mouseX = x;
		_mouseY = y;
	}

	private static function onMouseUp(button: Int, x: Int, y: Int)
	{
		switch(button)
		{
			case 0:
				leftMouseDown = false;
				leftMouseReleased = true;
			case 1:
				rightMouseDown = false;
				rightMouseReleased = true;
			case 2:
				midMouseDown = false;
				midMouseReleased = true;
		}
		
		if (!leftMouseDown && !rightMouseDown && !midMouseDown)
		{ 
		 mouseDown = false;
		 mouseAllUp = true;
		}
		 mouseReleased = true;
	}

	private static function onMouseWheel(delta: Int)
	{
		mouseWheel = true;
		_mouseWheelDelta = delta;
	}
	

	
}
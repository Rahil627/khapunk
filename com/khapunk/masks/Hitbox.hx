package com.khapunk.masks;
import com.khapunk.Mask;

/**
 * ...
 * @author ...
 */
class Hitbox extends Mask
{

	// Hitbox information.
	private var _width:Int = 0;
	private var _height:Int = 0;
	private var _x:Int = 0;
	private var _y:Int = 0;
	
	/**
	 * Constructor.
	 * @param	width		Width of the hitbox.
	 * @param	height		Height of the hitbox.
	 * @param	x			X offset of the hitbox.
	 * @param	y			Y offset of the hitbox.
	 */
	public function new(width:Int = 1, height:Int = 1, x:Int = 0, y:Int = 0)
	{
		super();
		_width = width;
		_height = height;
		_x = x;
		_y = y;
		check.set(Type.getClassName(Hitbox), collideHitbox);
	}
	
	/** @private Collides against an Entity. */
	override private function collideMask(other:Mask):Bool
	{
		if (other.parent != null)
		{
			var px:Float = _x, py:Float = _y;
			if (parent != null)
			{
				px += parent.x;
				py += parent.y;
			}

			var ox = other.parent.originX + other.parent.x,
				oy = other.parent.originY + other.parent.y;

			return px + _width > ox
				&& py + _height > oy
				&& px < ox + other.parent.width
				&& py < oy + other.parent.height;
		}
		return false;
	}
	
	/** @private Collides against a Hitbox. */
	private function collideHitbox(other:Hitbox):Bool
	{
		var px:Float = _x, py:Float = _y;
		if (parent != null)
		{
			px += parent.x;
			py += parent.y;
		}

		var ox:Float = other._x, oy:Float = other._y;
		if (other.parent != null)
		{
			ox += other.parent.x;
			oy += other.parent.y;
		}

		return px + _width > ox
			&& py + _height > oy
			&& px < ox + other._width
			&& py < oy + other._height;
	}

	/**
	 * X offset.
	 */
	public var x(get, set):Int;
	private function get_x():Int { return _x; }
	private function set_x(value:Int):Int
	{
		if (_x == value) return value;
		_x = value;
		if (list != null) list.update();
		else if (parent != null) update();
		return _x;
	}

	/**
	 * Y offset.
	 */
	public var y(get, set):Int;
	private function get_y():Int { return _y; }
	private function set_y(value:Int):Int
	{
		if (_y == value) return value;
		_y = value;
		if (list != null) list.update();
		else if (parent != null) update();
		return _y;
	}

	/**
	 * Width.
	 */
	public var width(get, set):Int;
	private function get_width():Int { return _width; }
	private function set_width(value:Int):Int
	{
		if (_width == value) return value;
		_width = value;
		if (list != null) list.update();
		else if (parent != null) update();
		return _width;
	}

	/**
	 * Height.
	 */
	public var height(get, set):Int;
	private function get_height():Int { return _height; }
	private function set_height(value:Int):Int
	{
		if (_height == value) return value;
		_height = value;
		if (list != null) list.update();
		else if (parent != null) update();
		return _height;
	}

	/** Updates the parent's bounds for this mask. */
	override public function update()
	{
		if (parent != null)
		{
			// update entity bounds
			parent.originX = -_x;
			parent.originY = -_y;
			parent.width = _width;
			parent.height = _height;
			// update parent list
			if (list != null)
				list.update();
		}
	}
	
}
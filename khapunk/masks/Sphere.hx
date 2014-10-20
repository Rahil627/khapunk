package khapunk.masks;

import khapunk.math.Vector3;

class Sphere implements Mask
{

	/**
	 * Position of the Sphere.
	 */
	public var position:Vector3;

	/**
	 * Radius of the Sphere.
	 */
	public var radius:Float;

	public function new(?position:Vector3, radius:Float=0)
	{
		this.position = (position == null ? new Vector3() : position);
		this.radius = radius;
	}

	public function intersects(other:Mask):Bool
	{
		if (Std.is(other, Sphere)) return intersectsSphere(cast other);
		return false;
	}

	public function collide(other:Mask):Vector3
	{
		return Vector3.ZERO;
	}

	public function intersectsSphere(other:Sphere):Bool
	{
		var dx:Float = position.x - other.position.x;
		var dy:Float = position.y - other.position.y;
		var dz:Float = position.z - other.position.z;
		return (dx * dx + dy * dy + dz * dz) < Math.pow(radius + other.radius, 2);
	}

}

package khapunk.masks;

import khapunk.math.Vector3;

interface Mask
{

	public function intersects(other:Mask):Bool;
	public function collide(other:Mask):Vector3;

}

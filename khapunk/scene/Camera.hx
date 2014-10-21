package khapunk.scene;

import khapunk.KP;
import kha.Color;
import khapunk.math.Vector3;
import khapunk.math.Matrix4;
import khapunk.math.Math;

class Camera extends SceneNode
{

	public var transform(default, null):Matrix4;
	public var up:Vector3;
	public var clearColor:Color;

	public function new()
	{
		super();
		transform = new Matrix4();
		up = new Vector3(0, 1, 0);
		clearColor = Color.fromFloats(0.117, 0.117, 0.117, 1.0);
	}

	public function make2D(width:Float, height:Float):Void
	{
		_projection = Matrix4.createOrtho(0, width, height, 0, 500, -500);
	}

	public function make3D(fov:Float, width:Float, height:Float):Void
	{
		_projection = Matrix4.createPerspective(fov * Math.RAD, width / height, -100, 100);
	}

	public function lookAt(target:Vector3):Void
	{
		transform.lookAt(position, target, up);
	}

	public function update():Void
	{
		if (_projection == null) make2D(HXP.window.width, HXP.window.height);
		transform.identity();
		transform.translate(-position.x, -position.y, -position.z);
		transform.multiply(_projection);
	}

	private var _projection:Matrix4;

}

package com.khapunk.graphics;
import com.khapunk.graphics.atlas.AtlasRegion;
import com.khapunk.graphics.atlas.TextureAtlas;
import com.khapunk.graphics.atlas.TileAtlas;
import kha.Canvas;
import kha.Color;
import kha.Framebuffer;
import kha.graphics2.Graphics;
import kha.Image;
import kha.Assets;
import kha.math.Vector2;
import com.khapunk.graphics.Rectangle;

/**
 * ...
 * @author ...
 */
class PunkImage extends Graphic
{


	// Source and buffer information.
	private var _source:Image;
	private var _sourceRect:Rectangle;
	private var _region:AtlasRegion;

	// Color and alpha information.
	private var _alpha:Float;
	private var _color:Int;
	//private var _colorTransform:ColorTransform;
	//private var _matrix:Matrix;
	private var _red:Float;
	private var _green:Float;
	private var _blue:Float;

	// Flipped image information.
	private var _class:String;
	private var _flippedX:Bool = false;
	private var _flippedY:Bool = false;
	//private var _flip:BitmapData;
	//private static var _flips:Map<String,BitmapData> = new Map<String,BitmapData>();

	private var _scale:Float = 1;
	

	/**
	 * Rotation of the image, in degrees.
	 */
	public var angle:Float;

	/**
	 * Scale of the image, effects both x and y scale.
	 */
	public var scale(get, set):Float;
	private inline function get_scale():Float { return _scale; }
	private inline function set_scale(value:Float):Float { return _scale = value; }

	/**
	 * X scale of the image.
	 */
	public var scaleX:Float = 1.0;

	/**
	 * Y scale of the image.
	 */
	public var scaleY:Float = 1.0;

	/**
	 * X origin of the image, determines transformation point.
	 * Defaults to top-left corner.
	 */
	public var originX:Float = 0.0;

	/**
	 * Y origin of the image, determines transformation point.
	 * Defaults to top-left corner.
	 */
	public var originY:Float = 0.0;

	
	
	
	/**
	 * Constructor.
	 * @param	source		Source image.
	 * @param	clipRect	Optional rectangle defining area of the source image to draw.
	 * @param	name		Optional name, necessary to identify the bitmapData if you are using flipped
	 */
	public function new(source:Dynamic, clipRect:Rectangle = null, name:String = "")
	{
		super();
		init();

		_sourceRect = new Rectangle(0, 0, 0, 0);
		
		// check if the _source or _region were set in a higher class
		if (_source == null && _region == null)
		{
			_class = name;
			/*if (Std.is(source, TextureAtlas))
			{
				var t:TextureAtlas = cast(source, TextureAtlas);
				setAtlasRegion(t.getRegion(name));
			}*/
			if (Std.is(source, AtlasRegion))
			{
				setAtlasRegion(source);
			}
			else if (Std.is(source, TileAtlas))
			{
				setBitmapSource(cast(source, TileAtlas).img);
			}
			else if (Std.is(source, Image))
			{
				setBitmapSource(source);
			}
			else if (Std.is(source, String)){
				
				setBitmapSource(Reflect.field(Assets.images,source));
			}

			if (_source == null && _region == null)
				throw "Invalid source image.";
		}
		
		if (_region == null && _sourceRect != null)
		{
			_region = new AtlasRegion();
			_region.image = _source;
			_region.w = _source.width;
			_region.h = _source.height;
			_region.x = 0;
			_region.y = 0;
		}

		if (clipRect != null)
		{
			if (clipRect.width == 0) clipRect.width = _sourceRect.width;
			if (clipRect.height == 0) clipRect.height = _sourceRect.height;
			_sourceRect = clipRect;
		}
		
	}
	
	private inline function setAtlasRegion(region:AtlasRegion)
	{
		_region = region;
		_source = region.image;
		_sourceRect = new Rectangle(region.x, region.y, _region.w, _region.h);
	}
	
	private inline function setBitmapSource(image:Image)
	{
		_sourceRect.width = image.width;
		_sourceRect.height = image.height;
		_source = image;
		
	}
	
	/** @private Initialize variables */
	private inline function init()
	{
		angle = 0;
		scale = scaleX = scaleY = 1;
		originX = originY = 0;

		_alpha = 1;
		_flippedX = false;
		_color = 0xFFFFFFFF;
		_red = _green = _blue = 1;
		//_matrix = KP.matrix;
	}
	
	/** Renders the image. */
	override public function render(buffer:Canvas, point:Vector2, camera:Vector2)
	{
		
		material.apply(buffer);
		
		var sx = scale * scaleX,
			sy = scale * scaleY;
			
		// determine drawing location
		this.point.x = point.x + x - originX * sx - camera.x * scrollX;
		this.point.y = point.y + y - originY * sy - camera.y * scrollY;
		
		if (_flippedX) this.point.x += _sourceRect.width * sx;
		if (_flippedY) this.point.y += _sourceRect.height * sy;
		
		buffer.g2.pushRotation(angle, 
		this.point.x +  (sx * (_flippedX ? -1 : 1)) * _region.w*0.5 , 
		this.point.y +  (sy * (_flippedY ? -1 : 1)) * _region.h*0.5);
		
		buffer.g2.color = (Color.fromValue(_color));
		buffer.g2.pushOpacity(_alpha);
		
		buffer.g2.drawScaledSubImage(
		_source,
		_region.x,
		_region.y,
		_region.w,
		_region.h,
		this.point.x,
		this.point.y,
		_region.w * (sx * (_flippedX ? -1 : 1)),
		_region.h * (sy * (_flippedY ? -1 : 1))
		);
		
		buffer.g2.popTransformation();
		
		buffer.g2.popOpacity();
		buffer.g2.color = (Color.White);
	}
	
	/**
	 * Change the opacity of the Image, a value from 0 to 1.
	 */
	public var alpha(get, set):Float;
	private function get_alpha():Float { return _alpha; }
	private function set_alpha(value:Float):Float
	{
		value = value < 0 ? 0 : (value > 1 ? 1 : value);
		if (_alpha == value) return value;
		_alpha = value;
		
		return _alpha;
	}
	
	/**
	 * The tinted color of the Image. Use 0xFFFFFF to draw the Image normally.
	 */
	public var color(get, set):Int;
	private function get_color():Int { return _color; }
	private function set_color(value:Int):Int
	{
		value &= 0xFFFFFF;
		if (_color == value) return value;
		_color = value;
		// save individual color channel values
		_red = KP.getRed(_color) / 255;
		_green = KP.getGreen(_color) / 255;
		_blue = KP.getBlue(_color) / 255;
		
		return _color;
	}
	
	/**
	 * Centers the Image's originX/Y to its center.
	 */
	public function centerOrigin()
	{
		originX = Std.int(width / 2);
		originY = Std.int(height / 2);
	}
	
	/**
	 * Centers the Image's originX/Y to its center, and negates the offset by the same amount.
	 */
	public function centerOO()
	{
		x += originX;
		y += originY;
		centerOrigin();
		x -= originX;
		y -= originY;
	}
	
	/**
	 * Width of the image.
	 */
	public var width(get, never):Int;
	private function get_width():Int { return Std.int((!_region.rotated ? _region.w : _region.h)); }

	/**
	 * Height of the image.
	 */
	public var height(get, never):Int;
	private function get_height():Int { return Std.int((!_region.rotated ? _region.h : _region.w)); }
	
	/**
	 * The scaled width of the image.
	 */
	public var scaledWidth(get, set):Float;
	private function get_scaledWidth():Float { return width * scaleX * scale; }
	private function set_scaledWidth(w:Float):Float {
		scaleX = w / scale / width;
		return scaleX;
	}

	/**
	 * The scaled height of the image.
	 */
	public var scaledHeight(get, set):Float;
	private function get_scaledHeight():Float { return height * scaleY * scale; }
	private function set_scaledHeight(h:Float):Float {
		scaleY = h / scale / height;
		return scaleY;
	}
	
	/**
	 * Clipping rectangle for the image.
	 */
	public var clipRect(get, null):Rectangle;
	private function get_clipRect():Rectangle { return _sourceRect; }
	
	
	/**
	 * If you want to draw the Image horizontally flipped. This is
	 * faster than setting scaleX to -1 if your image isn't transformed.
	 */
	public var flippedX(get, set):Bool;
	private function get_flippedX():Bool { return _flippedX; }
	private function set_flippedX(value:Bool):Bool
	{
		if (_flippedX == value) return value;
		_flippedX = value;
		return _flippedX;
	}
	
	/**
	 * If you want to draw the Image vertically flipped. This is
	 * faster than setting scaleY to -1 if your image isn't transformed.
	 */
	public var flippedY(get, set):Bool;
	private function get_flippedY():Bool { return _flippedY; }
	private function set_flippedY(value:Bool):Bool
	{
		if (_flippedY == value) return value;
		_flippedY = value;
		return _flippedY;
	}
	
}
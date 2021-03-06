package com.khapunk.graphics;
import com.khapunk.Graphic;
import kha.Canvas;
import kha.Color;
import kha.Font;
import kha.FontStyle;
import kha.Framebuffer;
import kha.graphics2.Graphics;
import kha.Image;
import kha.Kravur;
import kha.Loader;
import kha.math.Vector2;

/**
 * ...
 * @author Sidar Talei
 */
class Text extends Graphic
{

	var font:Kravur;
	
	public var text:String = "";
	public var scaleX:Float = 1.0;
	public var scaleY:Float = 1.0;
	public var scaleCenterX:Float = 0;
	public var scaleCenterY:Float = 0;
	public var color:Color;
	public var alpha:Float;

	/**
	 * X origin of the image, determines transformation point.
	 * Defaults to top-left corner.
	 */
	public var originX:Float;

	/**
	 * Y origin of the image, determines transformation point.
	 * Defaults to top-left corner.
	 */
	public var originY:Float;
	
	
	public var scale(null, set):Float;
	private function set_scale(value:Float):Float
	{
		scaleX = scaleY = value;
		return value;
	}
	
	public static var DEFAULT_FONT(get,null):Kravur;
	private static function get_DEFAULT_FONT() : Kravur
	{
		if ( DEFAULT_FONT == null )
		{
			var fs:FontStyle = new FontStyle(false, false, false);
			DEFAULT_FONT = cast(Loader.the.loadFont("defualt", fs, 12), Kravur);
		}
		return DEFAULT_FONT;
	}
	
	public function new(?font:Kravur) 
	{
		super();
		if (font == null)
		this.font = DEFAULT_FONT;
		else {
			this.font = font;
		}
		color  = Color.White;
		alpha = 1;
		originX = originY = 0;
	}
	
	override public function render(buffer:Canvas, point:Vector2, camera:Vector2) 
	{
			// determine drawing location
		this.point.x = point.x + x - originX - camera.x * scrollX;
		this.point.y = point.y + y - originY - camera.y * scrollY;

		buffer.g2.set_color(color);
		buffer.g2.set_opacity(alpha);
		
		buffer.g2.set_font(font);
		buffer.g2.drawString(text, this.point.x, this.point.y);// scaleX, scaleY, scaleCenterX, scaleCenterY);

		buffer.g2.set_opacity(1);
		buffer.g2.set_color(Color.White);
		
		
	}
	
}
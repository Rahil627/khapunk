package com.khapunk.graphics.atlas;
 
import com.khapunk.graphics.atlas.AtlasRegion;
import haxe.Json;
import kha.Blob;
import kha.Image;
import kha.Assets;

/**
 * ...
 * @author Sidar Talei
 */
 
class TextureAtlas {

	private var image:Image;
	private var map:Map<String,AtlasRegion>;
	private var regionCache:Map < String, Array<AtlasRegion> > ;
	public var meta:TPMeta;
	
	static var pool:Map<String, TextureAtlas> = new Map<String,TextureAtlas>();
	
	public static function get(name:String) {
		if (pool.exists(name)) {
			return pool.get(name);
		}
		
		var t:TextureAtlas = new TextureAtlas(name);
		pool.set(name, t);
		return t;
	}
	
	public static function clear() : Void {
		pool = new Map<String,TextureAtlas>();
	}
	
	public function getImage() : Image {
		return image;
	}
	
	function new(packerfile:String) {
		map = new Map <String, AtlasRegion>();
		regionCache = new Map < String, Array<AtlasRegion> >();
		//---------------------------------
		//Parse json
		var packer:Dynamic = Json.parse( cast Reflect.field(Assets.blobs,packerfile).toString());
		var frames:Array<Dynamic> = packer.frames;
		meta = packer.meta;
		//---------------------------------
		//Get image
		var imagename: String = meta.image;
		imagename = imagename.split(".")[0];
		image = Reflect.field(Assets.images,imagename);
		//---------------------------------
		//Get all regions
		for (i in 0...frames.length){
			var ar:AtlasRegion = new AtlasRegion();
			ar.name = frames[i].filename;
			ar.x = frames[i].frame.x;
			ar.y = frames[i].frame.y;
			ar.w = frames[i].frame.w;
			ar.h = frames[i].frame.h;
			ar.sx = frames[i].spriteSourceSize.x;
			ar.sy = frames[i].spriteSourceSize.y;
			ar.sw = frames[i].spriteSourceSize.w;
			ar.sh = frames[i].spriteSourceSize.h;
			ar.rotated = frames[i].rotated;
			ar.trimmed = frames[i].trimmed;
			ar.image = image;
			ar.atlas = this;
			map.set(ar.name, ar);
		}
		
	}
	
	/**
		Returns a single region.
		@param name The name of the region.
	 */
	public function getRegion(name: String): AtlasRegion {
		return map.get(name);
	}
	
	/**
		Returns an array of regions with the same sequential name.
		For example "walk" would return regions: walk_1, walk_2...walk_n.
		The regions are automatically sorted by their names.
		@param cache keeps the array for faster retrieval.
	 */
	public function getRegions(name: String, cache:Bool = false) : Array<AtlasRegion> { 
		
		if (regionCache.exists(name)) return regionCache.get(name);
		
		var r:String = name + "[^a-zA-Z]+";
		var reg:EReg = new EReg(r, "");
		var i = map.iterator();
		var arr: Array<AtlasRegion> = new Array<AtlasRegion>();
		var at:AtlasRegion;
		
		do {
			at = i.next();
			if (reg.match(at.name))
				arr.push(at);
		}
		while (i.hasNext());
		
		arr.sort(sortByName);
		if (cache) regionCache.set(name, arr);
		return arr;
	}
	/**
	   Returns all regions.
	   @param sort Sorts the array on alphabetical order based on the region names.
	   @param return An array with all the regions.
	 */
	public function getAllRegions(sort:Bool = false) : Array<AtlasRegion> {
		var i = map.iterator();
		var arr: Array<AtlasRegion> = new Array<AtlasRegion>();
		do {
			arr.push(i.next());
		}
		while (i.hasNext());
		if (sort) arr.sort(sortByName);
		return arr;
	}
	
	function sortByName(a:AtlasRegion, b:AtlasRegion) : Int
	{
		var s1:String = a.name.toLowerCase();
		var s2:String = b.name.toLowerCase();
		if (s1 < s2) return -1;
		if (s1 > s2) return 1;
		return 0;
	}
}

typedef TPSize = {

    var w:Int;
    var h:Int;
}

typedef TPMeta = {

    var app:String;
    var version:String;
    var image:String;
    var format:String;
    var size:TPSize;
    var scale:String;
    var smartupdate:String;
}

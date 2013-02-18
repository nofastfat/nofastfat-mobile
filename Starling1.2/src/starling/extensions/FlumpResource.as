package starling.extensions {
import starling.display.Image;
import starling.extensions.flumpVos.FKfVo;
import starling.extensions.flumpVos.FMovieVo;
import starling.textures.Texture;
import starling.textures.TextureAtlas;

public class FlumpResource {
	private static var _instance : FlumpResource = new FlumpResource();

	public static function getInstance() : FlumpResource {
		return _instance;
	}

	private var _starlingAtlasXml : XML = new XML("<TextureAtlas></TextureAtlas>");

	/**
	 * 所有动画的数据
	 */
	private var _movies : Array = [];

	/**
	 * 存放所有flump的image
	 */
	private var _images : Array = [];
	
	private var _items : Array = [];

	/**
	 * 添加一个flump资源
	 * @param fXml
	 */
	public function addFlump(texture : Texture, fXml : XML) : void {
		var xmlList : XMLList = fXml..movie;
		var len : int = xmlList.length();
		for (var i : int = 0; i < len; i++) {
			var movieXml : XML = xmlList[i];
			var vo : FMovieVo = FMovieVo.parseFrom(movieXml);
			_movies[vo.name] = vo;
		}

		addFlumpXml(fXml);

		var atlas : TextureAtlas = new TextureAtlas(texture, _starlingAtlasXml);
		xmlList = _starlingAtlasXml..SubTexture;
		len = xmlList.length();
		for (i = 0; i < len; i++) {
			var name : String = String(xmlList[i].@name);
			_images[name] = new Image(atlas.getTexture(name));
		}
	}

	/**
	 * 获取一个MC 
	 * @param movieName
	 * @return 
	 */	
	public function getMovie(movieName : String) : FMovie {
		var vo : FMovieVo = _movies[movieName];
		var movie : FMovie = new FMovie(vo);

		return movie;
	}

	/**
	 * 获取动画中的image
	 * @param movieName
	 * @param frameIndex 从1开始
	 * @return [Image, Image, ...]
	 */
	public function getMovieImages(movieName : String, frameIndex : int) : Array {
		var rs : Array = [];
		var vo : FMovieVo = _movies[movieName];
		if (vo == null) {
			return rs;
		}

		var ffs : Array = vo.getFrameAt(frameIndex);
		if (ffs != null) {
			var len : int = ffs.length;
			for (var i : int = 0; i < len; i++) {
				var kfVo : FKfVo = ffs[i];
				var imgs : Array = kfVo.getImages();
				
				rs = rs.concat(imgs);
			}
		}

		return rs;

	}

	public function getImage(imageName : String) : Image {
		return _images[imageName];
	}
	
	public function getMovieVo(movieName) : FMovieVo{
		return _movies[movieName]
	}

	/**
	 * 添加一个flumpXML对象
	 * @param fXml
	 */
	private function addFlumpXml(fXml : XML) : void {
		var group : XML = fXml..textureGroup..atlas[0];
		var str : String = "";
		for each (var xml : XML in group..texture) {
			var rect : Array = String(xml.@rect).split(",");
			str = "<SubTexture name='" + xml.@name + "' x='" + rect[0] + "' y='" + rect[1] + "' width='" + rect[2] + "' height='" + rect[3] + "' />";
			_starlingAtlasXml.appendChild(new XML(str));
		}
	}
}
}

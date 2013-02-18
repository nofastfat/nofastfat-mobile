package {
import com.xy.model.enum.DataConfig;
import com.xy.model.enum.FPS;
import com.xy.model.vo.MapVo;
import com.xy.util.factories.MovieClipFactory;
import com.xy.view.component.ScaleImage;

import flash.display.Bitmap;
import flash.display.Loader;
import flash.events.Event;
import flash.geom.Rectangle;
import flash.media.Sound;
import flash.net.URLRequest;
import flash.net.registerClassAlias;
import flash.system.ImageDecodingPolicy;
import flash.system.LoaderContext;
import flash.utils.ByteArray;
import flash.utils.Dictionary;

import starling.display.Button;
import starling.display.Image;
import starling.display.MovieClip;
import starling.display.Quad;
import starling.textures.Texture;
import starling.textures.TextureAtlas;

public class Assets {

	public static const PRE_KEY_ROLE : String = "role";
	public static const PRE_KEY_MONSTER : String = "monster";
	public static const PRE_KEY_NPC : String = "npc";
	public static const PRE_KEY_EFFECT : String = "effect";

	private static const ASSETS_MAP : Array = [];

	{
		ASSETS_MAP[PRE_KEY_ROLE] = "role";
		ASSETS_MAP[PRE_KEY_EFFECT] = "role";
		ASSETS_MAP[PRE_KEY_NPC] = "role";
		ASSETS_MAP[PRE_KEY_MONSTER] = "monster";
	}

	public static var mask : Quad = new Quad(DataConfig.WIDTH, DataConfig.HEIGHT, 0x000000);
	public static var mask4 : Quad = new Quad(DataConfig.WIDTH, DataConfig.HEIGHT, 0x000000);

	{
		mask.alpha = .2;
		mask4.alpha = .4;
	}

	private static var sContentScaleFactor : int = 1;
	private static var sTextures : Dictionary = new Dictionary();
	private static var sSounds : Dictionary = new Dictionary();
	private static var sTextureAtlasDic : Dictionary = new Dictionary();

	private static var postionXml : XML = XML(create("positionXml"));


	public static function initTextureAsync(name : String, callBack : Function) : void {
		var loader : Loader = new Loader();
		var lc : LoaderContext = new LoaderContext();
		lc.imageDecodingPolicy = ImageDecodingPolicy.ON_LOAD;
		loader.load(new URLRequest("/media/textures/roles/" + name + ".png"), lc);
		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e : Event):void{
			sTextures[name + "Texture"] = Texture.fromBitmap(loader.content as Bitmap);
			callBack();
		});
	}
	
	/**
	 * 查找一个材质
	 * @param name
	 * @return
	 */
	public static function getTexture(name : String) : Texture {
		if (sTextures[name] == undefined) {
			var data : Object = create(name);

			if (data is Bitmap)
				sTextures[name] = Texture.fromBitmap(data as Bitmap, true, false, sContentScaleFactor);
			else if (data is ByteArray)
				sTextures[name] = Texture.fromAtfData(data as ByteArray, sContentScaleFactor);
		}

		return sTextures[name];
	}

	public static function getSound(name : String) : Sound {
		var sound : Sound = sSounds[name] as Sound;
		if (sound == null){
			sound = create(name) as Sound;
			sSounds[name] = sound;
		}
		
		return sound;
	}

	public static function getTextureAtlas(name : String, xmlName : String) : TextureAtlas {
		var sta : TextureAtlas;
		if (sTextureAtlasDic[name] == undefined) {
			var texture : Texture = getTexture(name);
			var xml : XML = XML(create(xmlName));
			sta = new TextureAtlas(texture, xml);
			sTextureAtlasDic[name] = sta;
		} else {
			sta = sTextureAtlasDic[name];
		}
		return sta;
	}


	private static function create(name : String) : Object {
		var textureClass : Class = sContentScaleFactor == 1 ? AssetEmbeds_1x : AssetEmbeds_1x;
		if(textureClass[name] == null){
			return null;
		}
		return new textureClass[name];
	}

	public static function get contentScaleFactor() : Number {
		return sContentScaleFactor;
	}

	public static function set contentScaleFactor(value : Number) : void {
		for each (var texture : Texture in sTextures)
			texture.dispose();

		sTextures = new Dictionary();
		sContentScaleFactor = value < 1.5 ? 1 : 2; // assets are available for factor 1 and 2 
	}

	/**
	 * 获取一个UI
	 * @param name
	 * @return
	 */
	public static function makeUI(name : String, scale : Number = 2, isInRole : Boolean = false) : Image {
		var textureAtlas : TextureAtlas;
		if (isInRole) {
			textureAtlas = getTextureAtlas("roleTexture", "roleXml");
		} else {
			textureAtlas = getTextureAtlas("uiTexture", "uiXml");
		}
		var img : Image = new Image(textureAtlas.getTexture(name));
		img.scaleX = img.scaleY = scale;
		return img;
	}

	/**
	* 获取一个UI
	* @param name
	* @return
	*/
	public static function makeScaleImage(name : String, scale : Number = 2, isInRole : Boolean = false) : ScaleImage {
		var textureAtlas : TextureAtlas;
		if (isInRole) {
			textureAtlas = getTextureAtlas("roleTexture", "roleXml");
		} else {
			textureAtlas = getTextureAtlas("uiTexture", "uiXml");
		}
		var img : ScaleImage = new ScaleImage(textureAtlas.getTexture(name));
		img.scaleX = img.scaleY = scale;
		return img;
	}

	/**
	 * 创建UI的MC
	 * @param name
	 * @param scale
	 * @return
	 */
	public static function makeUiMc(name : String, scale : Number = 2, isInRole : Boolean = false) : MovieClip {
		var textureAtlas : TextureAtlas;
		if (isInRole) {
			textureAtlas = getTextureAtlas("roleTexture", "roleXml");
		} else {
			textureAtlas = getTextureAtlas("uiTexture", "uiXml");
		}
		var mc : MovieClip = new MovieClip(textureAtlas.getTextures(name), FPS.NORMAL);
		mc.scaleX = mc.scaleY = scale;

		return mc;
	}

	/**
	* 获取一个UI
	* @param name
	* @return
	*/
	public static function makeBtnUI(name : String, scale : Number = 2) : Button {
		var textureAtlas : TextureAtlas = getTextureAtlas("uiTexture", "uiXml");
		var btn : Button = new Button(textureAtlas.getTexture(name + "0"), "", textureAtlas.getTexture(name + "1"));
		btn.scaleX = btn.scaleY = scale;
		return btn;
	}

	/**
	 * 获取一个角色资源
	 * @param gdcode
	 * @param action
	 * @param fps
	 * @return
	 */
	public static function makeRoleMc(gdcode : int, action : String, fps : int = 12) : MovieClip {
		var preKey : String;
		if (20000 <= gdcode && gdcode <= 29999) {
			preKey = PRE_KEY_MONSTER;
		} else if (60000 <= gdcode && gdcode <= 69999) {
			preKey = PRE_KEY_NPC;
		} else {
			preKey = PRE_KEY_ROLE;
		}

		return MovieClipFactory.make(preKey, gdcode, action, fps);
	}

	/**
	 * 获取一个光效资源
	 * @param gdcode
	 * @param action
	 * @param fps
	 * @return
	 */
	public static function makeEffectMc(gdcode : int, action : String, fps : int = 12, scale : Number = 2) : MovieClip {
		var preKey : String = PRE_KEY_EFFECT + "_";
		var mc : MovieClip = MovieClipFactory.make(preKey, gdcode, action, fps);
		mc.scaleX = mc.scaleY = scale;
		return mc;
	}

	/**
	 * 直接NEW对象
	 * @param preKey
	 * @param gdcode
	 * @param action
	 * @param fps
	 * @return
	 */
	public static function makeMc(preKey : String, gdcode : int, action : String, fps : int = 12) : MovieClip {
		var positionXmlKey : String = preKey + "positionXml";

		var allPreKey : String = preKey.charAt(preKey.length - 1) == "_" ? preKey.substr(0, preKey.length - 1) : preKey;
		var prefix : String = action;
		if (gdcode != 0) {
			if (action != "") {
				prefix = preKey + gdcode + "_" + action;
			} else {
				prefix = preKey + gdcode;
			}
		} else {
			if (allPreKey != PRE_KEY_ROLE) {
				prefix = preKey + action;
			}
		}

		var allTextureKey : String = ASSETS_MAP[allPreKey] + "Texture";
		var allXmlKey : String = ASSETS_MAP[allPreKey] + "Xml";

		var positionXml : XML = getPostionXml(allPreKey, gdcode);
		var textureAtlas : TextureAtlas = getTextureAtlas(allTextureKey, allXmlKey);
		var mc : MovieClip = new MovieClip(textureAtlas.getTextures(prefix), fps);

		var pivotXml : XML;
		if (30000 <= gdcode && gdcode <= 40000) {
			pivotXml = positionXml["e" + gdcode][0];
		} else {
			var arr : Array = action.split("_");
			var node : String = arr.length > 1 ? arr[0] : "LU";
			pivotXml = positionXml[node][action.substr(node.length + 1)][0];
		}
		mc.pivotX = int(pivotXml.@x);
		mc.pivotY = int(pivotXml.@y);

		var effectFrame : int = int(pivotXml.@effectFrame);
		if (effectFrame != 0) {
			DataConfig.setEffectFrame(gdcode, action, effectFrame);
		}

		mc.scaleX = DataConfig.SCALE;
		mc.scaleY = DataConfig.SCALE;

		return mc;
	}

	private static function getPostionXml(preKey : String, gdcode : int) : XML {
		if (preKey == PRE_KEY_MONSTER || preKey == PRE_KEY_NPC) {
			preKey += gdcode;
		}

		return postionXml[preKey][0];
	}

	public static function getUIRect(gdcode : int) : Rectangle {
		var xx : XML = postionXml.ui["ui" + gdcode][0];
		var rect : Rectangle = new Rectangle(int(xx.@x), int(xx.@y), int(xx.@width), int(xx.@height));
		return rect;
	}

	/**
	 * 对象回收
	 * @param mc
	 */
	public static function collect(mc : MovieClip) : void {
		MovieClipFactory.collectToPool(mc);
	}

	private static function findXml(source : XML, key : String) : XML {
		for each (var xml : XML in source..TextureAtlas) {
			var imagePath : String = String(xml.@imagePath);
			if (imagePath == key + ".png") {
				return xml;
			}
		}

		return null;
	}

	public static function getMap(id : int) : MapVo {
		var vo : MapVo;
		registerClassAlias("MapVo", MapVo);
		var ba : ByteArray = create("map" + id) as ByteArray;
		vo = ba.readObject();

		return vo;
	}

}
}

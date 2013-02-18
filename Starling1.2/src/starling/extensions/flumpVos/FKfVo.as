package starling.extensions.flumpVos {
import starling.display.Image;
import starling.extensions.FlumpResource;

public class FKfVo extends FBaseVo {
	public var duration : int;
	public var ref : String;
	public var locX : Number = 0;
	public var locY : Number = 0;
	public var scaleX : Number = 1;
	public var scaleY : Number = 1;
	public var skewX : Number = 0;
	public var skewY : Number = 0;
	public var pivotX : Number = 0;
	public var pivotY : Number = 0;
	public var tweened : Boolean = true;

	public function FKfVo() {
		super();
	}

	public function getImages() : Array {
		var rs : Array = [];

		if (ref == "") {
			return rs;
		}

		var image : Image = FlumpResource.getInstance().getImage(ref);
		if (image != null) {
			rs.push(image);
			setToImage(image);
			return rs;
		}

		var images : Array = FlumpResource.getInstance().getMovieImages(ref, 1);
		if (images != null) {
			var len : int = images.length;
			for (var i : int = 0; i < len; i++) {
				image = images[i];
				setToImage(image, true);
				rs.push(image);
			}
		}


		return rs;
	}

	private function setToImage(image : Image, isAdd : Boolean = false) : void {
		if (isAdd) {
			image.x += locX;
			image.y += locY;
			image.pivotX += pivotX;
			image.pivotY += pivotY;
			image.skewX += skewX;
			image.skewY += skewY;
			image.scaleX *= scaleX;
			image.scaleY *= scaleY;
		} else {
			image.x = locX;
			image.y = locY;
			image.pivotX = pivotX;
			image.pivotY = pivotY;
			image.skewX = skewX;
			image.skewY = skewY;
			image.scaleX = scaleX;
			image.scaleY = scaleY;
		}
	}

	/**
	 * @param xml
	 * <kf duration="1" ref="角色 - 副本/~MovieClip/sprite 1519" loc="16.65,-6.55" scale="0.993,0.993" skew="1.7937,1.7937" tweened="false"/>
	 * @return
	 *
	 */
	public static function parseFrom(xml : XML) : FKfVo {
		var arr : Array;
		var vo : FKfVo = new FKfVo();
		vo.duration = int(xml.@duration);
		vo.ref = String(xml.@ref);

		if (String(xml.@loc) != "") {
			arr = String(xml.@loc).split(",");
			vo.locX = Number(arr[0]);
			vo.locY = Number(arr[1]);
		}

		if (String(xml.@scale) != "") {
			arr = String(xml.@scale).split(",");
			vo.scaleX = Number(arr[0]);
			vo.scaleY = Number(arr[1]);
		}

		if (String(xml.@skew) != "") {
			arr = String(xml.@skew).split(",");
			vo.skewX = Number(arr[0]);
			vo.skewY = Number(arr[1]);
		}

		if (String(xml.@pivot) != "") {
			arr = String(xml.@pivot).split(",");
			vo.pivotX = Number(arr[0]);
			vo.pivotY = Number(arr[1]);
		}

		if (String(xml.@tweened) != "") {
			vo.tweened = Boolean(xml.@tweened);
		}

		return vo;
	}
}
}

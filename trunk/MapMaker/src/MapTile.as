package {
import flash.display.Bitmap;
import flash.display.Sprite;

public class MapTile extends Sprite {
	public function MapTile() {
		super();
	}
	
	public function clone() : MapTile{
		if(numChildren > 0){
			var bmp : Bitmap = getChildAt(0) as Bitmap;
			var rs : Bitmap = new Bitmap(bmp.bitmapData);
			var sp : MapTile = new MapTile();
			sp.addChild(rs);
			sp.name = this.name;
			rs.name = this.name;
			return sp;
		}
		
		return null;
	}
}
}

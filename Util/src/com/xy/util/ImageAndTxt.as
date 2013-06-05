package com.xy.util{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.utils.ByteArray;

/**
 * <pre>
 * 针对图片和文本进行数据合并与分解 
 * 压缩:
 * 	var img : BitmapData = new BitmapData();
 * 	var ba : ByteArray = PNGEncoder.encode(img);
 * 	var f : FileReference = new FileReference();
 * 	f.save(ImageAndTxt.compress(ba, txt), "data.png");
 * 
 * 解压缩:
 * 		
 *	var load : URLLoader = new URLLoader();
 *	load.dataFormat = URLLoaderDataFormat.BINARY;
 *	load.load(new URLRequest("data.png"));
 *	load.addEventListener(Event.COMPLETE, function(e : Event) : void {
 *		ImageAndTxt.uncompress(load.data, function(bmd : BitmapData, txt : String) : void {
 *			trace(txt);
 *			var bmp : Bitmap = new Bitmap(bmd);
 *			addChild(bmp);
 *		}
 * 	);
 * </pre>
 * @author xy
 */	
public class ImageAndTxt {
	
	/**
	 * 把图片和文本压缩成一个图片文件 
	 * @param imgData
	 * @param txtData
	 * @return 
	 */	
	public static function compress(imgData : ByteArray, txtData : String) : ByteArray{
		var txtBa : ByteArray = new ByteArray();
		txtBa.writeUTF(txtData);
		txtBa.compress();
		imgData.writeBytes(txtBa);
		imgData.writeInt(txtBa.length);
		return imgData;
	}
	
	/**
	 * 把压缩后的图片文件分解成  图片+文本
	 * @param imgData 压缩后的数据
	 * @param callBack 回调方式callBack(bmd : BitmapData, txt : String);
	 */	
	public static function uncompress(imgData : ByteArray, callBack : Function) : void {
		imgData.position = imgData.length - 4;
		var len : int = imgData.readInt();
		var txtBa : ByteArray = new ByteArray();
		imgData.position = imgData.length - 4 - len;
		imgData.readBytes(txtBa, 0, len);
		txtBa.uncompress();
		var txt : String = txtBa.readUTF();
		var bmdBa : ByteArray = new ByteArray();
		imgData.position = 0;
		imgData.readBytes(bmdBa, 0, imgData.length - 4 - len);
		
		var loader : Loader = new Loader();
		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e : Event) : void {
			callBack((loader.content as Bitmap).bitmapData, txt);
		});
		loader.loadBytes(bmdBa);
	}
}
}

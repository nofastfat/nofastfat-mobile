package com.xy.util {
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.utils.ByteArray;

/**
 * @author nofastfat
 * @E-mail: xiey147@163.com
 * @version 1.0.0
 * 创建时间：2013-8-22 下午03:16:30
 **/
public class Tools {

	/**
	 * 文件是否存在
	 * @param path
	 * @return
	 */
	public static function fileExists(path : String) : Boolean {
		try {
			var f : File = new File(path);
			if (!f.exists || f.isDirectory) {
				return false;
			}
		} catch (e : Error) {
			return false;
		}

		return true;
	}

	/**
	* 目录是否存在
	* @param path
	* @return
	*/
	public static function directoryExists(path : String) : Boolean {
		try {
			var f : File = new File(path);
			if (!f.exists || !f.isDirectory) {
				return false;
			}
		} catch (e : Error) {
			return false;
		}

		return true;
	}
	
	/**
	 * 读取XML文件内容 
	 * @param path
	 * @return 
	 */	
	public static function readXmlFrom(path : String) : XML{
		var f : File = new File(path);
		var fr : FileStream = new FileStream();
		fr.open(f, FileMode.READ);
		var ba : ByteArray = new ByteArray();
		fr.readBytes(ba, 0, fr.bytesAvailable);
		fr.close();
		
		return new XML(ba);
	}
}
}

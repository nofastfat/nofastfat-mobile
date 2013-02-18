package com.xy.util {
import com.xy.model.vo.HeroVo;

import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.net.registerClassAlias;

public class Cache {
	private static var f : File = new File(File.applicationStorageDirectory.nativePath + File.separator + "PantaKiller.data");

	public static function read() : * {

		if (!f.exists) {
			return null;
		}

		registerClassAlias("HeroVo", HeroVo);
		var fr : FileStream = new FileStream();
		fr.open(f, FileMode.READ);

		var rs : * = fr.readObject();
		fr.close();

		return rs;
	}

	public static function write(value : *) : void {
		registerClassAlias("HeroVo", HeroVo);
		var fr : FileStream = new FileStream();
		fr.open(f, FileMode.WRITE);
		fr.writeObject(value);
		fr.close();
	}
}
}

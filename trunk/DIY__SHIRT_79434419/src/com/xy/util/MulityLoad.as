package com.xy.util {
import com.xy.model.DiyDataProxy;
import com.xy.model.enum.DiyDataNotice;
import com.xy.model.vo.BitmapDataVo;

import flash.display.Bitmap;
import flash.display.Loader;
import flash.events.Event;
import flash.events.HTTPStatusEvent;
import flash.events.IOErrorEvent;
import flash.net.URLRequest;

import org.puremvc.as3.patterns.facade.Facade;

public class MulityLoad {
	
	private static var _intance : MulityLoad;
	
	public static function getInstance() : MulityLoad {
		if (_intance == null) {
			_intance = new MulityLoad();
		}
		
		return _intance;
	}
	
    private var _loader : Loader;
    private var _vos : Array;
    private var _call : Function;
    private var _current : BitmapDataVo;
	private var _sourceType:int;

    public function MulityLoad() {
        _loader = new Loader();
        _loader.contentLoaderInfo.addEventListener(Event.COMPLETE, __ok);
        _loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, __error);
    }

    public function load(vos : Array, call : Function, sourceType:int) : void {
		SLoading.getInstance().show();
        _loader.unloadAndStop();
        _vos = vos;
        _call = call;
		_sourceType = sourceType;

        next();
    }

    private function __ok(e : Event) : void {
        if (_loader.content != null && _current != null) {
            var bmp : Bitmap = _loader.content as Bitmap;

            if (bmp != null) {
                _current.bmd = bmp.bitmapData;
			}else{
				skipSource();
			}
        }

        next();
    }

    private function __error(e : Event) : void {
		skipSource();
        next();
    }

    private function next() : void {
        if (_vos.length == 0) {
			SLoading.getInstance().hide();
            _call();
			_call = null;
			return;
        }

        _current = _vos.shift();
        _loader.load(new URLRequest(_current.url));
    }
	
	private function skipSource():void{
		if(dataProxy != null){
			dataProxy.skipSource(_sourceType, _current);
		}
	}
	
	private function get dataProxy():DiyDataProxy{
		return Facade.getInstance().retrieveProxy(DiyDataProxy.NAME) as DiyDataProxy;
	}
}
}

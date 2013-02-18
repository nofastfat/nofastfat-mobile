package {
import com.greensock.TweenMax;

import flash.events.Event;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundTransform;
import flash.net.URLRequest;
import flash.utils.clearTimeout;
import flash.utils.setTimeout;

public class SoundManager {
	[Embed(source="media/sounds/loading.mp3")]
	private static var loading:Class;
	[Embed(source="media/sounds/mainMenu.mp3")]
	private static var mainMenu:Class;
	
	private static var _soundTrans : SoundTransform = new SoundTransform();

	private static var _channels : Array = [];
	
	private static var _sounds : Array = [];

	private static var _soundVolume : Number = 1;

	private static var _walk1Channel : SoundChannel;
	private static var _walk2Channel : SoundChannel;
	private static var _walk2TimeOut : uint;

	{
		_sounds["loading"] = new loading();
		_sounds["mainMenu"] = new mainMenu();
	}
	public static function playWalkSound() : void {
		if(_walk1Channel != null){
			return;
		}
		var s : Sound = Assets.getSound("walk1");
		_walk1Channel = s.play(0, int.MAX_VALUE, _soundTrans);
		
		var s2 : Sound = Assets.getSound("walk2");
		_walk2TimeOut = setTimeout(function():void{
			_walk2Channel = s2.play(0, int.MAX_VALUE, _soundTrans);
		}, 300);
	}

	public static function stopWalkSound() : void {
		clearTimeout(_walk2TimeOut);
		if (_walk1Channel != null) {
			_walk1Channel.stop();
			_walk1Channel = null;
		}
		
		if(_walk2Channel != null){
			_walk2Channel.stop();
			_walk2Channel = null;
		}
	}

	public static function play(name : String, loops : int = 0, singleModel : Boolean = true) : void {
		if (name == null || name == "") {
			return;
		}
		var s : Sound = _sounds[name];
		if (s == null) {
			var url : String ="/media/sounds/" + name + ".mp3"; 
			trace(url);  
			s = new Sound(new URLRequest(url));
			_sounds[name] = s;
		}

		if(loops == -1){
			loops = int.MAX_VALUE;
		}
		
		if (singleModel) {
			var channel : SoundChannel = _channels[name];
			if (channel == null) {
				channel = s.play(0, loops, _soundTrans);
				_channels[name] = channel;
				channel.addEventListener(Event.SOUND_COMPLETE, __playOverHandler);
			} else {
				channel.stop();
				channel.removeEventListener(Event.COMPLETE, __playOverHandler);
				channel = s.play(0, loops, _soundTrans);
				_channels[name] = channel;
				channel.addEventListener(Event.SOUND_COMPLETE, __playOverHandler);
			}
		} else {
			s.play(0, 1);
		}
	}

	private static function __playOverHandler(e : Event) : void {
		var channel : SoundChannel = e.currentTarget as SoundChannel;
		channel.removeEventListener(Event.COMPLETE, __playOverHandler);
		for (var name : String in _channels) {
			if (channel == _channels[name]) {
				delete _channels[name];
				return;
			}
		}
	}

	public static function stop(name : String) : void {
		var channel : SoundChannel = _channels[name];
		delete _channels[name];

		if (channel != null) {
			channel.removeEventListener(Event.COMPLETE, __playOverHandler);
			TweenMax.to(channel, 1, {volume: 0, onComplete: channel.stop});
		}
	}
}
}

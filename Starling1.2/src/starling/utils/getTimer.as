package starling.utils {
import starling.core.Starling;

/**
 * Same as flash.utils.getTimer,but work with Juggler.pause()
 */
public function getTimer() : int {
	if (Starling.juggler != null) {
		return int(Starling.juggler.elapsedTime*1000);
	}

	return 0;
}
}


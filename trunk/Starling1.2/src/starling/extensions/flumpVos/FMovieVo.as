package starling.extensions.flumpVos {

public class FMovieVo extends FBaseVo {
	public var frameRate : int;
	public var layers : Array = [];
	public var totalFrames : int;
	private var _frames : Array = [];
	
	public function FMovieVo() {
		super();
	}
	
	/**
	 * 获取指定帧上的FKfVo集合
	 * @param frameIndex 从1开始
	 * @return [FKfVo, FKfVo, ...]
	 */	
	public function getFrameAt(frameIndex : int) : Array{
		if(frameIndex > totalFrames){
			return null;
		}
		
		return _frames[frameIndex-1];
	}
	
	/**
	 *   <movie name="角色 - 副本/RB_Stand" frameRate="24">
	 *     <layer name="Layer 2">
	 *       <kf duration="1" ref="角色 - 副本/~MovieClip/sprite 38 (shadow)" tweened="false"/>
	 *     </layer>
	 *     <layer name="Layer 1">
	 *       <kf duration="1" ref="角色 - 副本/~MovieClip/sprite 1405" loc="11.15,-25.5" scale="0.9652,0.9596" skew="0.2497,-2.8919" tweened="false"/>
	 *     </layer>
	 *     <layer name="Layer 3">
	 *       <kf duration="1" ref="角色 - 副本/shape1896" loc="-13,-47" tweened="false"/>
	 *     </layer>
	 *     <layer name="Layer 8">
	 *       <kf duration="1" ref="角色 - 副本/~MovieClip/sprite 1519" loc="16.65,-6.55" scale="0.993,0.993" skew="1.7937,1.7937" tweened="false"/>
	 *     </layer>
	 *   </movie> 
	 * @param xml
	 * @return 
	 * 
	 */	
	public static function parseFrom(xml : XML):FMovieVo{
		var vo : FMovieVo = new FMovieVo();
		vo.name = String(xml.@name);
		vo.frameRate = int(xml.@layerXml);
		for each(var layerXml : XML in xml..layer){
			var layerVo : FLayerVo = FLayerVo.parseFrom(layerXml);
			vo.layers.push(layerVo);
			
			vo.totalFrames = Math.max(vo.totalFrames, layerVo.totalFrames);
		}
		
		for(var i : int = 0; i < vo.totalFrames; i++){
			var kfvos : Array = [];
			
			for(var j : int = 0; j < vo.layers.length; j++){
				var tmp : FLayerVo = vo.layers[j];
				var kfVo : FKfVo = tmp.getFrameAt(i + 1);
				if(kfVo != null){
					kfvos.push(kfVo);
				}
			}
			
			vo._frames[i] = kfvos;
		}
		return vo;
	}
}
}

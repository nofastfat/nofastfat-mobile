package starling.extensions.flumpVos {

public class FLayerVo extends FBaseVo {
	public var kfs : Array = [];
	public var totalFrames : int = 0;
	private var _frames : Array = [];
	
	public function FLayerVo() {
		super();
	}
	
	/**
	 * 获取指定帧的kfVO 
	 * @param frameIndex 从1开始
	 * @return 
	 */	
	public function getFrameAt(frameIndex : int): FKfVo{
		if(frameIndex > totalFrames){
			return null;
		}
		
		return _frames[frameIndex-1];
	}
	
	/**
     * <layer name="Layer 3">
     *   <kf duration="5" ref="角色 - 副本/shape1904" loc="-12.95,-48" tweened="false"/>
     *   <kf duration="5" ref="角色 - 副本/shape1905" loc="-12.95,-48" pivot="-2,1" tweened="false"/>
     *   <kf duration="5" ref="角色 - 副本/shape1907" loc="-12.95,-48" tweened="false"/>
     *   <kf duration="5" ref="角色 - 副本/shape1905" loc="-12.95,-48" pivot="-2,1" tweened="false"/>
     * </layer> 
	 * @param xml
	 * @return 
	 */	
	public static function parseFrom(xml : XML):FLayerVo{
		var vo : FLayerVo = new FLayerVo();
		
		vo.name = String(xml.@name);
		var xmlList : XMLList = xml..kf;
		var len : int = xmlList.length();
		var index : int = 0;
		
		for(var i : int = 0; i < len; i++){
			var fkXml : XML = xmlList[i];
			var kfVo : FKfVo = FKfVo.parseFrom(fkXml);
			vo.kfs.push(kfVo);
			vo.totalFrames += kfVo.duration;
			
			for(var j : int = 0; j < kfVo.duration; j++){
				vo._frames[index] = kfVo;
				index++;
			}
		}
		
		return vo;
	}
	
}
}

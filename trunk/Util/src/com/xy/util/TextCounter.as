package com.xy.util {

/**
 * 计算字符串的长度
 * 汉字算2个
 * 其他都算1个
 * @author xy
 */
public class TextCounter {
    public static function count(text : String) : int {
        var count : int = 0;
        var pattern : RegExp = /^[\u4E00-\u9FA5\uF900-\uFA2D]+$/; //验证中文
        for (var i : int = 0; i < text.length; i++) {
            var str : String = text.charAt(i);
            if (pattern.test(str)) {
                count += 2;
            } else {
                count += 1;
            }
        }
        return count;
    }
}
}

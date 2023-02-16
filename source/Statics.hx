import flixel.math.FlxMath;
import flixel.FlxG;

class Statics {
    public static inline final SOUND_EXT:String = #if web ".mp3" #else ".ogg" #end;
    public static function fpsLerp(cur:Float, target:Float):Float {
        return FlxMath.lerp(target, cur, boundTo(1 - (FlxG.elapsed * 9), 0, 1));
    }

    public static function boundTo(value:Float, min:Float, max:Float):Float {
		return Math.max(min, Math.min(max, value));
	}
}
package;

import flixel.FlxState;
import flixel.FlxSprite;
import Statics.*;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.group.FlxSpriteGroup;

using flixel.util.FlxSpriteUtil;

class PlayState extends FlxState
{
	public var circle:FlxSprite;
	public var titleText:FlxText;
	public var scoreText:FlxText;
	public static var score:Int = 0;
	public var textGroup:FlxSpriteGroup = new FlxSpriteGroup();
	public var things:Array<FlxSprite> = [];
	public var rainbowMode(default, set):Bool = false;
	public function set_rainbowMode(v:Bool) {
		FlxG.sound.play('assets/sounds/powerup$SOUND_EXT');
		if (!v) circle.drawCircle(-1, -1, -1, 0xffffdd1e);
		return rainbowMode = v;
	}
	public var rainbowModeText:FlxText;
	override public function create()
	{
		super.create();
		FlxG.camera.bgColor = 0xff1B1E2B;
		FlxG.sound.playMusic('assets/music/music$SOUND_EXT', 0.8);
		circle = new FlxSprite().makeGraphic(320, 320, flixel.util.FlxColor.TRANSPARENT);
		circle.drawCircle(-1, -1, -1, 0xffffdd1e);
		circle.screenCenter();
		add(circle);
		add(textGroup);
		titleText = new FlxText(0, 10, 800, "nondescript circle clicker").setFormat(null, 32, 0xffffffff, "center");
		add(titleText);
		insert(members.indexOf(titleText), things[0] = new FlxSprite().makeGraphic(800, Std.int(titleText.height + 20), 0xff000000));
		scoreText = new FlxText(0, 50, 800, "clicks: 0").setFormat(null, 32, 0xffffffff, "center");
		add(scoreText);
		insert(members.indexOf(scoreText), things[1] = new FlxSprite(0, FlxG.height - scoreText.height - 20).makeGraphic(800, Std.int(scoreText.height + 20), 0xff000000));
		scoreText.y = FlxG.height - scoreText.height - 10;
	}

	public var clickable:Bool = true;
	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		circle.scale.set(fpsLerp(circle.scale.x, 1), fpsLerp(circle.scale.y, 1));
		// detect if mouse is over circle and if mouse is pressed
		if (clickable && circle.x < FlxG.mouse.x && circle.x + circle.width > FlxG.mouse.x && circle.y < FlxG.mouse.y && circle.y + circle.height > FlxG.mouse.y && FlxG.mouse.justPressed)
			handleClick();
		if (score >= 250) {
			if (rainbowModeText.x < FlxG.mouse.x && rainbowModeText.x + rainbowModeText.width > FlxG.mouse.x && rainbowModeText.y < FlxG.mouse.y && rainbowModeText.y + rainbowModeText.height > FlxG.mouse.y && FlxG.mouse.justPressed)
				rainbowMode = !rainbowMode;
		}
		if (rainbowMode) updateRainbow(elapsed);
	}

	private function handleClick() {
		circle.scale.set(1.1, 1.1);
		FlxG.sound.play('assets/sounds/click$SOUND_EXT', 0.8);
		score++;
		scoreText.text = "clicks: " + score;
		if (score == 250) doRainbowMode();
		var motivationText:FlxText = new FlxText(0, 0, 0, motivationTexts[FlxG.random.int(0, motivationTexts.length - 1)]).setFormat(null, 24, 0xffffffff, "center");
		motivationText.setBorderStyle(OUTLINE, 0xff000000, 2);
		motivationText.scale.scale(1.1);
		motivationText.setPosition(FlxG.random.int(0, Std.int(FlxG.width - motivationText.width)), FlxG.random.int(Std.int(things[0].y + 50), Std.int(things[1].y - motivationText.height - 20)));
		textGroup.add(motivationText);
		flixel.tweens.FlxTween.tween(motivationText.scale, {x: 1, y: 1}, 0.1);
		flixel.tweens.FlxTween.tween(motivationText, {alpha: 0, angle: FlxG.random.int(-20, 20)}, 1, {ease: flixel.tweens.FlxEase.quartOut, startDelay: 0.1, onComplete: (t) -> {
			motivationText.destroy();
		}});
	}

	private function doRainbowMode() {
		FlxG.sound.play('assets/sounds/pop$SOUND_EXT');
		rainbowModeText = new FlxText(10, 0, 0, "rainbow mode").setFormat(null, 16, 0xffffffff, "center");
		rainbowModeText.y = FlxG.height - rainbowModeText.height - 10;
		add(rainbowModeText);
	}

	private var hue:Float = 0;
	private function updateRainbow(elapsed:Float) {
		circle.drawCircle(-1, -1, -1, flixel.util.FlxColor.fromHSL({hue = (hue + (elapsed * 100)) % 360; hue;}, 1, 0.8));
	}

	static final motivationTexts:Array<String> = ["yay!", "cool!", "you can do it!", "woohoo!", "nice!", "keep going!", "you're doing great!", "wow :)", "how amazing!", "oh joy", "circle!!!"];
}
